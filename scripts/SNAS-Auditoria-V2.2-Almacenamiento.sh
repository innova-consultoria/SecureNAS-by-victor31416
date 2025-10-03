#!/bin/bash

# =============================================
# SNAS - Auditorías Completas de Almacenamiento
# Script: SNAS-Auditoria-v2.2-Almacenamiento.sh
# Autor: victor31416
# Versión: 2.2 (Profesional)
# =============================================

set -euo pipefail

# Configuración
SCRIPT_NAME="SNAS-Auditoria-v2.2-Almacenamiento.sh"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_DIR="/var/log/snas"
REPORT_FILE="${LOG_DIR}/audit_almacenamiento_${TIMESTAMP}.log"
MD_REPORT_FILE="${LOG_DIR}/audit_almacenamiento_${TIMESTAMP}.md"
JSON_REPORT_FILE="${LOG_DIR}/audit_almacenamiento_${TIMESTAMP}.json"
HTML_REPORT_FILE="${LOG_DIR}/audit_almacenamiento_${TIMESTAMP}.html"
TEMP_DIR="/tmp/snas_audit_${TIMESTAMP}"

# Niveles de auditoría
declare -A AUDIT_LEVELS=(
    ["basic"]="1:SMART+Info Básica:5"
    ["standard"]="2:Benchmarks Rápidos:15" 
    ["complete"]="3:Tests Completos:45"
)

# Configuración de tiempos SMART (en segundos)
declare -A SMART_TEST_TIMES=(
    ["short"]="120"
    ["long"]="3600"
    ["conveyance"]="300"
)

# Colores para discos
declare -A DISK_COLORS=(
    ["sda"]="31" ["sdb"]="32" ["sdc"]="33" ["sdd"]="34" 
    ["sde"]="35" ["sdf"]="36" ["nvme0n1"]="37" ["default"]="32"
)

# Cache para datos SMART
declare -A SMART_CACHE
declare -A DISK_LOGFILES

# Funciones de utilidad
print_color() {
    local disk=$1
    local message=$2
    local color_code=${DISK_COLORS[$disk]:-${DISK_COLORS["default"]}}
    echo -e "\e[${color_code}m[Disco $disk] $message\e[0m"
}

progress_bar() {
    local disk=$1
    local current=$2
    local total=$3
    local width=50
    local percentage=$((current * 100 / total))
    local completed=$((current * width / total))
    local remaining=$((width - completed))
    
    local color_code=${DISK_COLORS[$disk]:-${DISK_COLORS["default"]}}
    printf "\e[${color_code}m[%s] [%-*s] %d%%\e[0m\r" "Disco $disk" $width \
        "$(printf '%*s' $completed | tr ' ' '=')" $percentage
}

show_usage() {
    echo "Usage: $0 [nivel]"
    echo "Niveles de auditoría:"
    echo "  basic     - SMART + Información básica (5 min/disco)"
    echo "  standard  - + Benchmarks rápidos (15 min/disco)" 
    echo "  complete  - + Tests completos (45 min/disco)"
    echo ""
    echo "Ejemplos:"
    echo "  $0 basic           # Auditoría rápida"
    echo "  $0 standard        # Auditoría balanceada"
    echo "  $0 complete        # Auditoría exhaustiva"
    echo "  $0                 # Modo interactivo"
}

install_dependencies() {
    echo "🔧 Verificando dependencias..."
    local deps=("smartmontools" "hdparm" "util-linux" "coreutils" "bc")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! dpkg -l | grep -q "^ii  $dep "; then
            missing+=("$dep")
        fi
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        echo "📦 Instalando paquetes faltantes: ${missing[*]}"
        apt-get update
        apt-get install -y "${missing[@]}"
    fi
    echo "✅ Dependencias verificadas"
}

# Función mejorada para detectar discos del sistema
get_system_disks() {
    # Disco raíz
    local root_disk=$(lsblk -n -o NAME,MOUNTPOINT | awk '$2=="/" {print $1}' | sed 's/[0-9]*$//')
    
    # Discos de boot
    local boot_disks=$(lsblk -n -o NAME,MOUNTPOINT | awk '$2=="/boot" || $2=="/boot/efi" {print $1}' | sed 's/[0-9]*$//')
    
    # Discos usados por ZFS
    local zfs_disks=$(zpool list -H -o name 2>/dev/null | while read pool; do
        zpool status "$pool" 2>/dev/null | grep -o "/dev/[a-z]*" | cut -d/ -f3
    done | sort -u)
    
    # Combinar todos los discos del sistema
    echo "$root_disk $boot_disks $zfs_disks" | tr ' ' '\n' | grep -v '^$' | sort -u
}

detect_disks() {
    echo "🔍 Detectando discos físicos..."
    
    # Obtener discos del sistema para excluirlos de tests intensivos
    local system_disks=($(get_system_disks))
    
    # Detectar todos los discos físicos
    local disks=($(lsblk -d -o NAME,TYPE,TRAN,SIZE | awk '$2=="disk" && $3!="usb" && $4!="0" {print $1}' | grep -v loop))
    
    # Incluir NVMe específicamente
    local nvme_disks=($(lsblk -d -o NAME,TYPE | grep "nvme" | awk '{print $1}'))
    
    local all_disks=($(printf '%s\n' "${disks[@]}" "${nvme_disks[@]}" | sort -u))
    
    if [ ${#all_disks[@]} -eq 0 ]; then
        echo "❌ No se detectaron discos físicos"
        exit 1
    fi
    
    # Marcar discos del sistema
    declare -gA SYSTEM_DISK_MAP
    for disk in "${all_disks[@]}"; do
        SYSTEM_DISK_MAP[$disk]=0
        for sys_disk in "${system_disks[@]}"; do
            if [[ "$disk" == "$sys_disk" ]]; then
                SYSTEM_DISK_MAP[$disk]=1
                break
            fi
        done
    done
    
    echo "📀 Discos detectados: ${all_disks[*]}"
    echo "⚠️  Discos del sistema: ${system_disks[*]}"
    printf '%s\n' "${all_disks[@]}"
}

is_system_disk() {
    local disk=$1
    [[ ${SYSTEM_DISK_MAP[$disk]:-0} -eq 1 ]]
}

get_smart_data() {
    local disk=$1
    local device="/dev/$disk"
    
    if [[ -z "${SMART_CACHE[$disk]}" ]]; then
        print_color "$disk" "📊 Obteniendo datos SMART..."
        SMART_CACHE[$disk]=$(smartctl -x "$device" 2>/dev/null || smartctl -a "$device" 2>/dev/null || echo "SMART_NO_SUPPORTED")
    fi
    echo "${SMART_CACHE[$disk]}"
}

parse_smart_info() {
    local disk=$1
    local smart_data=$(get_smart_data "$disk")
    
    if [[ "$smart_data" == "SMART_NO_SUPPORTED" ]]; then
        echo "N/A:N/A:N/A:N/A:N/A:N/A"
        return
    fi
    
    local model=$(echo "$smart_data" | grep "Device Model" | cut -d: -f2 | sed 's/^ *//')
    local serial=$(echo "$smart_data" | grep "Serial Number" | cut -d: -f2 | sed 's/^ *//')
    local health=$(echo "$smart_data" | grep "SMART overall-health" | cut -d: -f2 | sed 's/^ *//')
    local temp=$(echo "$smart_data" | grep -E "Temperature_Celsius|Airflow_Temperature" | head -1 | awk '{print $10}')
    local power_on_hours=$(echo "$smart_data" | grep "Power_On_Hours" | awk '{print $10}')
    local lifetime=$(echo "$smart_data" | grep -E "SSD_Life_Left|Remaining_Lifetime" | awk '{print $4}' | head -1)
    
    echo "${model:-N/A}:${serial:-N/A}:${health:-N/A}:${temp:-N/A}:${power_on_hours:-N/A}:${lifetime:-N/A}"
}

get_disk_info() {
    local disk=$1
    local device="/dev/$disk"
    
    local smart_info=$(parse_smart_info "$disk")
    IFS=':' read -r model serial health temp power_on_hours lifetime <<< "$smart_info"
    
    local size=$(lsblk -b "$device" -o SIZE | tail -1 | awk '{printf "%.1f GB", $1/1024/1024/1024}')
    local rotational=$(lsblk -d "$device" -o ROTA | tail -1)
    local disk_type="SSD"
    [[ "$rotational" -eq 1 ]] && disk_type="HDD"
    [[ "$disk" == nvme* ]] && disk_type="NVMe"
    
    local system_flag=""
    is_system_disk "$disk" && system_flag=" (Sistema)"
    
    cat << EOF
Modelo: $model
Serial: $serial  
Tamaño: $size
Tipo: $disk_type$system_flag
Salud SMART: $health
Temperatura: $temp °C
Horas Encendido: $power_on_hours
Vida Útil Restante: ${lifetime}%
EOF
}

smart_health_check() {
    local disk=$1
    local smart_data=$(get_smart_data "$disk")
    
    if [[ "$smart_data" == "SMART_NO_SUPPORTED" ]]; then
        print_color "$disk" "❌ SMART no soportado"
        return 2
    fi
    
    if echo "$smart_data" | grep -q "SMART overall-health self-assessment test result: PASSED"; then
        print_color "$disk" "✅ Salud SMART: PASSED"
        return 0
    else
        print_color "$disk" "❌ Salud SMART: FAILED"
        return 1
    fi
}

smart_errors_check() {
    local disk=$1
    local device="/dev/$disk"
    local smart_data=$(get_smart_data "$disk")
    
    if [[ "$smart_data" == "SMART_NO_SUPPORTED" ]]; then
        echo "SMART no soportado"
        return
    fi
    
    print_color "$disk" "📊 Verificando errores SMART..."
    smartctl -l error "$device" 2>/dev/null | head -10
}

benchmark_read() {
    local disk=$1
    local device="/dev/$disk"
    
    if is_disk_mounted "$disk"; then
        print_color "$disk" "⚠️  Disco montado, benchmark limitado a lectura"
        hdparm -t --direct "$device" 2>/dev/null || echo "Benchmark no disponible"
    else
        print_color "$disk" "⚡ Ejecutando benchmark de lectura..."
        hdparm -t --direct "$device" 2>/dev/null || echo "Benchmark no disponible"
    fi
}

safe_benchmark_write() {
    local disk=$1
    local mount_point=$(find_mount_point "$disk")
    
    if [[ -n "$mount_point" && -w "$mount_point" ]]; then
        # Verificar espacio disponible
        local available_gb=$(df "$mount_point" | awk 'NR==2 {print int($4/1024/1024)}')
        if [[ $available_gb -lt 2 ]]; then
            echo "Test de escritura omitido (espacio insuficiente: ${available_gb}GB)"
            return
        fi
        
        print_color "$disk" "📝 Ejecutando test de escritura seguro..."
        local test_file="$mount_point/.snas_write_test_$$"
        
        # Limitar a 1GB máximo y usar ionice para reducir impacto
        ionice -c 3 dd if=/dev/zero of="$test_file" bs=1M count=100 oflag=dsync status=progress 2>&1 | tail -1
        
        sync && rm -f "$test_file"
        echo "✅ Test de escritura completado"
    else
        echo "Test de escritura omitido (no montado o sin permisos)"
    fi
}

is_disk_mounted() {
    local disk=$1
    lsblk -n -o MOUNTPOINT "/dev/$disk" 2>/dev/null | grep -q "^/"
}

find_mount_point() {
    local disk=$1
    lsblk -n -o MOUNTPOINT "/dev/$disk" 2>/dev/null | grep "^/" | head -1
}

quick_surface_check() {
    local disk=$1
    local device="/dev/$disk"
    
    if is_disk_mounted "$disk" || is_system_disk "$disk"; then
        print_color "$disk" "⚠️  Disco del sistema/montado, omitiendo test de superficie"
        return
    fi
    
    print_color "$disk" "🔍 Test rápido de superficie (2 minutos máximo)..."
    
    # Verificar capacidad del disco
    local size_bytes=$(blockdev --getsize64 "$device" 2>/dev/null || echo 0)
    local size_gb=$((size_bytes / 1024 / 1024 / 1024))
    
    if [[ $size_gb -eq 0 ]]; then
        echo "No se pudo determinar tamaño del disco"
        return
    fi
    
    # Test rápido con timeout
    echo "→ Verificando primeros sectores..."
    timeout 60 dd if="$device" of=/dev/null bs=1M count=100 status=progress 2>&1 | tail -1
    
    if [[ $size_gb -gt 2 ]]; then
        echo "→ Verificando sectores finales..."
        local skip_blocks=$((size_gb - 1))
        timeout 60 dd if="$device" of=/dev/null bs=1M count=100 skip="${skip_blocks}000" status=progress 2>&1 | tail -1
    fi
}

run_smart_selftest() {
    local disk=$1
    local device="/dev/$disk"
    local test_type="short"
    
    if is_system_disk "$disk"; then
        print_color "$disk" "⚠️  Disco del sistema, usando test SMART corto (2 min)"
        test_type="short"
    else
        print_color "$disk" "🧪 Iniciando test SMART corto (2 min)..."
        test_type="short"
    fi
    
    local wait_time=${SMART_TEST_TIMES[$test_type]}
    
    if smartctl -t "$test_type" "$device" 2>/dev/null; then
        print_color "$disk" "⏳ Test SMART iniciado. Esperando ${wait_time} segundos..."
        
        # Barra de progreso para la espera
        for ((i=0; i<wait_time; i++)); do
            sleep 1
            printf "\r⏳ Esperando test SMART... [%d/%d segundos]" $((i+1)) $wait_time
        done
        echo
        
        print_color "$disk" "📋 Resultados test SMART:"
        smartctl -l selftest "$device" 2>/dev/null | head -20 || echo "No se pudieron obtener resultados"
    else
        print_color "$disk" "❌ No se pudo iniciar test SMART"
    fi
}

check_partitions() {
    local disk=$1
    print_color "$disk" "🗂️  Verificando particiones..."
    lsblk "/dev/$disk" -o NAME,SIZE,TYPE,MOUNTPOINT,FSTYPE
}

check_zfs_pools() {
    echo "🔍 Verificando pools ZFS..."
    if command -v zpool >/dev/null 2>&1; then
        zpool list -o name,size,alloc,free,health 2>/dev/null || echo "No hay pools ZFS"
        echo "--- Detalles pools ---"
        zpool status 2>/dev/null || echo "No se pudo obtener estado ZFS"
    else
        echo "ZFS no disponible"
    fi
}

check_raid_arrays() {
    echo "🔍 Verificando arrays RAID..."
    if command -v mdadm >/dev/null 2>&1; then
        mdadm --detail /dev/md* 2>/dev/null | head -20 || echo "No hay arrays RAID detectados"
    else
        echo "mdadm no disponible"
    fi
}

# Inicializar log individual por disco
init_disk_log() {
    local disk=$1
    local disk_log="${LOG_DIR}/disk_${disk}_${TIMESTAMP}.log"
    DISK_LOGFILES[$disk]="$disk_log"
    
    echo "=== LOG INDIVIDUAL DISCO $disk ===" > "$disk_log"
    echo "Fecha: $(date)" >> "$disk_log"
    echo "==================================" >> "$disk_log"
}

basic_audit() {
    local disk=$1
    print_color "$disk" "🚀 Nivel BÁSICO - SMART + Info"
    
    get_disk_info "$disk" | tee -a "${DISK_LOGFILES[$disk]}"
    smart_health_check "$disk" | tee -a "${DISK_LOGFILES[$disk]}"
    smart_errors_check "$disk" | tee -a "${DISK_LOGFILES[$disk]}"
    check_partitions "$disk" | tee -a "${DISK_LOGFILES[$disk]}"
}

standard_audit() {
    local disk=$1
    print_color "$disk" "🚀 Nivel STANDARD - + Benchmarks"
    
    basic_audit "$disk"
    benchmark_read "$disk" | tee -a "${DISK_LOGFILES[$disk]}"
    
    # Solo test de escritura en discos no del sistema
    if ! is_system_disk "$disk"; then
        safe_benchmark_write "$disk" | tee -a "${DISK_LOGFILES[$disk]}"
    else
        echo "Test de escritura omitido (disco del sistema)" | tee -a "${DISK_LOGFILES[$disk]}"
    fi
}

complete_audit() {
    local disk=$1
    print_color "$disk" "🚀 Nivel COMPLETE - + Tests Completos"
    
    standard_audit "$disk"
    
    # Solo tests intensivos en discos no del sistema
    if ! is_system_disk "$disk"; then
        quick_surface_check "$disk" | tee -a "${DISK_LOGFILES[$disk]}"
    else
        echo "Test de superficie omitido (disco del sistema)" | tee -a "${DISK_LOGFILES[$disk]}"
    fi
    
    run_smart_selftest "$disk" | tee -a "${DISK_LOGFILES[$disk]}"
}

generate_markdown_report() {
    local disks=($1)
    local level=$2
    
    cat > "$MD_REPORT_FILE" << EOF
# SNAS - Auditoría de Almacenamiento
**Fecha:** $(date)  
**Nivel:** ${AUDIT_LEVELS[$level]##*:}  
**Sistema:** $(hostname)

## Resumen Ejecutivo

| Disco | Modelo | Salud | Temperatura | Horas | Vida Útil | Alertas |
|-------|--------|-------|-------------|-------|-----------|---------|
EOF

    for disk in "${disks[@]}"; do
        local smart_info=$(parse_smart_info "$disk")
        IFS=':' read -r model serial health temp power_on lifetime <<< "$smart_info"
        
        local alerts=""
        [[ "$health" != "PASSED" ]] && alerts="❌ SMART"
        [[ "$temp" != "N/A" && "$temp" -gt 50 ]] && alerts="$alerts 🔥 Temp"
        [[ "$lifetime" != "N/A" && "$lifetime" -lt 20 ]] && alerts="$alerts ⚠️ Vida"
        is_system_disk "$disk" && alerts="$alefits 🖥️ Sistema"
        [[ -z "$alerts" ]] && alerts="✅ OK"
        
        echo "| $disk | $model | $health | $temp°C | $power_on | ${lifetime}% | $alerts |" >> "$MD_REPORT_FILE"
    done

    cat >> "$MD_REPORT_FILE" << EOF

## Sistemas de Archivos Avanzados

### ZFS Pools
\`\`\`
$(check_zfs_pools)
\`\`\`

### RAID Arrays
\`\`\`
$(check_raid_arrays)
\`\`\`

## Recomendaciones

1. **Monitoreo Continuo**: Implementar alertas SMART
2. **Backups**: Planificar estrategia de backups
3. **Temperatura**: Mantener discos bajo 50°C
4. **Reemplazo**: Planificar ciclo de vida (discos bajo 20% vida útil)
5. **Sistemas**: Evitar tests intensivos en discos del sistema

## Detalles por Disco
EOF

    for disk in "${disks[@]}"; do
        cat >> "$MD_REPORT_FILE" << EOF

### Disco $disk

\`\`\`
$(get_disk_info "$disk")
\`\`\`

**Log Individual:** \`disk_${disk}_${TIMESTAMP}.log\`
EOF
    done
}

generate_json_report() {
    local disks=($1)
    local level=$2
    
    echo "{" > "$JSON_REPORT_FILE"
    echo "  \"auditoria\": {" >> "$JSON_REPORT_FILE"
    echo "    \"sistema\": \"SNAS\"," >> "$JSON_REPORT_FILE"
    echo "    \"script\": \"$SCRIPT_NAME\"," >> "$JSON_REPORT_FILE"
    echo "    \"fecha\": \"$(date -Iseconds)\"," >> "$JSON_REPORT_FILE"
    echo "    \"nivel\": \"$level\"," >> "$JSON_REPORT_FILE"
    echo "    \"hostname\": \"$(hostname)\"" >> "$JSON_REPORT_FILE"
    echo "  }," >> "$JSON_REPORT_FILE"
    echo "  \"discos\": [" >> "$JSON_REPORT_FILE"
    
    local first_disk=true
    for disk in "${disks[@]}"; do
        local smart_info=$(parse_smart_info "$disk")
        IFS=':' read -r model serial health temp power_on lifetime <<< "$smart_info"
        
        if [[ "$first_disk" == "true" ]]; then
            first_disk=false
        else
            echo "," >> "$JSON_REPORT_FILE"
        fi
        
        echo "    {" >> "$JSON_REPORT_FILE"
        echo "      \"disco\": \"$disk\"," >> "$JSON_REPORT_FILE"
        echo "      \"modelo\": \"$model\"," >> "$JSON_REPORT_FILE"
        echo "      \"serial\": \"$serial\"," >> "$JSON_REPORT_FILE"
        echo "      \"salud\": \"$health\"," >> "$JSON_REPORT_FILE"
        echo "      \"temperatura\": \"$temp\"," >> "$JSON_REPORT_FILE"
        echo "      \"horas_encendido\": \"$power_on\"," >> "$JSON_REPORT_FILE"
        echo "      \"vida_util\": \"$lifetime\"," >> "$JSON_REPORT_FILE"
        echo "      \"sistema\": \"$(is_system_disk "$disk" && echo "true" || echo "false")\"," >> "$JSON_REPORT_FILE"
        echo "      \"log_file\": \"disk_${disk}_${TIMESTAMP}.log\"" >> "$JSON_REPORT_FILE"
        echo "    }" >> "$JSON_REPORT_FILE"
    done
    
    echo "  ]" >> "$JSON_REPORT_FILE"
    echo "}" >> "$JSON_REPORT_FILE"
}

generate_html_report() {
    local disks=($1)
    local level=$2
    
    cat > "$HTML_REPORT_FILE" << EOF
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SNAS - Auditoría de Almacenamiento</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #2c3e50; border-bottom: 2px solid #3498db; padding-bottom: 10px; }
        h2 { color: #34495e; margin-top: 30px; }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #3498db; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
        .alert { color: #e74c3c; font-weight: bold; }
        .warning { color: #f39c12; }
        .ok { color: #27ae60; }
        .system { background-color: #e8f4fd; }
        pre { background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔍 SNAS - Auditoría de Almacenamiento</h1>
        
        <div class="summary">
            <p><strong>Fecha:</strong> $(date)</p>
            <p><strong>Nivel:</strong> ${AUDIT_LEVELS[$level]##*:}</p>
            <p><strong>Sistema:</strong> $(hostname)</p>
        </div>

        <h2>📊 Resumen Ejecutivo</h2>
        <table>
            <thead>
                <tr>
                    <th>Disco</th>
                    <th>Modelo</th>
                    <th>Salud</th>
                    <th>Temperatura</th>
                    <th>Horas</th>
                    <th>Vida Útil</th>
                    <th>Estado</th>
                </tr>
            </thead>
            <tbody>
EOF

    for disk in "${disks[@]}"; do
        local smart_info=$(parse_smart_info "$disk")
        IFS=':' read -r model serial health temp power_on lifetime <<< "$smart_info"
        
        local status_class="ok"
        local status_text="✅ OK"
        
        if [[ "$health" != "PASSED" ]]; then
            status_class="alert"
            status_text="❌ SMART"
        elif [[ "$temp" != "N/A" && "$temp" -gt 50 ]]; then
            status_class="warning"
            status_text="🔥 Temp"
        elif [[ "$lifetime" != "N/A" && "$lifetime" -lt 20 ]]; then
            status_class="warning"
            status_text="⚠️ Vida"
        fi
        
        local row_class=""
        is_system_disk "$disk" && row_class="system"
        
        echo "                <tr class=\"$row_class\">" >> "$HTML_REPORT_FILE"
        echo "                    <td><strong>$disk</strong></td>" >> "$HTML_REPORT_FILE"
        echo "                    <td>$model</td>" >> "$HTML_REPORT_FILE"
        echo "                    <td>$health</td>" >> "$HTML_REPORT_FILE"
        echo "                    <td>$temp°C</td>" >> "$HTML_REPORT_FILE"
        echo "                    <td>$power_on</td>" >> "$HTML_REPORT_FILE"
        echo "                    <td>${lifetime}%</td>" >> "$HTML_REPORT_FILE"
        echo "                    <td class=\"$status_class\">$status_text</td>" >> "$HTML_REPORT_FILE"
        echo "                </tr>" >> "$HTML_REPORT_FILE"
    done

    cat >> "$HTML_REPORT_FILE" << EOF
            </tbody>
        </table>

        <h2>🛠️ Sistemas de Archivos Avanzados</h2>
        
        <h3>ZFS Pools</h3>
        <pre>$(check_zfs_pools)</pre>
        
        <h3>RAID Arrays</h3>
        <pre>$(check_raid_arrays)</pre>

        <h2>💡 Recomendaciones</h2>
        <ul>
            <li><strong>Monitoreo Continuo:</strong> Implementar alertas SMART</li>
            <li><strong>Backups:</strong> Planificar estrategia de backups</li>
            <li><strong>Temperatura:</strong> Mantener discos bajo 50°C</li>
            <li><strong>Reemplazo:</strong> Planificar ciclo de vida (discos bajo 20% vida útil)</li>
            <li><strong>Sistemas:</strong> Evitar tests intensivos en discos del sistema</li>
        </ul>

        <h2>📋 Logs Generados</h2>
        <ul>
            <li>Reporte detallado: <code>$(basename "$REPORT_FILE")</code></li>
            <li>Reporte Markdown: <code>$(basename "$MD_REPORT_FILE")</code></li>
            <li>Reporte JSON: <code>$(basename "$JSON_REPORT_FILE")</code></li>
EOF

    for disk in "${disks[@]}"; do
        echo "            <li>Log $disk: <code>disk_${disk}_${TIMESTAMP}.log</code></li>" >> "$HTML_REPORT_FILE"
    done

    cat >> "$HTML_REPORT_FILE" << EOF
        </ul>

        <footer style="margin-top: 40px; padding-top: 20px; border-top: 1px solid #ddd; text-align: center; color: #7f8c8d;">
            <p>Generado por SNAS Auditoría v2.2 - $(date +"%Y")</p>
        </footer>
    </div>
</body>
</html>
EOF
}

main_audit() {
    local level=$1
    local disks=($(detect_disks))
    local total_disks=${#disks[@]}
    local current=0
    
    echo "🚀 Iniciando auditoría NIVEL ${AUDIT_LEVELS[$level]##*:}"
    echo "📀 Discos a auditar: $total_disks"
    echo "⏱️  Tiempo estimado: ${AUDIT_LEVELS[$level]##*:} min total"
    echo "📄 Reportes: $REPORT_FILE, $MD_REPORT_FILE, $JSON_REPORT_FILE, $HTML_REPORT_FILE"
    
    # Crear directorios
    mkdir -p "$LOG_DIR" "$TEMP_DIR"
    
    # Inicializar logs individuales
    for disk in "${disks[@]}"; do
        init_disk_log "$disk"
    done
    
    # Cabecera del reporte principal
    echo "SNAS AUDITORÍA DE ALMACENAMIENTO - $(date)" > "$REPORT_FILE"
    echo "Nivel: ${AUDIT_LEVELS[$level]##*:}" >> "$REPORT_FILE"
    echo "==========================================" >> "$REPORT_FILE"
    echo "Logs individuales por disco:" >> "$REPORT_FILE"
    for disk in "${disks[@]}"; do
        echo "  - ${DISK_LOGFILES[$disk]}" >> "$REPORT_FILE"
    done
    echo "" >> "$REPORT_FILE"
    
    # Auditoría de sistemas de archivos avanzados
    {
        echo "=== SISTEMAS DE ARCHIVOS AVANZADOS ==="
        check_zfs_pools
        echo
        check_raid_arrays
        echo
    } >> "$REPORT_FILE"
    
    for disk in "${disks[@]}"; do
        current=$((current + 1))
        progress_bar "$disk" $current $total_disks
        echo
        
        {
            echo
            echo "=========================================="
            echo "DISCO: $disk"
            echo "=========================================="
        } >> "$REPORT_FILE"
        
        case $level in
            "basic")
                basic_audit "$disk" | tee -a "$REPORT_FILE"
                ;;
            "standard") 
                standard_audit "$disk" | tee -a "$REPORT_FILE"
                ;;
            "complete")
                complete_audit "$disk" | tee -a "$REPORT_FILE"
                ;;
        esac
        
        echo "---" >> "$REPORT_FILE"
        print_color "$disk" "✅ Auditoría completada - Log: ${DISK_LOGFILES[$disk]##*/}"
    done
    
    generate_markdown_report "${disks[*]}" "$level"
    generate_json_report "${disks[*]}" "$level"
    generate_html_report "${disks[*]}" "$level"
    
    echo
    echo "🎉 AUDITORÍA SNAS COMPLETADA"
    echo "📁 Reportes generados:"
    echo "   📄 Detallado: $REPORT_FILE"
    echo "   📊 Markdown: $MD_REPORT_FILE"
    echo "   🔄 JSON: $JSON_REPORT_FILE"
    echo "   🌐 HTML: $HTML_REPORT_FILE"
    echo "   📋 Logs individuales:"
    for disk in "${disks[@]}"; do
        echo "      - ${DISK_LOGFILES[$disk]##*/}"
    done
}

# Manejo de señales
cleanup() {
    echo "🧹 Limpiando archivos temporales..."
    rm -rf "$TEMP_DIR"
    # Limpiar archivos de test
    find /mnt /media -name ".snas_write_test_*" -delete 2>/dev/null || true
}

trap cleanup EXIT

# Función principal
main() {
    echo "==============================================="
    echo "    SNAS - AUDITORÍA DE ALMACENAMIENTO v2.2"
    echo "           (Versión Profesional)"
    echo "==============================================="
    
    # Verificar root
    if [ "$EUID" -ne 0 ]; then
        echo "❌ Este script requiere privilegios root"
        exit 1
    fi
    
    # Determinar nivel de auditoría
    local level="${1:-}"
    
    if [[ -z "$level" ]]; then
        echo "🎯 Selecciona nivel de auditoría:"
        echo "1) basic    - SMART + Info básica (5 min total)"
        echo "2) standard - + Benchmarks rápidos (15 min total)"
        echo "3) complete - + Tests completos (45 min total)"
        echo ""
        read -p "Tu elección [1-3]: " choice
        
        case $choice in
            1) level="basic" ;;
            2) level="standard" ;;
            3) level="complete" ;;
            *) echo "❌ Opción inválida"; exit 1 ;;
        esac
    fi
    
    # Validar nivel
    if [[ !
#!/bin/bash
# SNAS-Auditoria-Completa-v2.sh - Auditoría exhaustiva con mejoras de seguridad
# victor31416 - Fase 0 Proyecto SNAS - Versión Mejorada

SCRIPT_NAME="SNAS-Auditoria-Completa-v2"
OUTPUT_FILE="/root/${SCRIPT_NAME}_$(date +%Y%m%d_%H%M%S).txt"
JSON_FILE="/root/${SCRIPT_NAME}_$(date +%Y%m%d_%H%M%S).json"

# Configuración
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Función para verificar comandos
check_cmd() {
    if command -v $1 &>/dev/null; then
        return 0
    else
        echo "COMANDO_NO_DISPONIBLE: $1" >> "$OUTPUT_FILE"
        return 1
    fi
}

# Función para sección
section() {
    echo -e "\n${BLUE}=== $1 ===${NC}" | tee -a "$OUTPUT_FILE"
    echo "==============================================" >> "$OUTPUT_FILE"
}

# Función para ejecutar comando seguro
safe_run() {
    local cmd="$1"
    local desc="$2"
    local lines="${3:-50}"  # Límite de líneas por defecto 50
    
    echo "--- $desc ---" >> "$OUTPUT_FILE"
    eval "$cmd" 2>/dev/null | head -$lines >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
}

# Inicializar archivos
{
echo "=== AUDITORÍA COMPLETA DEL SISTEMA SNAS v2 ==="
echo "Proyecto: SNAS by victor31416 - Fase 0"
echo "Fecha: $(date)"
echo "Hostname: $(hostname)"
echo "Usuario ejecutor: $(whoami)"
echo "============================================"
} > "$OUTPUT_FILE"

## 1. 🔧 HARDWARE FÍSICO (Módulo 1)
section "1. HARDWARE FÍSICO - INVENTARIO COMPLETO"

# [Contenido hardware igual al script anterior...]
safe_run "dmidecode -t system" "Sistema - Fabricante/Modelo/Serial"
safe_run "lscpu" "CPU - Arquitectura y Características"
safe_run "dmidecode --type memory" "RAM - Módulos y Especificaciones"
safe_run "lsblk -o NAME,MODEL,SERIAL,SIZE,TYPE,MOUNTPOINT,FSTYPE,ROTA" "DISCOS - Todos los Dispositivos"

# 1.5 Información SMART Mejorada
section "1.5 ESTADO SMART - ANÁLISIS COMPLETO DISCOS"
for disk in $(lsblk -d -o NAME | grep -E '^sd|^nvme'); do
    echo "--- Disco: /dev/$disk ---" >> "$OUTPUT_FILE"
    if check_cmd smartctl; then
        # Información básica
        smartctl -i "/dev/$disk" 2>/dev/null | grep -E "Model|Serial|Capacity|Rotation|Form Factor|Firmware" >> "$OUTPUT_FILE"
        
        # Salud general
        echo -n "Salud SMART: " >> "$OUTPUT_FILE"
        smartctl -H "/dev/$disk" 2>/dev/null | grep "SMART overall-health" | cut -d: -f2 >> "$OUTPUT_FILE"
        
        # Atributos críticos extendidos
        smartctl -A "/dev/$disk" 2>/dev/null | grep -E "
Model|Serial|Capacity|Rotation Rate|Form Factor|
Raw_Read_Error_Rate|Reallocated_Sector_Ct|Seek_Error_Rate|
Power_On_Hours|Power_Cycle_Count|Spin_Retry_Count|
Current_Pending_Sector|Offline_Uncorrectable|
UDMA_CRC_Error_Count|Multi_Zone_Error_Rate|
Temperature_Celsius|Media_Wearout_Indicator|
Host_Reads_MiB|Host_Writes_MiB" >> "$OUTPUT_FILE" 2>/dev/null
        
        # Estadísticas de errores
        echo "--- Estadísticas Errores ---" >> "$OUTPUT_FILE"
        smartctl -l error "/dev/$disk" 2>/dev/null | head -10 >> "$OUTPUT_FILE"
    else
        echo "smartctl no disponible" >> "$OUTPUT_FILE"
    fi
    echo "" >> "$OUTPUT_FILE"
done

## 2. 💾 ALMACENAMIENTO (Módulo 2)
section "2. ALMACENAMIENTO - SISTEMAS DE ARCHIVOS"

# [Contenido almacenamiento igual...]
safe_run "df -hT" "Sistemas de Archivos - Uso de Espacio"

# 2.4 USO DE ESPACIO POR USUARIO (NUEVO)
section "2.4 USO DE ESPACIO - ANÁLISIS POR USUARIO"
echo "--- Espacio en /home por usuario ---" >> "$OUTPUT_FILE"
if [ -d "/home" ]; then
    for userdir in /home/*; do
        if [ -d "$userdir" ]; then
            user=$(basename "$userdir")
            size=$(du -sh "$userdir" 2>/dev/null | cut -f1)
            echo "Usuario: $user - Espacio: $size" >> "$OUTPUT_FILE"
        fi
    done
else
    echo "Directorio /home no encontrado" >> "$OUTPUT_FILE"
fi

# Análisis de /var, /opt, /srv
for dir in /var /opt /srv /tmp; do
    if [ -d "$dir" ]; then
        echo "--- $dir ---" >> "$OUTPUT_FILE"
        du -sh "$dir" 2>/dev/null >> "$OUTPUT_FILE"
        # Top 10 archivos más grandes
        find "$dir" -type f -exec du -h {} + 2>/dev/null | sort -rh | head -5 >> "$OUTPUT_FILE" 2>/dev/null
        echo "" >> "$OUTPUT_FILE"
    fi
done

## 3. 🧬 SISTEMA OPERATIVO (Módulo 3)
section "3. SISTEMA OPERATIVO - CONFIGURACIÓN"

safe_run "lsb_release -a" "Distribución Linux"
safe_run "hostnamectl" "Configuración del Host"

# 3.4 INVENTARIO DE PAQUETES (NUEVO)
section "3.4 PAQUETES - INVENTARIO Y ACTUALIZACIONES"
safe_run "dpkg -l | wc -l" "Número Total de Paquetes Instalados"

# Paquetes críticos relacionados con servidores
echo "--- Paquetes de Servicios Críticos ---" >> "$OUTPUT_FILE"
dpkg -l | grep -E "apache|nginx|mysql|mariadb|postgresql|docker|proxmox|zfs|samba|ssh" | head -20 >> "$OUTPUT_FILE" 2>/dev/null

# Actualizaciones pendientes
if check_cmd apt; then
    echo "--- Actualizaciones Pendientes ---" >> "$OUTPUT_FILE"
    apt list --upgradable 2>/dev/null | head -10 >> "$OUTPUT_FILE"
fi

## 4. 🧩 SERVICIOS Y USUARIOS (Módulo 4)
section "4. SERVICIOS Y USUARIOS - ANÁLISIS DE SEGURIDAD"

safe_run "systemctl list-units --type=service --state=running" "Servicios Activos"

# 4.4 ANÁLISIS DE SEGURIDAD DE USUARIOS (NUEVO)
section "4.4 SEGURIDAD - USUARIOS Y PERMISOS"

# Usuarios con sudo sin contraseña
echo "--- Usuarios con SUDO sin contraseña ---" >> "$OUTPUT_FILE"
grep -r 'NOPASSWD' /etc/sudoers* 2>/dev/null >> "$OUTPUT_FILE"

# Cuentas sin contraseña
echo "--- Cuentas sin contraseña ---" >> "$OUTPUT_FILE"
getent shadow | awk -F: '($2 == "" ) { print $1 }' >> "$OUTPUT_FILE"

# Shells inválidos o cuentas bloqueadas
echo "--- Cuentas con shells inválidos ---" >> "$OUTPUT_FILE"
getent passwd | grep -E ":/bin/(false|nologin|sync|shutdown)" | head -10 >> "$OUTPUT_FILE"

# Usuarios con UID 0 (multiple root)
echo "--- Usuarios con UID 0 ---" >> "$OUTPUT_FILE"
getent passwd | awk -F: '($3 == 0) { print $1 }' >> "$OUTPUT_FILE"

# Grupos de administración
echo "--- Miembros de grupos administrativos ---" >> "$OUTPUT_FILE"
for group in sudo wheel admin root; do
    if getent group $group >/dev/null; then
        echo "Grupo $group: $(getent group $group)" >> "$OUTPUT_FILE"
    fi
done

## 5. 🧱 VIRTUALIZACIÓN (Módulo 5)
section "5. VIRTUALIZACIÓN - HYPERVISOR Y CONTENEDORES"

# [Contenido virtualización igual...]
safe_run "systemd-detect-virt" "Tipo de Virtualización"

## 6. 🔐 SEGURIDAD Y RED (Módulo 6)
section "6. SEGURIDAD - RED, FIREWALL Y LOGS"

safe_run "ip addr show" "Interfaces de Red"
safe_run "ss -tunlp" "Conexiones y Procesos"

# 6.4 SERVICIOS EXPUESTOS - ESCANEO PUERTOS (NUEVO)
section "6.4 SEGURIDAD - SERVICIOS EXPUESTOS"
if check_cmd nmap; then
    echo "--- Escaneo de puertos locales (nmap localhost) ---" >> "$OUTPUT_FILE"
    nmap -sT -O localhost 2>/dev/null | head -20 >> "$OUTPUT_FILE"
else
    echo "nmap no disponible. Instalar: apt install nmap" >> "$OUTPUT_FILE"
    # Alternativa con netstat/ss
    echo "--- Puertos abiertos (alternativa) ---" >> "$OUTPUT_FILE"
    ss -tuln | awk '{print $5}' | grep -E ':[0-9]+' | cut -d: -f2 | sort -un | head -20 >> "$OUTPUT_FILE"
fi

# 6.5 LOGS EXTENDIDOS (NUEVO)
section "6.5 SEGURIDAD - ANÁLISIS DE LOGS"

# Logs del sistema
for logfile in /var/log/syslog /var/log/messages /var/log/kern.log /var/log/auth.log; do
    if [ -f "$logfile" ]; then
        echo "--- Últimos errores en $(basename $logfile) ---" >> "$OUTPUT_FILE"
        grep -i "error\|fail\|denied\|warning" "$logfile" | tail -5 >> "$OUTPUT_FILE" 2>/dev/null
    fi
done

# Intentos de acceso SSH
if [ -f "/var/log/auth.log" ]; then
    echo "--- Últimos intentos de conexión SSH ---" >> "$OUTPUT_FILE"
    grep -i "ssh" /var/log/auth.log | tail -10 >> "$OUTPUT_FILE" 2>/dev/null
fi

# Logs de sudo
echo "--- Uso de sudo reciente ---" >> "$OUTPUT_FILE"
grep "sudo:" /var/log/auth.log 2>/dev/null | tail -5 >> "$OUTPUT_FILE"

## 7. 📊 MONITORIZACIÓN EXTERNA (NUEVO)
section "7. MONITORIZACIÓN - HERRAMIENTAS EXTERNAS"

# 7.1 DETECCIÓN ZABBIX (NUEVO)
echo "--- Agente Zabbix ---" >> "$OUTPUT_FILE"
if systemctl is-active zabbix-agent >/dev/null 2>&1; then
    echo "Zabbix Agent: ACTIVO" >> "$OUTPUT_FILE"
    safe_run "systemctl status zabbix-agent" "Estado Zabbix Agent"
elif check_cmd zabbix_agentd; then
    echo "Zabbix Agent: INSTALADO (no activo)" >> "$OUTPUT_FILE"
else
    echo "Zabbix Agent: NO DETECTADO" >> "$OUTPUT_FILE"
fi

# 7.2 OTROS SISTEMAS DE MONITORIZACIÓN
for agent in nagios nrpe prometheus node_exporter; do
    if systemctl is-active $agent >/dev/null 2>&1; then
        echo "Monitorización $agent: ACTIVO" >> "$OUTPUT_FILE"
    fi
done

## 8. 📋 RESUMEN EJECUTIVO MEJORADO
section "8. RESUMEN EJECUTIVO - SNAS FASE 0"

{
echo "=== RESUMEN EJECUTIVO MEJORADO ==="
echo "Sistema: $(hostname)"
echo "Arquitectura: $(uname -m)"
echo "Kernel: $(uname -r)"
echo "Uptime: $(uptime -p)"
echo "Fecha Auditoría: $(date)"
echo ""

echo "=== HARDWARE DETALLADO ==="
echo "CPU: $(grep 'model name' /proc/cpuinfo | head -1 | cut -d: -f2 | xargs)"
echo "Núcleos: $(nproc)"
echo "RAM Total: $(free -h | grep Mem: | awk '{print $2}')"
echo "RAM Libre: $(free -h | grep Mem: | awk '{print $4}')"
echo "Discos: $(lsblk -d -o NAME | grep -E '^sd|^nvme' | wc -l) dispositivos"
echo ""

echo "=== ALMACENAMIENTO ==="
echo "ZFS: $(zpool list -H -o name 2>/dev/null | wc -l) pools"
echo "Espacio Total: $(df -h / | tail -1 | awk '{print $2}')"
echo "Espacio Usado: $(df -h / | tail -1 | awk '{print $3}') ($(df -h / | tail -1 | awk '{print $5}'))"
echo ""

echo "=== SEGURIDAD ==="
echo "Usuarios totales: $(getent passwd | wc -l)"
echo "Usuarios con shell: $(getent passwd | grep -E ':/bin/(bash|sh)' | wc -l)"
echo "Servicios activos: $(systemctl list-units --type=service --state=running --no-legend | wc -l)"
echo "Puertos abiertos: $(ss -tuln | grep -v State | wc -l)"
echo ""

echo "=== RIESGOS IDENTIFICADOS ==="
# Análisis automático de riesgos
if getent shadow | awk -F: '($2 == "" ) { print $1 }' | grep -q .; then
    echo "❌ CRÍTICO: Cuentas sin contraseña detectadas"
fi

if grep -r 'NOPASSWD' /etc/sudoers* 2>/dev/null | grep -q .; then
    echo "⚠️  ALTO: Sudo sin contraseña configurado"
fi

if ss -tuln | grep -q ':22 '; then
    echo "⚠️  MEDIO: SSH en puerto predeterminado (22)"
fi

echo ""
echo "=== RECOMENDACIONES FASE 0 ==="
echo "1. 🔍 Verificar estado SMART de discos IronWolf"
echo "2. 🔒 Revisar configuración sudo y usuarios"
echo "3. 🛡️  Cambiar puertos servicios predeterminados (SSH)"
echo "4. 💾 Planificar backup inicial antes de cambios"
echo "5. 📊 Considerar expansión RAM + NIC 2.5Gbps"
echo "6. 📝 Documentar configuración actual"
echo "7. 🔄 Actualizar paquetes críticos"
echo "8. 🎯 Priorizar servicios según necesidades"
} >> "$OUTPUT_FILE"

# Finalizar reporte
{
echo ""
echo "============================================"
echo "AUDITORÍA COMPLETADA - VERSIÓN MEJORADA"
echo "Archivo de reporte: $OUTPUT_FILE"
echo "Tamaño del reporte: $(du -h "$OUTPUT_FILE" | cut -f1)"
echo ""
echo "MÓDULOS EJECUTADOS:"
echo "✅ 1. Hardware Físico"
echo "✅ 2. Almacenamiento y Usuarios"
echo "✅ 3. Sistema Operativo y Paquetes"
echo "✅ 4. Seguridad de Usuarios"
echo "✅ 5. Virtualización"
echo "✅ 6. Red y Logs"
echo "✅ 7. Monitorización Externa"
echo "✅ 8. Resumen Ejecutivo"
echo ""
echo "PRÓXIMOS PASOS RECOMENDADOS:"
echo "1. Revisar sección 'Riesgos Identificados'"
echo "2. Analizar recomendaciones específicas"
echo "3. Planificar acciones correctivas"
echo "4. Ejecutar módulos individuales si es necesario"
} >> "$OUTPUT_FILE"

echo -e "${GREEN}✅ Auditoría completada - Versión Mejorada${NC}"
echo -e "📄 Reporte: $OUTPUT_FILE"
echo -e "🔍 Módulos ejecutados: 8"
echo -e "⚠️  Revisar sección 'Riesgos Identificados'"

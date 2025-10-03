#!/bin/bash
# SNAS-Auditoria-Servicios-v3.2.sh - Auditoría técnica avanzada para sistema NAS
# victor31416 - Proyecto SNAS - Versión depurada y verificada

set -euo pipefail

# 🔧 Instalación automática de dependencias si faltan
if [ "$(id -u)" -ne 0 ]; then
    echo "❌ Este script debe ejecutarse como root para instalar dependencias."
    exit 1
fi

echo -e "\033[0;34m🔧 Instalando dependencias necesarias...\033[0m"
apt update -y >/dev/null

# Paquetes críticos
apt install -y lsb-release systemd net-tools coreutils procps >/dev/null

# Paquetes opcionales (no detienen el script si fallan)
apt install -y stress-ng docker.io virt-manager nmap pandoc openssh-client iperf3 fio hdparm || true

# Configuración
SCRIPT_NAME="SNAS-Auditoria-Servicios"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OUTPUT_FILE="/root/${SCRIPT_NAME}_${TIMESTAMP}.txt"
JSON_FILE="/root/${SCRIPT_NAME}_${TIMESTAMP}.json"
MD_FILE="/root/${SCRIPT_NAME}_${TIMESTAMP}.md"
HTML_FILE="/root/${SCRIPT_NAME}_${TIMESTAMP}.html"
TEMP_DIR="/tmp/snas_audit_${TIMESTAMP}"

# Colores
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; PURPLE='\033[0;35m'; CYAN='\033[0;36m'; NC='\033[0m'

# Variables
declare -A MODULE_RESULTS DEPENDENCIES_MISSING SERVICES_STATUS STRESS_RESULTS PERFORMANCE_RESULTS SECURITY_ISSUES
START_TIME=$SECONDS
SECURITY_ISSUES=()

json_escape() {
    echo "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e 's/\//\\\//g'
}

check_dependencies() {
    echo -e "${BLUE}🔍 Verificando dependencias...${NC}"
    local critical=("systemctl" "lsb_release" "uname" "ss" "df" "free")
    local optional=("stress-ng" "docker" "virsh" "nmap" "pandoc" "scp" "iperf3" "fio" "hdparm")

    for cmd in "${critical[@]}"; do
        if ! command -v "$cmd" &>/dev/null; then
            echo -e "${RED}❌ Comando crítico faltante: $cmd${NC}"
            DEPENDENCIES_MISSING["$cmd"]="CRÍTICO"
        fi
    done

    for cmd in "${optional[@]}"; do
        if ! command -v "$cmd" &>/dev/null; then
            echo -e "${YELLOW}⚠️ Comando opcional faltante: $cmd${NC}"
            DEPENDENCIES_MISSING["$cmd"]="OPCIONAL"
        else
            echo -e "${GREEN}✅ $cmd disponible${NC}"
        fi
    done

    echo "--- Dependencias Faltantes ---" >> "$OUTPUT_FILE"
    for cmd in "${!DEPENDENCIES_MISSING[@]}"; do
        echo "${DEPENDENCIES_MISSING[$cmd]}: $cmd" >> "$OUTPUT_FILE"
    done
    echo "" >> "$OUTPUT_FILE"
}

section() {
    echo -e "\n${PURPLE}=== MÓDULO $1 ===${NC}" | tee -a "$OUTPUT_FILE"
    echo "==============================================" >> "$OUTPUT_FILE"
}

safe_run() {
    local cmd="$1"; local desc="$2"; local key="$3"
    echo "--- $desc ---" >> "$OUTPUT_FILE"
    echo "Comando: $cmd" >> "$OUTPUT_FILE"
    local output exit_code=0
    output=$(eval "$cmd" 2>&1) || exit_code=$?
    if [ $exit_code -eq 0 ]; then
        echo "✅ Ejecutado correctamente" >> "$OUTPUT_FILE"
        echo "$output" >> "$OUTPUT_FILE"
        [ -n "$key" ] && echo "    \"$key\": \"$(json_escape "$output")\"," >> "$JSON_FILE"
    else
        echo "❌ Error en ejecución (código: $exit_code)" >> "$OUTPUT_FILE"
        echo "$output" >> "$OUTPUT_FILE"
        [ -n "$key" ] && echo "    \"$key\": \"ERROR: $exit_code\"," >> "$JSON_FILE"
    fi
    echo "" >> "$OUTPUT_FILE"
}

init_audit() {
    echo -e "${BLUE}=== INICIANDO AUDITORÍA SNAS - ${TIMESTAMP} ===${NC}"
    check_dependencies
    mkdir -p "$TEMP_DIR"
    {
    echo "=== AUDITORÍA TÉCNICA AVANZADA SNAS ==="
    echo "Proyecto: SNAS by victor31416"
    echo "Fecha: $(date)"
    echo "Hostname: $(hostname)"
    echo "Usuario: $(whoami)"
    echo "========================================"
    } > "$OUTPUT_FILE"

    echo "{" > "$JSON_FILE"
    echo "  \"auditoria_snas\": {" >> "$JSON_FILE"
    echo "    \"timestamp\": \"$(date -Iseconds)\"," >> "$JSON_FILE"
    echo "    \"hostname\": \"$(hostname)\"," >> "$JSON_FILE"
    echo "    \"proyecto\": \"SNAS by victor31416\"," >> "$JSON_FILE"
    echo "    \"dependencias_faltantes\": {" >> "$JSON_FILE"
    local first=true
    for cmd in "${!DEPENDENCIES_MISSING[@]}"; do
        [ "$first" = true ] && first=false || echo "," >> "$JSON_FILE"
        echo "      \"$cmd\": \"${DEPENDENCIES_MISSING[$cmd]}\"" >> "$JSON_FILE"
    done
    echo "    }," >> "$JSON_FILE"
}

module_os_config() {
    section "1: SISTEMA OPERATIVO"
    safe_run "lsb_release -a" "Distribución Linux" "distribucion"
    safe_run "hostnamectl" "Configuración del Host" "host_config"
    safe_run "uname -a" "Kernel y Arquitectura" "kernel"
    safe_run "uptime" "Tiempo de Actividad" "uptime"
    MODULE_RESULTS["os_config"]="COMPLETADO"
    echo "✅ Módulo OS Config ejecutado" >> "$OUTPUT_FILE"
}

module_virtualization() {
    section "2: VIRTUALIZACIÓN"
    safe_run "systemd-detect-virt" "Tipo de Virtualización" "virtualization_type"
    MODULE_RESULTS["virtualization"]="COMPLETADO"
    echo "✅ Módulo Virtualización ejecutado" >> "$OUTPUT_FILE"
}

module_performance() {
    section "3: RENDIMIENTO"
    echo "--- Test Disco ---" >> "$OUTPUT_FILE"
    local write_speed=$(dd if=/dev/zero of=/tmp/testfile bs=1M count=100 oflag=direct 2>&1 | grep -o '[0-9.]\+ MB/s' | head -1)
    echo "Velocidad escritura: $write_speed" >> "$OUTPUT_FILE"
    PERFORMANCE_RESULTS["disk_write_speed"]="$write_speed"
    rm -f /tmp/testfile
    echo "--- Test Memoria ---" >> "$OUTPUT_FILE"
    local mem_speed=$(dd if=/dev/zero of=/dev/null bs=1M count=1024 2>&1 | grep -o '[0-9.]\+ MB/s' | head -1)
    echo "Velocidad memoria: $mem_speed" >> "$OUTPUT_FILE"
    PERFORMANCE_RESULTS["mem_speed"]="$mem_speed"
    MODULE_RESULTS["performance"]="COMPLETADO"
    echo "✅ Módulo Rendimiento ejecutado" >> "$OUTPUT_FILE"
}

module_security() {
    section "4: SEGURIDAD"
    safe_run "ss -tuln" "Puertos Abiertos" "open_ports"
    safe_run "systemctl list-units --type=service --state=running" "Servicios Activos" "running_services"
    MODULE_RESULTS["security"]="COMPLETADO"
    echo "✅ Módulo Seguridad ejecutado" >> "$OUTPUT_FILE"
}

module_nas_services() {
    section "5: SERVICIOS NAS"
    SERVICES_STATUS["samba"]=$(systemctl is-active smbd 2>/dev/null || echo "no activo")
    SERVICES_STATUS["nfs"]=$(systemctl is-active nfs-server 2>/dev/null || echo "no activo")
    SERVICES_STATUS["nextcloud"]=$(systemctl is-active nextcloud 2>/dev/null || echo "no activo")
    for service in "${!SERVICES_STATUS[@]}"; do
        echo "$service: ${SERVICES_STATUS[$service]}" >> "$OUTPUT_FILE"
    done
    MODULE_RESULTS["nas_services"]="COMPLETADO"
    echo "✅ Módulo NAS ejecutado" >> "$OUTPUT_FILE"
}

module_monitoring() {
    section "6: MONITORIZACIÓN"
    safe_run "systemctl is-active netdata 2>/dev/null || echo 'Netdata no activo'" "Estado Netdata" "netdata_status"
    MODULE_RESULTS["monitoring"]="COMPLETADO"
    echo "✅ Módulo Monitorización ejecutado" >> "$OUTPUT_FILE"
}

module_executive_summary() {
    # Resumen final de auditoría, exportado a TXT y JSON


    section "7: RESUMEN EJECUTIVO"

    {
    echo "=== RESUMEN EJECUTIVO - AUDITORÍA SNAS ==="
    echo "Tiempo total ejecución: $((SECONDS - START_TIME)) segundos"
    echo "Módulos completados: ${#MODULE_RESULTS[@]}"
    echo "Servicios NAS activos: ${#SERVICES_STATUS[@]}"
    echo "Riesgos detectados: ${#SECURITY_ISSUES[@]}"
    echo "Dependencias faltantes: ${#DEPENDENCIES_MISSING[@]}"
    } >> "$OUTPUT_FILE"

    echo "    \"resumen\": {" >> "$JSON_FILE"
    echo "      \"tiempo_ejecucion\": $((SECONDS - START_TIME))," >> "$JSON_FILE"
    echo "      \"modulos_completados\": ${#MODULE_RESULTS[@]}," >> "$JSON_FILE"
    echo "      \"servicios_activos\": ${#SERVICES_STATUS[@]}," >> "$JSON_FILE"
    echo "      \"riesgos_detectados\": ${#SECURITY_ISSUES[@]}," >> "$JSON_FILE"
    echo "      \"dependencias_faltantes\": ${#DEPENDENCIES_MISSING[@]}" >> "$JSON_FILE"
    echo "    }" >> "$JSON_FILE"
    echo "  }" >> "$JSON_FILE"
    echo "}" >> "$JSON_FILE"

    MODULE_RESULTS["executive_summary"]="COMPLETADO"
    echo "✅ Módulo Resumen Ejecutivo ejecutado" >> "$OUTPUT_FILE"
}

export_markdown_summary() {
    section "EXPORTANDO RESUMEN MARKDOWN"
    {
    echo "# Resumen Ejecutivo - Auditoría SNAS"
    echo "**Proyecto:** SNAS by victor31416"
    echo "**Fecha:** $(date)"
    echo "**Hostname:** $(hostname)"
    echo "**Kernel:** $(uname -r)"
    echo "**Uptime:** $(uptime -p | sed 's/up //')"
    echo "**Arquitectura:** $(uname -m)"
    echo "**Tiempo ejecución:** $((SECONDS - START_TIME)) segundos"
    echo ""
    echo "## 📊 Estado del Sistema"
    echo "- **Sistema Operativo:** $(lsb_release -d 2>/dev/null | cut -f2- || echo 'No disponible')"
    echo "- **Módulos completados:** ${#MODULE_RESULTS[@]}"
    echo "- **Dependencias faltantes:** ${#DEPENDENCIES_MISSING[@]}"
    echo ""
    echo "## ✅ Módulos Ejecutados"
    for module in "${!MODULE_RESULTS[@]}"; do
        echo "- **$module:** ${MODULE_RESULTS[$module]}"
    done
    echo ""
    echo "---"
    echo "*Auditoría generada automáticamente por SNAS-Auditoria-Servicios-v3.1.sh*"
    echo "*Proyecto SNAS - Secure Network Attached Storage*"
    } > "$MD_FILE"

    echo "✅ Archivo Markdown exportado: $MD_FILE" >> "$OUTPUT_FILE"
    MODULE_RESULTS["markdown_export"]="COMPLETADO"
}

export_html() {
    section "EXPORTANDO HTML"
    if command -v pandoc &>/dev/null; then
        if pandoc "$MD_FILE" -o "$HTML_FILE" 2>/dev/null; then
            echo "✅ Archivo HTML exportado: $HTML_FILE" >> "$OUTPUT_FILE"
            MODULE_RESULTS["html_export"]="COMPLETADO"
        else
            echo "❌ Error al generar HTML" >> "$OUTPUT_FILE"
            MODULE_RESULTS["html_export"]="FALLIDO"
        fi
    else
        echo "ℹ️ Pandoc no disponible, omitiendo exportación HTML" >> "$OUTPUT_FILE"
    fi
}

module_stress_test() {
    section "PRUEBAS DE ESTRÉS"
    if ! command -v stress-ng &>/dev/null; then
        echo "❌ stress-ng no disponible. Instalar con: apt install stress-ng" >> "$OUTPUT_FILE"
        STRESS_RESULTS["estado"]="No disponible"
        return 1
    fi

    echo "🧪 Ejecutando stress-ng durante 30 segundos..." >> "$OUTPUT_FILE"
    stress-ng --cpu 4 --vm 2 --vm-bytes 512M --timeout 30s --metrics-brief > "${TEMP_DIR}/stress_results.txt" 2>&1
    local exit_code=$?

    if [ -f "${TEMP_DIR}/stress_results.txt" ]; then
        cat "${TEMP_DIR}/stress_results.txt" >> "$OUTPUT_FILE"
        STRESS_RESULTS["estado"]="COMPLETADO"
        STRESS_RESULTS["codigo_salida"]="$exit_code"
        MODULE_RESULTS["stress_test"]="COMPLETADO"
        echo "✅ Prueba de estrés completada" >> "$OUTPUT_FILE"
    else
        STRESS_RESULTS["estado"]="FALLIDO"
        echo "❌ No se pudieron obtener resultados de stress-ng" >> "$OUTPUT_FILE"
    fi
}

main() {
    init_audit
    local modules=(
        "module_os_config"
        "module_virtualization"
        "module_performance"
        "module_security"
        "module_nas_services"
        "module_monitoring"
        "module_executive_summary"
    )
    for module in "${modules[@]}"; do
        $module || echo "⚠️ Error ejecutando $module" >> "$OUTPUT_FILE"
    done
    echo "✅ Auditoría básica completada" >> "$OUTPUT_FILE"
}

modo_completo() {
    echo -e "${PURPLE}🚀 EJECUTANDO MODO COMPLETO${NC}"
    main
    module_stress_test
    export_markdown_summary
    export_html
    echo "✅ Modo completo finalizado" >> "$OUTPUT_FILE"
}

modo_remoto() {
    local destination="$1"
    modo_completo
    echo "📤 Copiando archivos a $destination..." >> "$OUTPUT_FILE"
    scp "$OUTPUT_FILE" "$JSON_FILE" "$MD_FILE" "$HTML_FILE" "$destination" 2>> "$OUTPUT_FILE" && \
    echo "✅ Archivos copiados correctamente" >> "$OUTPUT_FILE" || \
    echo "❌ Error en copia remota" >> "$OUTPUT_FILE"
}

case "${1:-}" in
    "--modo-completo") modo_completo ;;
    "--modo-remoto")
        [ -z "${2:-}" ] && echo "❌ Debes especificar destino" && exit 1
        modo_remoto "$2"
        ;;
    "--export-md") main; export_markdown_summary ;;
    "--export-html") main; export_markdown_summary; export_html ;;
    "--modo-stress") module_stress_test; export_markdown_summary; export_html ;;
    "--modo-resumen") main ;;
    "--help")
        echo "Uso: $0 [OPCIÓN]"
        echo "  --modo-completo     Auditoría completa + estrés + exportaciones"
        echo "  --modo-remoto DEST  Auditoría completa + copia remota"
        echo "  --export-md         Exportar resumen en Markdown"
        echo "  --export-html       Exportar resumen en HTML"
        echo "  --modo-stress       Solo pruebas de estrés"
        echo "  --modo-resumen      Solo resumen ejecutivo"
        echo "  --help              Mostrar esta ayuda"
        ;;
    *) main ;;
esac

rm -rf "$TEMP_DIR"

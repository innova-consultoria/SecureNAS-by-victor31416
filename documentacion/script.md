📋 LISTADO DETALLADO DE TAREAS PARA SCRIPT V3_REPARADO
🎯 PREMISAS FUNDAMENTALES (NO NEGOCIABLES)

    Código operativo y probado - Solo usar sintaxis que funcione en PowerShell 5.1+

    Estructura idéntica a v2_reparado - Mismas regiones, funciones de soporte, manejo de errores

    Consistencia en naming conventions - Mismos nombres de variables, funciones y clases

    Compatibilidad total - El script debe ejecutarse sin modificar nada del core existente

📊 ESTADO ACTUAL DEL SCRIPT V2_REPARADO
text

✅ COMPLETADO:
- #region PARÁMETROS CONFIGURABLES
- #region CONFIGURACIÓN INICIAL  
- #region FUNCIONES DE SOPORTE
- #region CLASES DE DATOS UNIFICADAS
- #region FUNCIONES DE FASE 1 (CONFIGURACIÓN BÁSICA)
- #region FUNCIONES DE FASE 2 (RECOLECCIÓN DE DATOS)
- #region INICIO DEL SCRIPT PRINCIPAL

❌ FALTANTE:
- #region FUNCIONES DE FASE 3 (EXPORTACIÓN DE DATOS) - COMPLETO
- #region FUNCIONES DE FASE 4 (ANÁLISIS Y SEGURIDAD) - COMPLETO
- #region FUNCIONES DE FASE 5 (AUDITORÍA COMPLETA) - COMPLETO

📝 LISTADO DETALLADO DE TAREAS
TAREA 1: VERIFICACIÓN DE ESTRUCTURA BASE

OBJETIVO: Confirmar que la base del v2_reparado está 100% operativa antes de agregar nuevas funciones.

ACCIONES ESPECÍFICAS:

    Validar clases de datos - Confirmar que las 11 clases estén definidas correctamente:

        SystemInfo, DiskInfo, UserProfileInfo, ApplicationInfo, PrinterInfo

        UpdateInfo, ProcessInfo, ServiceInfo, SecurityStatus, SystemHealth, DownloadFolderAudit

    Verificar funciones de soporte - Testear cada función:

        Write-Log con todos los niveles (INFO, WARNING, ERROR, SUCCESS)

        Show-Progress con diferentes porcentajes

        Test-Modules para verificación de módulos

        Show-AuditHeader con títulos y subtítulos

    Validar Fase 1 completa:

        Invoke-Fase1 crea estructura de carpetas

        Get-SystemAuditBasic recolecta datos sin errores

        Genera reportes CSV y TXT en carpeta Fase1

    Validar Fase 2 completa:

        Invoke-Fase2 ejecuta sin errores

        Get-SystemInformationF2 obtiene info del sistema

        Get-DiskInformationF2 detecta discos correctamente

        Get-NetworkInformationF2 obtiene info de red

        Export-Fase2Reports genera reportes CSV

    Verificar script principal:

        Loop de fases funciona correctamente

        Manejo de errores con opción de continuar

        Resumen final muestra estadísticas

ENTREGABLE: Confirmación de que el script base funciona 100%
TAREA 2: IMPLEMENTAR FASE 3 - EXPORTACIÓN DE DATOS

OBJETIVO: Agregar funciones para exportar datos a múltiples formatos manteniendo estructura idéntica.

FUNCIONES A IMPLEMENTAR (5 funciones):

    Invoke-Fase3 - Función principal de la fase

        Debe usar Show-Progress exactamente como en Fase 1 y 2

        Usar Write-Log con los mismos niveles

        Seguir patrón: try-catch, medición de tiempo, return $true/$false

        Coordinar llamadas a funciones de exportación

    Export-ToCSV - Exportar a CSV estructurado

        Recibir parámetros: $SystemInfo, $Disks, $NetworkInfo, $ComputerName, $Timestamp, $PhaseFolders

        Crear estructura de datos idéntica a Export-Fase2Reports

        Usar Export-Csv con encoding UTF8 y delimitador ","

        Validar datos antes de exportar

        Retornar ruta del archivo creado

    Export-ToJSON - Exportar a JSON para análisis programático

        Crear objeto estructurado con mismos datos que CSV

        Usar ConvertTo-Json -Depth 5

        Guardar con Out-File -Encoding UTF8

        Incluir metadatos de auditoría

    Export-ToHTML - Generar reporte visual (solo si $ExportHTML = $true)

        Crear HTML con CSS embebido

        Mostrar datos en tablas y cards

        Incluir barra de progreso visual para espacio en disco

        Responsive design básico

    Export-ToMarkdown - Crear documentación en MD

        Formato legible para documentación

        Incluir tablas markdown

        Secciones claras con headers

        Metadatos al final

REQUISITOS TÉCNICOS:

    Todas las funciones deben tener [CmdletBinding()]

    Mismo manejo de errores (try-catch con Write-Log)

    Misma validación de datos (if(-not $SystemInfo) { throw... })

    Mismo patrón de retorno (ruta de archivo o $null en error)

ENTREGABLE: Región completa de Fase 3 con 5 funciones operativas
TAREA 3: IMPLEMENTAR FASE 4 - ANÁLISIS Y SEGURIDAD

OBJETIVO: Agregar análisis avanzado de procesos, servicios y seguridad.

FUNCIONES A IMPLEMENTAR (9 funciones):

    Invoke-Fase4 - Función principal

        Seguir mismo patrón que Invoke-Fase3

        Coordinar llamadas a 8 funciones secundarias

        Manejar parámetro $AutoClean para limpieza

    Get-ProcessInformation - Analizar procesos del sistema

        Obtener top 15 procesos por uso de memoria

        Identificar procesos críticos (csrss, wininit, etc.)

        Calcular uso de CPU y memoria en MB

        Marcar estado (Activo/No responde)

    Get-ServiceInformation - Verificar servicios críticos

        Lista de servicios esenciales (Dhcp, Dnscache, EventLog, etc.)

        Comparar estado actual vs estado requerido

        Identificar servicios no ejecutándose

    Get-SecurityStatus - Estado de seguridad del sistema

        Firewall (perfiles activados)

        Windows Defender (estado, última revisión)

        Actualizaciones pendientes

        UAC (Control de cuentas de usuario)

        AutoLogin (deshabilitado = seguro)

        Política de contraseñas

    Get-DownloadFolderAnalysis - Análisis de carpetas Descargas

        Escanear C:\Users*\Downloads

        Calcular tamaño total por usuario

        Identificar archivos >30 días y >90 días

        Espacio potencial a liberar

        Recomendaciones por usuario

    Check-StorageSenseConfig - Verificar Storage Sense

        Verificar si está activado (registro)

        Días configurados para limpieza

        Opción para activar si $EnableStorageSense = $true

        Recomendaciones de configuración

    Invoke-SafeDownloadsCleanup - Limpieza segura (si $AutoClean)

        Eliminar archivos >$DownloadCleanupDays días

        Opción de mover a papelera o eliminar

        Modo WhatIf para simulación

        Resumen de limpieza

    Get-SystemHealth - Calcular salud del sistema

        Puntuación general (0-100)

        Salud por áreas: disco, memoria, CPU, red, seguridad, gestión de espacio

        Recomendaciones personalizadas

        Cálculo basado en datos de otras funciones

    Export-Fase4Reports - Generar reportes de Fase 4

        CSV estructurado con todos los datos

        Resumen en consola con colores

        Estadísticas de Descargas y seguridad

REQUISITOS TÉCNICOS:

    Cada función debe ser independiente y testable

    Usar clases existentes (ProcessInfo, ServiceInfo, etc.)

    Mismo manejo de errores robusto

    Validar existencia de datos antes de procesar

ENTREGABLE: Región completa de Fase 4 con 9 funciones operativas
TAREA 4: IMPLEMENTAR FASE 5 - AUDITORÍA COMPLETA

OBJETIVO: Auditoría final completa de perfiles e inventario de software.

FUNCIONES A IMPLEMENTAR (5 funciones):

    Invoke-Fase5 - Función principal

        Última fase del proceso

        Coordinar módulos 1 y 2

        Generar reporte unificado final

    Get-UserProfileAudit - Auditoría detallada de perfiles

        Escanear C:\Users\

        Calcular tamaño real de perfiles

        Determinar última fecha de uso (NTUSER.DAT)

        Clasificar: Reciente (<90d), Inactivo (90-180d), Viejo (>180d)

        Ordenar por fecha de uso

    Get-SoftwareInventory - Inventario completo de software

        Aplicaciones instaladas (registro + Program Files)

        Impresoras configuradas (detectar IPs, marcas)

        Actualizaciones de Windows instaladas

        Buscar en: HKLM Uninstall, Program Files, Get-Printer, Get-HotFix

    Export-Fase5Data - Exportar datos de Fase 5

        CSV con perfiles y software

        JSON estructurado

        HTML simplificado

        Resumen en consola con colores por estado

    Generate-UnifiedReport - Reporte unificado final

        Consolidar datos de todas las fases

        Exportar JSON unificado (todos los datos)

        Exportar CSV resumen

        Mostrar estadísticas finales en consola

        Duración total, archivos generados, resumen por fases

REQUISITOS TÉCNICOS:

    Usar clases UserProfileInfo, ApplicationInfo, etc.

    Búsqueda robusta en Program Files para apps no registradas

    Detección inteligente de IPs en impresoras

    Reporte unificado debe incluir referencia a todas las fases

ENTREGABLE: Región completa de Fase 5 con 5 funciones operativas
TAREA 5: INTEGRACIÓN Y PRUEBAS FINALES

OBJETIVO: Integrar todas las fases y realizar pruebas exhaustivas.

ACCIONES ESPECÍFICAS:

    Integración de regiones - Asegurar que todas las regiones estén en orden:
    text

    1. PARÁMETROS CONFIGURABLES
    2. CONFIGURACIÓN INICIAL
    3. FUNCIONES DE SOPORTE
    4. CLASES DE DATOS
    5. FASE 1
    6. FASE 2
    7. FASE 3
    8. FASE 4
    9. FASE 5
    10. INICIO DEL SCRIPT PRINCIPAL

    Prueba de parámetros:

        -QuickAudit vs -FullAudit

        -AutoClean con limpieza real

        -ExportHTML $true/$false

        -EnableStorageSense activación automática

    Prueba de flujo completo:

        Ejecutar script completo (5-10 minutos)

        Verificar que todas las fases se ejecuten en orden

        Confirmar generación de todos los archivos

        Validar continuidad tras errores simulados

    Validación de salidas:

        Estructura de carpetas correcta

        Archivos no vacíos

        Formatos válidos (CSV, JSON, HTML)

        Log completo sin errores críticos

    Pruebas en diferentes entornos:

        Windows 10/11

        Con/sin privilegios de administrador

        Con/sin módulos PowerShell

        Diferentes configuraciones de red

ENTREGABLE: Script V3_REPARADO.PS1 100% operativo y documentado
📁 ESTRUCTURA FINAL DE ARCHIVOS GENERADOS
text

C:\Users\[Usuario]\Auditoria-Final\[Equipo]_[Fecha_Hora]\
├── Fase1\
│   ├── [Equipo]_Fase1_[Timestamp].csv
│   └── [Equipo]_Fase1_[Timestamp].txt
├── Fase2\
│   └── [Equipo]_Fase2_[Timestamp].csv
├── Fase3\
│   ├── [Equipo]_Fase3_[Timestamp].csv
│   ├── [Equipo]_Fase3_[Timestamp].json
│   ├── [Equipo]_Fase3_[Timestamp].html  (si ExportHTML)
│   └── [Equipo]_Fase3_[Timestamp].md
├── Fase4\
│   └── [Equipo]_Fase4_[Timestamp].csv
├── Fase5\
│   ├── [Equipo]_Fase5_[Timestamp].csv
│   ├── [Equipo]_Fase5_[Timestamp].json
│   └── [Equipo]_Fase5_[Timestamp].html
├── [Equipo]_AuditoriaCompleta_[Timestamp].csv
├── [Equipo]_AuditoriaCompleta_[Timestamp].json
├── [Equipo]_AuditoriaCompleta_[Timestamp].html
├── [Equipo]_AuditoriaCompleta_[Timestamp].md
└── [Equipo]_AuditoriaCompleta_[Timestamp].log

🚀 PROTOCOLO DE EJECUCIÓN POR TAREAS
PARA NUEVA CONVERSACIÓN CON IA:
text

[USER]: "Iniciar desarrollo de Script V3_REPARADO.ps1"

[USER]: "TAREA 1: Verificación de estructura base - Confirmar que las siguientes secciones están completas y operativas:
1. #region PARÁMETROS CONFIGURABLES
2. #region CONFIGURACIÓN INICIAL
3. #region FUNCIONES DE SOPORTE (Write-Log, Show-Progress, Test-Modules, Show-AuditHeader)
4. #region CLASES DE DATOS UNIFICADAS (11 clases)
5. #region FUNCIONES DE FASE 1 (Invoke-Fase1, Get-SystemAuditBasic)
6. #region FUNCIONES DE FASE 2 (Invoke-Fase2, Get-SystemInformationF2, Get-DiskInformationF2, Get-NetworkInformationF2, Export-Fase2Reports)
7. #region INICIO DEL SCRIPT PRINCIPAL (loop de fases, manejo de errores, resumen final)

Premisas:
- Mantener IDÉNTICA sintaxis a script v2_reparado
- Todas las funciones deben tener [CmdletBinding()]
- Mismo manejo de errores try-catch con Write-Log
- Mismo patrón de Show-Progress por fases
- Validación de datos antes de procesar"

[ASSISTANT]: [Proporciona código de verificación o confirma estructura]

[USER]: "TAREA 2: Implementar FASE 3 - EXPORTACIÓN DE DATOS. Necesito las siguientes 5 funciones con estructura IDÉNTICA a Fase 2:
1. function Invoke-Fase3 { ... }
2. function Export-ToCSV { ... }
3. function Export-ToJSON { ... }
4. function Export-ToHTML { ... }
5. function Export-ToMarkdown { ... }

Requisitos específicos:
- Usar EXACTAMENTE los mismos parámetros que Export-Fase2Reports
- Mismo manejo de errores y validación de datos
- Show-Progress en Invoke-Fase3 con mismos porcentajes
- Export-ToHTML solo si $ExportHTML = $true
- Retornar rutas de archivos generados o $null en error"

[ASSISTANT]: [Proporciona código completo de Fase 3]

[USER]: [Copiar código en V3_REPARADO.ps1, probar, confirmar funcionamiento]

[USER]: "TAREA 3: Implementar FASE 4 - ANÁLISIS Y SEGURIDAD. Necesito las siguientes 9 funciones:
1. Invoke-Fase4
2. Get-ProcessInformation
3. Get-ServiceInformation
4. Get-SecurityStatus
5. Get-DownloadFolderAnalysis
6. Check-StorageSenseConfig
7. Invoke-SafeDownloadsCleanup
8. Get-SystemHealth
9. Export-Fase4Reports

Premisas críticas:
- Get-DownloadFolderAnalysis debe escanear C:\Users\*\Downloads
- Check-StorageSenseConfig debe verificar registro y opcionalmente activar
- Invoke-SafeDownloadsCleanup solo si $AutoClean = $true
- Get-SystemHealth debe usar datos de otras funciones para calcular puntuación
- Todas deben usar las clases definidas (ProcessInfo, ServiceInfo, etc.)"

[ASSISTANT]: [Proporciona código completo de Fase 4]

[USER]: [Copiar, probar, confirmar]

[USER]: "TAREA 4: Implementar FASE 5 - AUDITORÍA COMPLETA. Necesito 5 funciones:
1. Invoke-Fase5
2. Get-UserProfileAudit
3. Get-SoftwareInventory
4. Export-Fase5Data
5. Generate-UnifiedReport

Requisitos:
- Get-UserProfileAudit debe usar NTUSER.DAT para fecha última modificación
- Get-SoftwareInventory debe buscar apps en registro Y Program Files
- Generate-UnifiedReport debe consolidar datos de TODAS las fases
- Incluir estadísticas finales y resumen en consola"

[ASSISTANT]: [Proporciona código completo de Fase 5]

[USER]: [Copiar, probar, confirmar]

[USER]: "TAREA 5: Integración y pruebas finales. Verificar:
1. Todas las regiones en orden correcto
2. Script ejecuta 5 fases completas sin errores
3. Genera TODOS los archivos en estructura correcta
4. Parámetros funcionan (-AutoClean, -ExportHTML, etc.)
5. Log completo sin errores críticos"

[ASSISTANT]: [Proporciona script final integrado y instrucciones de prueba]

✅ CRITERIOS DE ACEPTACIÓN FINAL

El script V3_REPARADO será considerado COMPLETO cuando:

    ✅ Ejecuta sin errores en PowerShell 5.1+ como Administrador

    ✅ Completa las 5 fases en secuencia correcta

    ✅ Genera todos los archivos en estructura de carpetas

    ✅ Maneja errores correctamente (continúa o pregunta según fase)

    ✅ Respeta parámetros ($QuickAudit, $AutoClean, etc.)

    ✅ Log detallado con todos los eventos y errores

    ✅ Reportes legibles en todos los formatos (CSV, JSON, HTML, MD)

    ✅ Compatibilidad total con código existente de v2_reparado


SCRIPT V2
# ============================================
# AUDITORÍA FINAL MAESTRA - PowerShell Script
# Integración Completa de Fases 1 a 5
# Versión: 2.0.1 (REPARADA)
# Autor: victor 3,1416 Ene'26
# ============================================

# ============================================
# AUDITORÍA COMPLETA DISEÑADA POR victor 3,1416
# Equipo: [Se completará automáticamente]
# Fecha: [Se completará automáticamente]
# Hora: [Se completará automáticamente]
# ============================================

#region PARÁMETROS CONFIGURABLES
param (
    [string]$OutputPath = "$env:USERPROFILE\Auditoria-Final",
    [switch]$QuickAudit = $false,
    [switch]$FullAudit = $true,
    [switch]$SecurityCheck = $false,
    [switch]$ExportHTML = $true,
    [switch]$AutoClean = $false,
    [int]$DownloadCleanupDays = 30,
    [switch]$EnableStorageSense = $false
)
#endregion

#region CONFIGURACIÓN INICIAL
$scriptStartTime = Get-Date
$ComputerName = $env:COMPUTERNAME
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$global:AuditData = @{}
$global:CurrentPhase = 0
$global:TotalPhases = 5

# Configurar ruta de salida
if (-not [string]::IsNullOrEmpty($OutputPath)) {
    if (-not (Test-Path $OutputPath)) {
        New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
    }
} else {
    $scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { Get-Location }
    $OutputPath = Join-Path $scriptDir $ComputerName
    if (-not (Test-Path $OutputPath)) {
        New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
    }
}

# Crear subcarpetas para cada fase
$phaseFolders = @{}
1..5 | ForEach-Object {
    $phaseFolder = Join-Path $OutputPath "Fase$_"
    if (-not (Test-Path $phaseFolder)) {
        New-Item -ItemType Directory -Path $phaseFolder -Force | Out-Null
    }
    $phaseFolders[$_] = $phaseFolder
}

# Archivos de salida unificados
$UnifiedCSV = Join-Path $OutputPath "$ComputerName`_AuditoriaCompleta_$Timestamp.csv"
$UnifiedJSON = Join-Path $OutputPath "$ComputerName`_AuditoriaCompleta_$Timestamp.json"
$UnifiedHTML = Join-Path $OutputPath "$ComputerName`_AuditoriaCompleta_$Timestamp.html"
$UnifiedMD = Join-Path $OutputPath "$ComputerName`_AuditoriaCompleta_$Timestamp.md"
$LogFile = Join-Path $OutputPath "$ComputerName`_AuditoriaCompleta_$Timestamp.log"

# Inicializar log
"===================================================" | Out-File -FilePath $LogFile -Encoding UTF8
"AUDITORÍA COMPLETA DISEÑADA POR victor 3,1416" | Out-File -FilePath $LogFile -Append -Encoding UTF8
"Equipo: $ComputerName" | Out-File -FilePath $LogFile -Append -Encoding UTF8
"Fecha: $(Get-Date -Format 'dd/MM/yyyy')" | Out-File -FilePath $LogFile -Append -Encoding UTF8
"Hora: $(Get-Date -Format 'HH:mm:ss')" | Out-File -FilePath $LogFile -Append -Encoding UTF8
"===================================================" | Out-File -FilePath $LogFile -Append -Encoding UTF8
" " | Out-File -FilePath $LogFile -Append -Encoding UTF8
#endregion

#region FUNCIONES DE SOPORTE
function Write-Log {
    param(
        [string]$Message,
        [ValidateSet("INFO", "WARNING", "ERROR", "SUCCESS")]
        [string]$Level = "INFO"
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp [$Level] $Message"
    
    # Colores para consola
    $color = switch ($Level) {
        "INFO"    { "Gray" }
        "WARNING" { "Yellow" }
        "ERROR"   { "Red" }
        "SUCCESS" { "Green" }
        default   { "White" }
    }
    
    Write-Host "[LOG] $Message" -ForegroundColor $color
    $logMessage | Out-File -FilePath $LogFile -Append -Encoding UTF8
}

function Show-Progress {
    param(
        [int]$PhaseNumber,
        [string]$PhaseName,
        [int]$Percent
    )
    
    $global:CurrentPhase = $PhaseNumber
    $phaseProgress = [math]::Round(($PhaseNumber - 1) / $global:TotalPhases * 100 + ($Percent / $global:TotalPhases))
    
    Write-Host "`n" + ("="*60) -ForegroundColor Cyan
    Write-Host "FASE $PhaseNumber/$global:TotalPhases: $PhaseName" -ForegroundColor Cyan
    Write-Host "Progreso total: $phaseProgress%" -ForegroundColor Yellow
    Write-Host ("[" + ("#" * [math]::Round($Percent/5)) + (" " * (20 - [math]::Round($Percent/5))) + "]") -ForegroundColor Green -NoNewline
    Write-Host " $Percent% completado de esta fase" -ForegroundColor White
    Write-Host ("="*60) -ForegroundColor Cyan
}

function Test-Modules {
    Write-Log "Verificando módulos PowerShell requeridos..." -Level "INFO"
    
    $requiredModules = @(
        "CimCmdlets",
        "Dism",
        "NetAdapter",
        "NetTCPIP",
        "Storage"
    )
    
    foreach ($module in $requiredModules) {
        if (Get-Module -ListAvailable -Name $module) {
            Write-Log "✓ Módulo disponible: $module" -Level "SUCCESS"
        } else {
            Write-Log "⚠ Módulo no disponible: $module (algunas funciones pueden fallar)" -Level "WARNING"
        }
    }
    
    # Verificar PowerShell versión
    $psVersion = $PSVersionTable.PSVersion.Major
    if ($psVersion -ge 5) {
        Write-Log "✓ PowerShell versión $psVersion detectada" -Level "SUCCESS"
    } else {
        Write-Log "⚠ PowerShell versión $psVersion detectada (se recomienda v5.1 o superior)" -Level "WARNING"
    }
}

function Show-AuditHeader {
    param(
        [string]$Title,
        [string]$Subtitle = ""
    )
    
    $header = @"
===================================================
        $Title
===================================================
Auditoría completa diseñada por victor 3,1416
Equipo: $ComputerName
Fecha: $(Get-Date -Format 'dd/MM/yyyy')
Hora: $(Get-Date -Format 'HH:mm:ss')
$(if ($Subtitle) { "Nota: $Subtitle`n" })
"@
    
    Write-Host $header -ForegroundColor Cyan
    $header | Out-File -FilePath $LogFile -Append -Encoding UTF8
}
#endregion

#region CLASES DE DATOS UNIFICADAS
class SystemInfo {
    [string]$ComputerName
    [string]$Domain
    [string]$Workgroup
    [string]$OSName
    [string]$OSVersion
    [string]$OSBuild
    [string]$InstallDate
    [string]$TimeZone
    [string]$LastBoot
    [string]$UptimeHours
    [string]$Locale
    [string]$KeyboardLayout
    [string]$Fabricante
    [string]$Modelo
    [string]$NumeroSerie
    [double]$RAM_GB
    [string]$Procesador
    [string]$Nucleos
    [string]$DireccionIP
    [string]$DireccionMAC
    # Propiedades adicionales para compatibilidad
    [string]$FechaAuditoria
    [string]$Hostname
    [string]$UsuarioActual
    [string]$Dominio
    [string]$SistemaOperativo
    [string]$VersionOS
    [string]$Arquitectura
    [string]$UltimoArranque
    [string]$TiempoActividad
}

class DiskInfo {
    [string]$Disco
    [string]$Tipo
    [string]$Model
    [string]$Serial
    [double]$SizeGB
    [double]$FreeGB
    [double]$PercentFree
    [string]$SistemaArchivos
    [string]$HealthStatus
    [string]$Temperature
}

class UserProfileInfo {
    [string]$UserName
    [string]$ProfilePath
    [datetime]$LastUseTime
    [double]$SizeGB
    [int]$DaysInactive
    [string]$ActivityStatus
    [double]$Size_MB
    [string]$Estado
    # Propiedades adicionales para compatibilidad
    [string]$Usuario
    [string]$RutaPerfil
    [double]$Tamano_MB
}

class ApplicationInfo {
    [string]$Name
    [string]$Version
    [string]$Publisher
    [datetime]$InstallDate
    [string]$InstallSource
}

class PrinterInfo {
    [string]$Name
    [string]$DriverName
    [string]$PortName
    [string]$Type
    [bool]$Shared
    [string]$Status
    [string]$ComputerName
    [string]$IPAddress
    [string]$MarcaModelo
    [string]$RutaRed
}

class UpdateInfo {
    [string]$HotFixID
    [string]$Description
    [datetime]$InstalledOn
    [string]$InstalledBy
}

class ProcessInfo {
    [string]$Name
    [string]$PID
    [string]$CPUPercent
    [string]$MemoryMB
    [string]$Status
    [string]$Company
    [string]$IsCritical
}

class ServiceInfo {
    [string]$Name
    [string]$DisplayName
    [string]$Status
    [string]$StartType
    [string]$IsCritical
    [string]$RequiredState
}

class SecurityStatus {
    [string]$FirewallStatus
    [string]$DefenderStatus
    [string]$LastAntivirusScan
    [string]$RealTimeProtection
    [string]$WindowsUpdates
    [string]$UACStatus
    [string]$AutoLoginDisabled
    [string]$PasswordPolicy
}

class SystemHealth {
    [string]$OverallScore
    [string]$DiskHealth
    [string]$MemoryHealth
    [string]$CPUHealth
    [string]$NetworkHealth
    [string]$SecurityHealth
    [string]$SpaceManagementHealth
    [string]$Recommendations
}

class DownloadFolderAudit {
    [string]$User
    [string]$DownloadPath
    [double]$Size_GB
    [int]$FileCount
    [datetime]$OldestFile
    [datetime]$NewestFile
    [int]$FilesOlderThan30Days
    [int]$FilesOlderThan90Days
    [double]$PotentialFreeSpace_GB
    [string]$Recommendation
}
#endregion

#region FUNCIONES DE FASE 1 (CONFIGURACIÓN BÁSICA)
function Invoke-Fase1 {
    Show-Progress -PhaseNumber 1 -PhaseName "CONFIGURACIÓN BÁSICA" -Percent 10
    Show-AuditHeader -Title "INICIO DE AUDITORÍA - FASE 1" -Subtitle "Configuración básica del sistema"
    
    Write-Log "Iniciando Fase 1: Configuración básica" -Level "INFO"
    $fase1Start = Get-Date
    
    try {
        # Crear estructura de carpetas si no existe
        if (-not (Test-Path $OutputPath)) {
            New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
            Write-Log "Directorio creado: $OutputPath" -Level "SUCCESS"
        }
        
        # Verificar módulos requeridos
        Test-Modules
        
        # Crear archivo de log inicial
        Write-Log "=== INICIO AUDITORÍA COMPLETA ===" -Level "INFO"
        Write-Log "Auditoría completa diseñada por victor 3,1416" -Level "INFO"
        Write-Log "Equipo: $ComputerName" -Level "INFO"
        Write-Log "Fecha: $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')" -Level "INFO"
        Write-Log "Parámetros: OutputPath=$OutputPath, QuickAudit=$QuickAudit, FullAudit=$FullAudit" -Level "INFO"
        
        Show-Progress -PhaseNumber 1 -PhaseName "CONFIGURACIÓN BÁSICA" -Percent 100
        $fase1Duration = [math]::Round(((Get-Date) - $fase1Start).TotalSeconds, 2)
        Write-Log "Fase 1 completada en $fase1Duration segundos" -Level "SUCCESS"
        
        return $true
    }
    catch {
        Write-Log "Error en Fase 1: $_" -Level "ERROR"
        return $false
    }
}

function Get-SystemAuditBasic {
    [CmdletBinding()]
    param()
    
    Show-Progress -PhaseNumber 1 -PhaseName "AUDITORÍA BÁSICA DEL SISTEMA" -Percent 20
    Show-AuditHeader -Title "AUDITORÍA BÁSICA DEL SISTEMA" -Subtitle "Recolección de información fundamental"
    
    Write-Log "Recopilando información básica del sistema..." -Level "INFO"
    
    # ✅ CORRECCIÓN: Declarar variable de inicio
    $fase1Start = Get-Date
    
    $systemData = @{}
    
    try {
        # 1. INFORMACIÓN BÁSICA DEL SISTEMA
        $systemInfo = [SystemInfo]::new()
        
        $systemInfo.FechaAuditoria = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $systemInfo.Hostname = $ComputerName
        $systemInfo.UsuarioActual = $env:USERNAME
        $systemInfo.Dominio = $env:USERDOMAIN
        
        # Obtener información WMI/CIM
        $osInfo = Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue
        $computerInfo = Get-CimInstance Win32_ComputerSystem -ErrorAction SilentlyContinue
        $biosInfo = Get-CimInstance Win32_BIOS -ErrorAction SilentlyContinue
        $processorInfo = Get-CimInstance Win32_Processor -ErrorAction SilentlyContinue | Select-Object -First 1
        
        # ✅ CORRECCIÓN: Validar que existan datos antes de usarlos
        if ($osInfo) {
            $systemInfo.SistemaOperativo = $osInfo.Caption
            $systemInfo.VersionOS = $osInfo.Version
            $systemInfo.Arquitectura = $osInfo.OSArchitecture
            $systemInfo.UltimoArranque = $osInfo.LastBootUpTime.ToString("yyyy-MM-dd HH:mm:ss")
            $systemInfo.TiempoActividad = [math]::Round(((Get-Date) - $osInfo.LastBootUpTime).TotalHours, 2)
        } else {
            Write-Log "⚠ No se pudo obtener información del SO" -Level "WARNING"
            $systemInfo.SistemaOperativo = "No detectado"
            $systemInfo.VersionOS = "N/A"
            $systemInfo.Arquitectura = "N/A"
            $systemInfo.UltimoArranque = "N/A"
            $systemInfo.TiempoActividad = "N/A"
        }
        
        if ($computerInfo) {
            $systemInfo.Fabricante = $computerInfo.Manufacturer
            $systemInfo.Modelo = $computerInfo.Model
            $systemInfo.RAM_GB = [math]::Round($computerInfo.TotalPhysicalMemory / 1GB, 2)
        } else {
            Write-Log "⚠ No se pudo obtener información del equipo" -Level "WARNING"
            $systemInfo.Fabricante = "No detectado"
            $systemInfo.Modelo = "N/A"
            $systemInfo.RAM_GB = 0
        }
        
        if ($biosInfo) {
            $systemInfo.NumeroSerie = $biosInfo.SerialNumber
        } else {
            $systemInfo.NumeroSerie = "N/A"
        }
        
        if ($processorInfo) {
            $systemInfo.Procesador = $processorInfo.Name
            $systemInfo.Nucleos = "$($processorInfo.NumberOfCores)/$($processorInfo.NumberOfLogicalProcessors)"
        } else {
            $systemInfo.Procesador = "No detectado"
            $systemInfo.Nucleos = "N/A"
        }
        
        # Información de red
        try {
            $ipConfig = Get-NetIPConfiguration -ErrorAction SilentlyContinue | Where-Object { $_.IPv4DefaultGateway -ne $null } | Select-Object -First 1
            if ($ipConfig -and $ipConfig.IPv4Address) {
                $systemInfo.DireccionIP = $ipConfig.IPv4Address.IPAddress
            } else {
                $systemInfo.DireccionIP = "No disponible"
            }
        } catch {
            $systemInfo.DireccionIP = "Error al obtener"
        }
        
        try {
            $macInfo = Get-NetAdapter -ErrorAction SilentlyContinue | Where-Object { $_.Status -eq "Up" } | Select-Object -First 1
            if ($macInfo) {
                $systemInfo.DireccionMAC = $macInfo.MacAddress
            } else {
                $systemInfo.DireccionMAC = "No disponible"
            }
        } catch {
            $systemInfo.DireccionMAC = "Error al obtener"
        }
        
        # Copiar a propiedades compatibles
        $systemInfo.ComputerName = $systemInfo.Hostname
        $systemInfo.Domain = $systemInfo.Dominio
        $systemInfo.OSName = $systemInfo.SistemaOperativo
        $systemInfo.OSVersion = $systemInfo.VersionOS
        $systemInfo.LastBoot = $systemInfo.UltimoArranque
        $systemInfo.UptimeHours = $systemInfo.TiempoActividad
        
        # Guardar datos en la estructura global
        $systemData.SystemInfo = $systemInfo
        
        Show-Progress -PhaseNumber 1 -PhaseName "AUDITORÍA BÁSICA DEL SISTEMA" -Percent 40
        
        # 2. INFORMACIÓN DE DISCOS
        Write-Log "Analizando discos..." -Level "INFO"
        $diskData = @()
        
        try {
            $logicalDisks = Get-CimInstance Win32_LogicalDisk -ErrorAction SilentlyContinue
            
            if ($logicalDisks) {
                foreach ($disk in $logicalDisks) {
                    $diskInfo = [DiskInfo]::new()
                    $diskInfo.Disco = $disk.DeviceID
                    $diskInfo.Tipo = switch ($disk.DriveType) {
                        2 { "Removible" }
                        3 { "Local" }
                        4 { "Red" }
                        5 { "CD-ROM" }
                        default { "Desconocido" }
                    }
                    $diskInfo.SizeGB = if ($disk.Size -gt 0) { [math]::Round($disk.Size / 1GB, 2) } else { 0 }
                    $diskInfo.FreeGB = if ($disk.FreeSpace -gt 0) { [math]::Round($disk.FreeSpace / 1GB, 2) } else { 0 }
                    $diskInfo.PercentFree = if ($disk.Size -gt 0) { [math]::Round(($disk.FreeSpace / $disk.Size) * 100, 2) } else { 0 }
                    $diskInfo.SistemaArchivos = if ($disk.FileSystem) { $disk.FileSystem } else { "N/A" }
                    $diskInfo.Model = if ($disk.VolumeName) { $disk.VolumeName } else { "Sin nombre" }
                    $diskInfo.Serial = "N/A"
                    $diskInfo.HealthStatus = "N/A"
                    $diskInfo.Temperature = "N/A"
                    
                    $diskData += $diskInfo
                }
            } else {
                Write-Log "⚠ No se detectaron discos lógicos" -Level "WARNING"
            }
        } catch {
            Write-Log "Error al obtener información de discos: $_" -Level "ERROR"
        }
        
        $systemData.DiskInfo = $diskData
        
        Show-Progress -PhaseNumber 1 -PhaseName "AUDITORÍA BÁSICA DEL SISTEMA" -Percent 60

# 3. PERFILES DE USUARIO
        Write-Log "Analizando perfiles de usuario..." -Level "INFO"
        $userProfiles = @()
        
        try {
            $profiles = Get-CimInstance Win32_UserProfile -ErrorAction SilentlyContinue | Where-Object { -not $_.Special }
            
            if ($profiles) {
                foreach ($profile in $profiles) {
                    try {
                        $profilePath = $profile.LocalPath
                        $userName = Split-Path $profilePath -Leaf
                        
                        # ✅ CORRECCIÓN: Validar que la ruta existe antes de procesar
                        if (-not (Test-Path $profilePath)) {
                            Write-Log "⚠ Perfil $userName no accesible en $profilePath" -Level "WARNING"
                            continue
                        }
                        
                        $profileInfo = [UserProfileInfo]::new()
                        $profileInfo.UserName = $userName
                        $profileInfo.ProfilePath = $profilePath
                        
                        # Calcular tamaño con manejo de errores
                        try {
                            $sizeBytes = (Get-ChildItem -Path $profilePath -Recurse -Force -ErrorAction SilentlyContinue | 
                                         Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum
                            
                            if ($sizeBytes -gt 0) {
                                $profileInfo.Size_MB = [math]::Round($sizeBytes / 1MB, 2)
                                $profileInfo.SizeGB = [math]::Round($sizeBytes / 1GB, 2)
                            } else {
                                $profileInfo.Size_MB = 0
                                $profileInfo.SizeGB = 0
                            }
                        } catch {
                            Write-Log "⚠ No se pudo calcular tamaño de perfil $userName" -Level "WARNING"
                            $profileInfo.Size_MB = 0
                            $profileInfo.SizeGB = 0
                        }
                        
                        # Fecha de último uso
                        if ($profile.LastUseTime) {
                            $profileInfo.LastUseTime = $profile.LastUseTime
                        } else {
                            $profileInfo.LastUseTime = [datetime]::MinValue
                        }
                        
                        # Calcular días inactivos
                        if ($profileInfo.LastUseTime -ne [datetime]::MinValue) { 
                            $profileInfo.DaysInactive = [math]::Round(((Get-Date) - $profileInfo.LastUseTime).TotalDays, 0)
                        } else { 
                            $profileInfo.DaysInactive = 999
                        }
                        
                        # Estado
                        if ($profile.Loaded) { 
                            $profileInfo.Estado = "Cargado"
                            $profileInfo.ActivityStatus = "Activo"
                        } else { 
                            $profileInfo.Estado = "Inactivo"
                            if ($profileInfo.DaysInactive -lt 30) {
                                $profileInfo.ActivityStatus = "Reciente"
                            } else {
                                $profileInfo.ActivityStatus = "Inactivo"
                            }
                        }
                        
                        # Propiedades compatibles
                        $profileInfo.Usuario = $profileInfo.UserName
                        $profileInfo.RutaPerfil = $profileInfo.ProfilePath
                        $profileInfo.Tamano_MB = $profileInfo.Size_MB
                        
                        $userProfiles += $profileInfo
                        
                    } catch {
                        Write-Log "Error procesando perfil ${userName}: $_" -Level "WARNING"
                    }
                }
            } else {
                Write-Log "⚠ No se detectaron perfiles de usuario" -Level "WARNING"
            }
        } catch {
            Write-Log "Error al obtener perfiles de usuario: $_" -Level "ERROR"
        }
        
        $systemData.UserProfiles = $userProfiles
        
        Show-Progress -PhaseNumber 1 -PhaseName "AUDITORÍA BÁSICA DEL SISTEMA" -Percent 80
        
        # 4. APLICACIONES INSTALADAS
        Write-Log "Recopilando aplicaciones instaladas..." -Level "INFO"
        $applications = @()
        
        try {
            $uninstallPaths = @(
                "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
                "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
            )
            
            foreach ($path in $uninstallPaths) {
                try {
                    $items = Get-ItemProperty -Path $path -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName }
                    
                    foreach ($item in $items) {
                        $app = [ApplicationInfo]::new()
                        $app.Name = $item.DisplayName
                        $app.Version = if ($item.DisplayVersion) { $item.DisplayVersion } else { "N/A" }
                        $app.Publisher = if ($item.Publisher) { $item.Publisher } else { "N/A" }
                        
                        # ✅ CORRECCIÓN: Parseo seguro de fecha de instalación
                        if ($item.InstallDate -and $item.InstallDate -match '^\d{8}$') {
                            try { 
                                $app.InstallDate = [datetime]::ParseExact($item.InstallDate, 'yyyyMMdd', $null) 
                            } catch { 
                                $app.InstallDate = [datetime]::MinValue 
                            }
                        } else { 
                            $app.InstallDate = [datetime]::MinValue 
                        }
                        
                        $app.InstallSource = if ($item.InstallSource) { $item.InstallSource } else { "Registry" }
                        $applications += $app
                    }
                } catch {
                    Write-Log "⚠ Error accediendo a ruta $path" -Level "WARNING"
                }
            }
        } catch {
            Write-Log "Error al obtener aplicaciones instaladas: $_" -Level "ERROR"
        }
        
        $systemData.Applications = $applications
        
        # 5. IMPRESORAS CONFIGURADAS
        Write-Log "Recopilando impresoras..." -Level "INFO"
        $printers = @()
        
        try {
            # ✅ CORRECCIÓN: Usar Get-Printer en lugar de WMI
            $printerList = Get-Printer -ErrorAction SilentlyContinue
            
            if ($printerList) {
                foreach ($printer in $printerList) {
                    $printerInfo = [PrinterInfo]::new()
                    $printerInfo.Name = $printer.Name
                    $printerInfo.DriverName = if ($printer.DriverName) { $printer.DriverName } else { "N/A" }
                    $printerInfo.PortName = if ($printer.PortName) { $printer.PortName } else { "N/A" }
                    $printerInfo.Type = if ($printer.PortName -like "*\*") { "Compartida" } else { "Local" }
                    $printerInfo.Shared = $printer.Shared
                    $printerInfo.Status = $printer.PrinterStatus.ToString()
                    $printerInfo.ComputerName = $ComputerName
                    
                    # Extraer IP del puerto si es posible
                    if ($printer.PortName -match '\b(?:\d{1,3}\.){3}\d{1,3}\b') {
                        $printerInfo.IPAddress = $matches[0]
                    } else {
                        $printerInfo.IPAddress = "N/D"
                    }
                    
                    $printerInfo.MarcaModelo = "N/D"
                    $printerInfo.RutaRed = if ($printer.PortName -like "*\*") { $printer.PortName } else { "Local" }
                    
                    $printers += $printerInfo
                }
            } else {
                Write-Log "⚠ No se detectaron impresoras configuradas" -Level "WARNING"
            }
        } catch {
            Write-Log "Error al obtener impresoras: $_" -Level "ERROR"
        }
        
        $systemData.Printers = $printers
        
        # 6. SERVICIOS CRÍTICOS
        Write-Log "Verificando servicios críticos..." -Level "INFO"
        $criticalServiceNames = @("wuauserv", "BITS", "Winmgmt", "Spooler", "EventLog", "Dhcp", "Dnscache")
        $serviceStatus = @()
        
        try {
            foreach ($serviceName in $criticalServiceNames) {
                try {
                    $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
                    
                    if ($service) {
                        $serviceInfo = [ServiceInfo]::new()
                        $serviceInfo.Name = $serviceName
                        $serviceInfo.DisplayName = $service.DisplayName
                        $serviceInfo.Status = $service.Status.ToString()
                        $serviceInfo.StartType = $service.StartType.ToString()
                        $serviceInfo.IsCritical = "Sí"
                        $serviceInfo.RequiredState = "Running"
                        
                        $serviceStatus += $serviceInfo
                    } else {
                        Write-Log "⚠ Servicio $serviceName no encontrado" -Level "WARNING"
                    }
                } catch {
                    Write-Log "⚠ Error verificando servicio $serviceName" -Level "WARNING"
                }
            }
        } catch {
            Write-Log "Error al verificar servicios: $_" -Level "ERROR"
        }
        
        $systemData.ServiceStatus = $serviceStatus
        
        Show-Progress -PhaseNumber 1 -PhaseName "AUDITORÍA BÁSICA DEL SISTEMA" -Percent 90
        
        # 7. MANTENIMIENTO AUTOMÁTICO (si está habilitado)
        if ($AutoClean) {
            Write-Log "Ejecutando mantenimiento automático..." -Level "INFO"
            
            try {
                $tempFolders = @("$env:TEMP\*", "C:\Windows\Temp\*")
                $cleanedCount = 0
                
                foreach ($folder in $tempFolders) {
                    try {
                        $oldFiles = Get-ChildItem $folder -Recurse -ErrorAction SilentlyContinue | 
                                   Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-7) }
                        
                        if ($oldFiles) {
                            foreach ($file in $oldFiles) {
                                try {
                                    Remove-Item -Path $file.FullName -Recurse -Force -ErrorAction SilentlyContinue
                                    $cleanedCount++
                                } catch {
                                    # Ignorar errores de archivos bloqueados
                                }
                            }
                        }
                    } catch {
                        Write-Log "⚠ Error limpiando carpeta temporal" -Level "WARNING"
                    }
                }
                
                Write-Log "Limpieza completada: $cleanedCount archivos temporales eliminados" -Level "SUCCESS"
            } catch {
                Write-Log "Error en mantenimiento automático: $_" -Level "ERROR"
            }
        }

# 8. GENERAR REPORTE CONSOLIDADO (para esta fase)
        Write-Log "Generando reporte consolidado de Fase 1..." -Level "INFO"
        
        # ✅ CORRECCIÓN: Validar datos antes de calcular estadísticas
        $discoC = $diskData | Where-Object { $_.Disco -eq "C:" } | Select-Object -First 1
        
        $report = [PSCustomObject]@{
            Auditoria_ID = "$ComputerName`_$Timestamp"
            Fecha = $systemInfo.FechaAuditoria
            Equipo = $systemInfo.Hostname
            Usuario = $systemInfo.UsuarioActual
            SO = $systemInfo.SistemaOperativo
            RAM_GB = $systemInfo.RAM_GB
            Procesador = $systemInfo.Procesador
            DiscoC_TamanoGB = if ($discoC) { $discoC.SizeGB } else { 0 }
            DiscoC_LibreGB = if ($discoC) { $discoC.FreeGB } else { 0 }
            DiscoC_Porcentaje = if ($discoC) { $discoC.PercentFree } else { 0 }
            NumeroPerfiles = $userProfiles.Count
            Perfiles_Mayores2GB = ($userProfiles | Where-Object { $_.SizeGB -gt 2 }).Count
            Perfiles_Inactivos30d = ($userProfiles | Where-Object { $_.DaysInactive -gt 30 }).Count
            Perfil_MasGrande = if ($userProfiles.Count -gt 0) { ($userProfiles | Sort-Object SizeGB -Descending | Select-Object -First 1).UserName } else { "N/A" }
            TamanoPerfil_MasGrande = if ($userProfiles.Count -gt 0) { ($userProfiles | Sort-Object SizeGB -Descending | Select-Object -First 1).SizeGB } else { 0 }
            Aplicaciones_Total = $applications.Count
            Impresoras_Totales = $printers.Count
            Impresoras_Compartidas = ($printers | Where-Object { $_.Shared }).Count
            Servicios_Criticos = $serviceStatus.Count
            Servicios_NoEjecutando = ($serviceStatus | Where-Object { $_.Status -ne "Running" }).Count
            Estado_Espacio = if ($discoC) { 
                if ($discoC.PercentFree -lt 20) { "CRITICO" } 
                elseif ($discoC.PercentFree -lt 30) { "ALERTA" } 
                else { "OK" } 
            } else { "NO DETECTADO" }
            Estado_Perfiles = if ($userProfiles.Count -gt 15) { "ALERTA" } else { "OK" }
            Estado_Servicios = if ($serviceStatus.Count -eq 0 -or ($serviceStatus | Where-Object { $_.Status -ne "Running" }).Count -gt 0) { "ALERTA" } else { "OK" }
            Mantenimiento_Ejecutado = $AutoClean
            Observaciones = ""
        }
        
        # Exportar reporte de esta fase
        $fase1ReportFile = Join-Path $phaseFolders[1] "$ComputerName`_Fase1_$Timestamp.csv"
        $report | Export-Csv -Path $fase1ReportFile -NoTypeInformation -Encoding UTF8
        Write-Log "Reporte Fase 1 guardado: $fase1ReportFile" -Level "SUCCESS"
        
        # Crear reporte legible en texto
        $textReport = @"
===================================================
        REPORTE DE AUDITORÍA DEL SISTEMA - FASE 1
===================================================
Auditoría completa diseñada por victor 3,1416
Equipo: $ComputerName
Fecha: $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')

Fecha: $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')
Equipo: $ComputerName
Usuario: $($systemInfo.UsuarioActual)
Sistema Operativo: $($systemInfo.SistemaOperativo)

** HARDWARE **
Procesador: $($systemInfo.Procesador)
Nucleos: $($systemInfo.Nucleos)
RAM Total: $($systemInfo.RAM_GB) GB
Fabricante: $($systemInfo.Fabricante)
Modelo: $($systemInfo.Modelo)

** ALMACENAMIENTO **
Disco C: $($report.DiscoC_LibreGB) GB libre de $($report.DiscoC_TamanoGB) GB ($($report.DiscoC_Porcentaje)%)
Estado: $($report.Estado_Espacio)

** PERFILES DE USUARIO **
Total de perfiles: $($report.NumeroPerfiles)
Perfiles >2GB: $($report.Perfiles_Mayores2GB)
Perfiles inactivos >30 días: $($report.Perfiles_Inactivos30d)
Perfil más grande: $($report.Perfil_MasGrande) ($($report.TamanoPerfil_MasGrande) GB)

** SOFTWARE **
Aplicaciones instaladas: $($report.Aplicaciones_Total)
Impresoras configuradas: $($report.Impresoras_Totales)
Servicios críticos: $($report.Servicios_Criticos) (No ejecutando: $($report.Servicios_NoEjecutando))

** RESUMEN DE ESTADO **
Espacio en disco: $($report.Estado_Espacio)
Gestión de perfiles: $($report.Estado_Perfiles)
Servicios del sistema: $($report.Estado_Servicios)

** RECOMENDACIONES **
$(if($report.Estado_Espacio -eq "CRITICO"){"- Liberar espacio en disco C: inmediatamente`n"}else{""})
$(if($report.Perfiles_Mayores2GB -gt 0){"- Revisar perfiles de usuario mayores a 2GB`n"}else{""})
$(if($report.Servicios_NoEjecutando -gt 0){"- Verificar servicios críticos no ejecutándose`n"}else{""})

===================================================
Reporte generado automáticamente
Archivo CSV: $fase1ReportFile
===================================================
"@
        
        $textReportFile = Join-Path $phaseFolders[1] "$ComputerName`_Fase1_$Timestamp.txt"
        $textReport | Out-File -FilePath $textReportFile -Encoding UTF8
        
        Show-Progress -PhaseNumber 1 -PhaseName "AUDITORÍA BÁSICA DEL SISTEMA" -Percent 100
        
        # Mostrar resumen en pantalla
        Write-Host "`n=== RESUMEN FASE 1 ===" -ForegroundColor Cyan
        Write-Host "Auditoría completa diseñada por victor 3,1416" -ForegroundColor DarkGray
        Write-Host "Equipo: $ComputerName | Fecha: $(Get-Date -Format 'dd/MM/yyyy HH:mm')" -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "✓ Equipo: $ComputerName" -ForegroundColor Green
        
        if ($discoC) {
            $color = if ($report.Estado_Espacio -eq "CRITICO") { "Red" } elseif ($report.Estado_Espacio -eq "ALERTA") { "Yellow" } else { "Green" }
            Write-Host "✓ Espacio C: $($report.DiscoC_LibreGB)GB libre ($($report.DiscoC_Porcentaje)%) - $($report.Estado_Espacio)" -ForegroundColor $color
        } else {
            Write-Host "⚠ Disco C: No detectado" -ForegroundColor Yellow
        }
        
        Write-Host "✓ Perfiles: $($report.NumeroPerfiles) totales, $($report.Perfiles_Mayores2GB) >2GB" -ForegroundColor Green
        Write-Host "✓ Servicios: $($report.Servicios_Criticos) críticos, $($report.Servicios_NoEjecutando) no ejecutando" -ForegroundColor Green
        Write-Host ""
        Write-Host "=== ARCHIVOS GENERADOS (FASE 1) ===" -ForegroundColor Green
        Write-Host "* Reporte CSV: $fase1ReportFile"
        Write-Host "* Reporte TXT: $textReportFile"
        
        # Guardar datos en estructura global
        $global:AuditData.Fase1 = $systemData
        
        $fase1Duration = [math]::Round(((Get-Date) - $fase1Start).TotalSeconds, 2)
        Write-Log "Fase 1 (Auditoría Básica) completada en $fase1Duration segundos" -Level "SUCCESS"
        
        return $true
    }
    catch {
        Write-Log "Error en auditoría básica: $_" -Level "ERROR"
        Write-Log "Stack trace: $($_.ScriptStackTrace)" -Level "ERROR"
        return $false
    }
}
#endregion

#region FUNCIONES DE FASE 2 (RECOLECCIÓN DE DATOS)
function Invoke-Fase2 {
    Show-Progress -PhaseNumber 2 -PhaseName "RECOLECCIÓN DE DATOS DEL SISTEMA" -Percent 10
    Show-AuditHeader -Title "FASE 2 - RECOLECCIÓN DE DATOS DEL SISTEMA" -Subtitle "Análisis detallado de hardware y configuración"
    
    Write-Log "Iniciando Fase 2: Recolección de datos del sistema" -Level "INFO"
    $fase2Start = Get-Date
    $fase2Data = @{}
    
    try {
        # 2.1. Obtener información del sistema (actualizada)
        Show-Progress -PhaseNumber 2 -PhaseName "RECOLECCIÓN DE DATOS DEL SISTEMA" -Percent 20
        Write-Log "Obteniendo información del sistema..." -Level "INFO"
        
        $systemInfoF2 = Get-SystemInformationF2
        $fase2Data.SystemInfo = $systemInfoF2
        
        # 2.2. Obtener información de discos (actualizada)
        Show-Progress -PhaseNumber 2 -PhaseName "RECOLECCIÓN DE DATOS DEL SISTEMA" -Percent 40
        Write-Log "Obteniendo información de discos..." -Level "INFO"
        
        $diskInfoF2 = Get-DiskInformationF2
        $fase2Data.DiskInfo = $diskInfoF2
        
        # 2.3. Obtener información de red
        Show-Progress -PhaseNumber 2 -PhaseName "RECOLECCIÓN DE DATOS DEL SISTEMA" -Percent 60
        Write-Log "Obteniendo información de red..." -Level "INFO"
        
        $networkInfoF2 = Get-NetworkInformationF2
        $fase2Data.NetworkInfo = $networkInfoF2
        
        # Guardar datos de esta fase
        $global:AuditData.Fase2 = $fase2Data
        
        # Generar reporte de Fase 2
        Show-Progress -PhaseNumber 2 -PhaseName "RECOLECCIÓN DE DATOS DEL SISTEMA" -Percent 80
        Export-Fase2Reports -SystemInfo $systemInfoF2 -DiskInfo $diskInfoF2 -NetworkInfo $networkInfoF2 `
                           -ComputerName $ComputerName -Timestamp $Timestamp -PhaseFolders $phaseFolders
        
        Show-Progress -PhaseNumber 2 -PhaseName "RECOLECCIÓN DE DATOS DEL SISTEMA" -Percent 100
        $fase2Duration = [math]::Round(((Get-Date) - $fase2Start).TotalSeconds, 2)
        Write-Log "Fase 2 completada en $fase2Duration segundos" -Level "SUCCESS"
        
        return $true
    }
    catch {
        Write-Log "Error en Fase 2: $_" -Level "ERROR"
        return $false
    }
}

function Get-SystemInformationF2 {
    [CmdletBinding()]
    param()
    
    Write-Log "Obteniendo información del sistema (Fase 2)..." -Level "INFO"
    
    $systemInfo = [SystemInfo]::new()
    $uptime = "N/A"
    
    try {
        # ✅ CORRECCIÓN: Usar Get-ComputerInfo con manejo de errores robusto
        try {
            $computerInfo = Get-ComputerInfo -ErrorAction Stop
            
            $systemInfo.ComputerName = $env:COMPUTERNAME
            $systemInfo.Domain = if ($computerInfo.CsDomain) { $computerInfo.CsDomain } else { $env:USERDOMAIN }
            $systemInfo.Workgroup = if ($computerInfo.CsWorkgroup) { $computerInfo.CsWorkgroup } else { "N/A" }
            $systemInfo.OSName = if ($computerInfo.WindowsProductName) { $computerInfo.WindowsProductName } else { $computerInfo.OsName }
            $systemInfo.OSVersion = if ($computerInfo.WindowsVersion) { $computerInfo.WindowsVersion } else { $computerInfo.OsVersion }
            $systemInfo.OSBuild = if ($computerInfo.WindowsBuildLabEx) { $computerInfo.WindowsBuildLabEx } else { $computerInfo.OsBuildNumber }
            $systemInfo.InstallDate = if ($computerInfo.OsInstallDate) { $computerInfo.OsInstallDate.ToString("yyyy-MM-dd HH:mm:ss") } else { "N/A" }
            $systemInfo.TimeZone = (Get-TimeZone).Id
            $systemInfo.LastBoot = if ($computerInfo.OsLastBootUpTime) { $computerInfo.OsLastBootUpTime.ToString("yyyy-MM-dd HH:mm:ss") } else { "N/A" }
            
            # Calcular uptime
            if ($computerInfo.OsLastBootUpTime -and ($computerInfo.OsLastBootUpTime -is [DateTime])) {
                $uptime = [math]::Round((New-TimeSpan -Start $computerInfo.OsLastBootUpTime -End (Get-Date)).TotalHours, 2)
            }
            
            $systemInfo.UptimeHours = $uptime.ToString()
            
            $systemInfo.Locale = (Get-Culture).Name
            
            # ✅ CORRECCIÓN: Manejo seguro de distribución de teclado
            try {
                $langList = Get-WinUserLanguageList -ErrorAction SilentlyContinue
                if ($langList -and $langList.Count -gt 0 -and $langList[0].InputMethodTips) {
                    $systemInfo.KeyboardLayout = $langList[0].InputMethodTips[0]
                } else {
                    $systemInfo.KeyboardLayout = "N/A"
                }
            } catch {
                $systemInfo.KeyboardLayout = "N/A"
            }
            
            # Hardware adicional
            $systemInfo.Fabricante = if ($computerInfo.CsManufacturer) { $computerInfo.CsManufacturer } else { "N/A" }
            $systemInfo.Modelo = if ($computerInfo.CsModel) { $computerInfo.CsModel } else { "N/A" }
            $systemInfo.RAM_GB = if ($computerInfo.CsTotalPhysicalMemory) { 
                [math]::Round($computerInfo.CsTotalPhysicalMemory / 1GB, 2) 
            } else { 0 }
            
            $systemInfo.Procesador = if ($computerInfo.CsProcessors) { 
                $computerInfo.CsProcessors[0].Name 
            } else { "N/A" }
            
            $systemInfo.Nucleos = if ($computerInfo.CsNumberOfProcessors -and $computerInfo.CsNumberOfLogicalProcessors) { 
                "$($computerInfo.CsNumberOfProcessors)/$($computerInfo.CsNumberOfLogicalProcessors)" 
            } else { "N/A" }
            
            # Número de serie del BIOS
            $systemInfo.NumeroSerie = if ($computerInfo.BiosSeralNumber) { 
                $computerInfo.BiosSeralNumber 
            } else { 
                try {
                    $bios = Get-CimInstance Win32_BIOS -ErrorAction SilentlyContinue
                    if ($bios) { $bios.SerialNumber } else { "N/A" }
                } catch { "N/A" }
            }
            
            Write-Log "Información del sistema recolectada (Fase 2)" -Level "SUCCESS"
            
        } catch {
            # ✅ Fallback: Si Get-ComputerInfo falla, usar métodos alternativos
            Write-Log "⚠ Get-ComputerInfo no disponible, usando métodos alternativos..." -Level "WARNING"
            
            $systemInfo.ComputerName = $env:COMPUTERNAME
            $systemInfo.Domain = $env:USERDOMAIN
            $systemInfo.Workgroup = "N/A"
            
            # Usar WMI como respaldo
            $osInfo = Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue
            $computerSystem = Get-CimInstance Win32_ComputerSystem -ErrorAction SilentlyContinue
            $bios = Get-CimInstance Win32_BIOS -ErrorAction SilentlyContinue
            $processor = Get-CimInstance Win32_Processor -ErrorAction SilentlyContinue | Select-Object -First 1
            
            if ($osInfo) {
                $systemInfo.OSName = $osInfo.Caption
                $systemInfo.OSVersion = $osInfo.Version
                $systemInfo.OSBuild = $osInfo.BuildNumber
                $systemInfo.InstallDate = $osInfo.InstallDate.ToString("yyyy-MM-dd HH:mm:ss")
                $systemInfo.LastBoot = $osInfo.LastBootUpTime.ToString("yyyy-MM-dd HH:mm:ss")
                $systemInfo.UptimeHours = [math]::Round(((Get-Date) - $osInfo.LastBootUpTime).TotalHours, 2).ToString()
            }
            
            if ($computerSystem) {
                $systemInfo.Fabricante = $computerSystem.Manufacturer
                $systemInfo.Modelo = $computerSystem.Model
                $systemInfo.RAM_GB = [math]::Round($computerSystem.TotalPhysicalMemory / 1GB, 2)
            }
            
            if ($bios) {
                $systemInfo.NumeroSerie = $bios.SerialNumber
            }
            
            if ($processor) {
                $systemInfo.Procesador = $processor.Name
                $systemInfo.Nucleos = "$($processor.NumberOfCores)/$($processor.NumberOfLogicalProcessors)"
            }
            
            $systemInfo.TimeZone = (Get-TimeZone).Id
            $systemInfo.Locale = (Get-Culture).Name
            $systemInfo.KeyboardLayout = "N/A"
        }
        
        # Propiedades compatibles (copiar valores)
        $systemInfo.Hostname = $systemInfo.ComputerName
        $systemInfo.UsuarioActual = $env:USERNAME
        $systemInfo.Dominio = $systemInfo.Domain
        $systemInfo.SistemaOperativo = $systemInfo.OSName
        $systemInfo.VersionOS = $systemInfo.OSVersion
        $systemInfo.Arquitectura = if ([Environment]::Is64BitOperatingSystem) { "64-bit" } else { "32-bit" }
        $systemInfo.UltimoArranque = $systemInfo.LastBoot
        $systemInfo.TiempoActividad = $systemInfo.UptimeHours
        $systemInfo.FechaAuditoria = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        
    }
    catch {
        Write-Log "ERROR obteniendo información del sistema (Fase 2): $_" -Level "ERROR"
        
        # Asignar valores por defecto en caso de error crítico
        $systemInfo.ComputerName = $env:COMPUTERNAME
        $systemInfo.Hostname = $env:COMPUTERNAME
        $systemInfo.UsuarioActual = $env:USERNAME
        $systemInfo.Dominio = $env:USERDOMAIN
        $systemInfo.OSName = "Windows (versión no detectada)"
        $systemInfo.OSVersion = "N/A"
        $systemInfo.UptimeHours = "N/A"
        $systemInfo.FechaAuditoria = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    }
    
    return $systemInfo
}

function Get-DiskInformationF2 {
    [CmdletBinding()]
    param()
    
    Write-Log "Obteniendo información de discos (Fase 2)..." -Level "INFO"
    
    # Limpiar caché de PowerShell
    Get-PSDrive | Out-Null
    
    # Array para SOLO discos válidos
    $validDisks = @()
    
    try {
        # ✅ CORRECCIÓN: Intentar primero con Get-Disk, si falla usar WMI
        $allDisks = $null
        
        try {
            $allDisks = Get-Disk -ErrorAction Stop
        } catch {
            Write-Log "⚠ Get-Disk no disponible, usando método alternativo WMI..." -Level "WARNING"
            
            # Fallback: Usar WMI/CIM para obtener discos lógicos
            $logicalDisks = Get-CimInstance Win32_LogicalDisk -ErrorAction SilentlyContinue
            
            if ($logicalDisks) {
                foreach ($disk in $logicalDisks) {
                    if ($disk.Size -gt 0) {
                        $diskInfo = [DiskInfo]::new()
                        $diskInfo.Disco = $disk.DeviceID
                        $diskInfo.Tipo = switch ($disk.DriveType) {
                            2 { "Removible" }
                            3 { "Local" }
                            4 { "Red" }
                            5 { "CD-ROM" }
                            default { "Desconocido" }
                        }
                        $diskInfo.Model = if ($disk.VolumeName) { $disk.VolumeName } else { "Sin nombre" }
                        $diskInfo.Serial = "N/A"
                        $diskInfo.SizeGB = [math]::Round($disk.Size / 1GB, 2)
                        $diskInfo.FreeGB = [math]::Round($disk.FreeSpace / 1GB, 2)
                        $diskInfo.PercentFree = [math]::Round(($disk.FreeSpace / $disk.Size) * 100, 2)
                        $diskInfo.SistemaArchivos = if ($disk.FileSystem) { $disk.FileSystem } else { "N/A" }
                        $diskInfo.HealthStatus = "N/A (WMI)"
                        $diskInfo.Temperature = "N/A"
                        
                        $validDisks += $diskInfo
                    }
                }
                
                Write-Log "✓ Método WMI: $($validDisks.Count) discos detectados" -Level "SUCCESS"
                return ,$validDisks
            }
        }
        
        # Si llegamos aquí, Get-Disk funcionó
        if (-not $allDisks) {
            Write-Log "No se detectaron discos en el sistema" -Level "WARNING"
            
            # Crear UN disco placeholder si no hay NINGUNO
            $placeholder = [DiskInfo]::new()
            $placeholder.Disco = "Sin discos detectados"
            $placeholder.Tipo = "N/A"
            $placeholder.Model = "Sistema sin discos físicos"
            $placeholder.Serial = "N/A"
            $placeholder.SizeGB = 0
            $placeholder.FreeGB = 0
            $placeholder.PercentFree = 0
            $placeholder.HealthStatus = "N/A"
            $placeholder.Temperature = "N/A"
            $placeholder.SistemaArchivos = "N/A"
            
            return ,$placeholder
        }
        
        $totalDetected = @($allDisks).Count
        Write-Log "Discos físicos detectados por Windows: $totalDetected" -Level "INFO"
        
        # FILTRAR: Solo procesar discos que cumplan TODOS los criterios
        foreach ($disk in $allDisks) {
            
            # ❌ SALTAR si no cumple criterios mínimos
            if (-not $disk) {
                Write-Log "Disco null ignorado" -Level "WARNING"
                continue
            }
            
            if ($null -eq $disk.Number) {
                Write-Log "Disco sin número ignorado" -Level "WARNING"
                continue
            }
            
            if ($disk.Size -le 0) {
                Write-Log "Disco $($disk.Number) ignorado: Sin tamaño (Size=$($disk.Size))" -Level "WARNING"
                continue
            }
            
            # ✅ ESTE DISCO ES VÁLIDO - Procesar
            $diskInfo = [DiskInfo]::new()
            
            $diskInfo.Disco = "Disk $($disk.Number)"
            $diskInfo.Tipo = if ($disk.BusType) { $disk.BusType.ToString() } else { "Desconocido" }
            $diskInfo.Model = if ($disk.Model) { $disk.Model.Trim() } else { "Modelo no identificado" }
            $diskInfo.Serial = if ($disk.SerialNumber) { $disk.SerialNumber.Trim() } else { "Serial no disponible" }
            
            # Cálculo de tamaños (ya sabemos que Size > 0)
            $diskInfo.SizeGB = [math]::Round($disk.Size / 1GB, 2)
            
            # ✅ CORRECCIÓN: Obtener espacio libre REAL de las particiones del disco
            try {
                $partitions = Get-Partition -DiskNumber $disk.Number -ErrorAction SilentlyContinue
                $totalFree = 0
                $hasPartitions = $false
                $fileSystem = "N/A"
                
                foreach ($partition in $partitions) {
                    if ($partition.DriveLetter) {
                        $hasPartitions = $true
                        $volume = Get-Volume -DriveLetter $partition.DriveLetter -ErrorAction SilentlyContinue
                        if ($volume) {
                            if ($volume.SizeRemaining) {
                                $totalFree += $volume.SizeRemaining
                            }
                            if ($volume.FileSystem -and $fileSystem -eq "N/A") {
                                $fileSystem = $volume.FileSystem
                            }
                        }
                    }
                }
                
                if ($hasPartitions) {
                    # Espacio libre de particiones montadas
                    $diskInfo.FreeGB = [math]::Round($totalFree / 1GB, 2)
                    $diskInfo.SistemaArchivos = $fileSystem
                } else {
                    # Sin particiones montadas - calcular desde AllocatedSize
                    $allocated = if ($disk.AllocatedSize) { $disk.AllocatedSize } else { 0 }
                    $diskInfo.FreeGB = [math]::Round(($disk.Size - $allocated) / 1GB, 2)
                    $diskInfo.SistemaArchivos = "Sin particiones"
                }
                
                # Calcular porcentaje libre
                if ($diskInfo.SizeGB -gt 0) {
                    $diskInfo.PercentFree = [math]::Round(($diskInfo.FreeGB / $diskInfo.SizeGB) * 100, 2)
                } else {
                    $diskInfo.PercentFree = 0
                }
            }
            catch {
                # Error al obtener particiones - usar cálculo básico
                $allocated = if ($disk.AllocatedSize) { $disk.AllocatedSize } else { $disk.Size }
                $diskInfo.FreeGB = [math]::Round(($disk.Size - $allocated) / 1GB, 2)
                $diskInfo.PercentFree = 0
                $diskInfo.SistemaArchivos = "Error al detectar"
                Write-Log "Advertencia: No se pudo calcular espacio libre exacto para Disco $($disk.Number)" -Level "WARNING"
            }
            
            # ✅ CORRECCIÓN: Información física (SMART, temperatura, estado)
            try {
                $physicalDisk = Get-PhysicalDisk -DeviceNumber $disk.Number -ErrorAction SilentlyContinue
                
                if ($physicalDisk) {
                    $diskInfo.HealthStatus = if ($physicalDisk.HealthStatus) { 
                        $physicalDisk.HealthStatus.ToString() 
                    } else { 
                        "Estado desconocido" 
                    }
                    
                    # Temperatura (solo si está disponible y es válida)
                    if ($physicalDisk.Temperature -and $physicalDisk.Temperature -gt 0 -and $physicalDisk.Temperature -lt 100) { 
                        $diskInfo.Temperature = "$($physicalDisk.Temperature)°C" 
                    } else { 
                        $diskInfo.Temperature = "No disponible" 
                    }
                } else {
                    $diskInfo.HealthStatus = "Información SMART no accesible"
                    $diskInfo.Temperature = "N/A"
                }
            }
            catch {
                $diskInfo.HealthStatus = "Error al consultar estado"
                $diskInfo.Temperature = "N/A"
            }
            
            # ✅ AGREGAR solo si llegó hasta aquí
            $validDisks += $diskInfo
            Write-Log "✓ Disco $($disk.Number) VÁLIDO: $($diskInfo.Model) - $($diskInfo.SizeGB) GB" -Level "INFO"
        }
        
        # RESULTADO FINAL
        if ($validDisks.Count -eq 0) {
            Write-Log "⚠ No se encontraron discos válidos/accesibles" -Level "WARNING"
            
            # Crear un placeholder indicando que hay discos pero no son accesibles
            $noValid = [DiskInfo]::new()
            $noValid.Disco = "Discos no accesibles"
            $noValid.Tipo = "Detectados pero inaccesibles"
            $noValid.Model = "Windows detectó $totalDetected disco(s) pero ninguno es accesible"
            $noValid.Serial = "N/A"
            $noValid.SizeGB = 0
            $noValid.FreeGB = 0
            $noValid.PercentFree = 0
            $noValid.HealthStatus = "No accesible"
            $noValid.Temperature = "N/A"
            $noValid.SistemaArchivos = "N/A"
            
            return ,$noValid
        }
        
        Write-Log "✓ Total discos VÁLIDOS procesados: $($validDisks.Count) de $totalDetected" -Level "SUCCESS"
        return ,$validDisks  # La coma fuerza array
        
    }
    catch {
        Write-Log "ERROR en Get-DiskInformation (Fase 2): $_" -Level "ERROR"
        
        # Disco de error
        $errorDisk = [DiskInfo]::new()
        $errorDisk.Disco = "Error crítico"
        $errorDisk.Tipo = "Error"
        $errorDisk.Model = "Error al escanear discos: $_"
        $errorDisk.Serial = "N/A"
        $errorDisk.SizeGB = 0
        $errorDisk.FreeGB = 0
        $errorDisk.PercentFree = 0
        $errorDisk.HealthStatus = "Error"
        $errorDisk.Temperature = "N/A"
        $errorDisk.SistemaArchivos = "N/A"
        
        return ,$errorDisk
    }
}

function Get-NetworkInformationF2 {
    [CmdletBinding()]
    param()
    
    Write-Log "Obteniendo información de red (Fase 2)..." -Level "INFO"
    
    $networkInfo = @{
        Interfaces = @()
        IPAddresses = @()
        DNS = @()
        Gateway = @()
        FechaRecoleccion = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    }
    
    try {
        # Obtener adaptadores de red (incluyendo todos, no solo los activos)
        $adapters = Get-NetAdapter -ErrorAction SilentlyContinue
        
        if (-not $adapters -or $adapters.Count -eq 0) {
            Write-Log "No se detectaron adaptadores de red" -Level "WARNING"
            $networkInfo.Interfaces += @{
                Name = "Sin adaptadores"
                Description = "No se detectaron interfaces de red"
                MAC = "00:00:00:00:00:00"
                Status = "No disponible"
                Speed = "N/A"
            }
        } else {
            Write-Log "Se encontraron $($adapters.Count) adaptadores de red" -Level "INFO"
            
            foreach ($adapter in $adapters) {
                $interfaceInfo = @{
                    Name = $adapter.Name
                    Description = if ($adapter.InterfaceDescription) { $adapter.InterfaceDescription } else { "Sin descripción" }
                    MAC = if ($adapter.MacAddress) { $adapter.MacAddress } else { "No disponible" }
                    Status = $adapter.Status.ToString()
                    Speed = if ($adapter.LinkSpeed) { $adapter.LinkSpeed } else { "N/A" }
                }
                
                $networkInfo.Interfaces += $interfaceInfo
                
                # Obtener configuración IP solo para adaptadores conectados
                if ($adapter.Status -eq "Up") {
                    try {
                        $ipConfig = Get-NetIPConfiguration -InterfaceIndex $adapter.InterfaceIndex -ErrorAction SilentlyContinue
                        
                        if ($ipConfig) {
                            # Direcciones IPv4
                            if ($ipConfig.IPv4Address) {
                                foreach ($ip in $ipConfig.IPv4Address) {
                                    if ($ip.IPAddress -and $networkInfo.IPAddresses -notcontains $ip.IPAddress) {
                                        $networkInfo.IPAddresses += $ip.IPAddress
                                    }
                                }
                            }
                            
                            # Servidores DNS
                            if ($ipConfig.DNSServer) {
                                foreach ($dns in $ipConfig.DNSServer) {
                                    if ($dns.ServerAddresses) {
                                        foreach ($dnsAddr in $dns.ServerAddresses) {
                                            if ($dnsAddr -and $networkInfo.DNS -notcontains $dnsAddr) {
                                                $networkInfo.DNS += $dnsAddr
                                            }
                                        }
                                    }
                                }
                            }
                            
                            # Gateway
                            if ($ipConfig.IPv4DefaultGateway) {
                                foreach ($gw in $ipConfig.IPv4DefaultGateway) {
                                    if ($gw.NextHop -and $networkInfo.Gateway -notcontains $gw.NextHop) {
                                        $networkInfo.Gateway += $gw.NextHop
                                    }
                                }
                            }
                        }
                    }
                    catch {
                        Write-Log "No se pudo obtener configuración IP para $($adapter.Name): $_" -Level "WARNING"
                    }
                }
            }
        }
        
        # Si no hay direcciones IP, agregar una indicación
        if ($networkInfo.IPAddresses.Count -eq 0) {
            $networkInfo.IPAddresses += "No se detectaron direcciones IP activas"
        }
        
        Write-Log "Información de red recolectada: $($networkInfo.Interfaces.Count) interfaces, $($networkInfo.IPAddresses.Count) IPs" -Level "SUCCESS"
    }
    catch {
        Write-Log "ERROR obteniendo información de red: $_" -Level "ERROR"
        # Mantener estructura básica incluso en error
        $networkInfo.Interfaces += @{
            Name = "Error en detección"
            Description = "No se pudo obtener información de red"
            MAC = "00:00:00:00:00:00"
            Status = "Error"
            Speed = "N/A"
        }
        $networkInfo.IPAddresses += "Error al obtener configuración IP"
    }
    
    return $networkInfo
}

function Export-Fase2Reports {
    [CmdletBinding()]
    param(
        [object]$SystemInfo,
        [array]$DiskInfo,
        [hashtable]$NetworkInfo,
        [string]$ComputerName,
        [string]$Timestamp,
        [hashtable]$PhaseFolders
    )
    
    Write-Log "Generando reportes de Fase 2..." -Level "INFO"
    
    try {
        # 1. Reporte CSV para Fase 2
        $csvData = @()
        
        # Encabezado de auditoría
        $csvData += [PSCustomObject]@{
            Seccion = "AUDITORIA"
            Propiedad = "Diseñado por"
            Valor = "victor 3,1416"
        }
        
        $csvData += [PSCustomObject]@{
            Seccion = "AUDITORIA"
            Propiedad = "Equipo"
            Valor = $ComputerName
        }
        
        $csvData += [PSCustomObject]@{
            Seccion = "AUDITORIA"
            Propiedad = "Fecha y hora"
            Valor = (Get-Date -Format "dd/MM/yyyy HH:mm:ss")
        }
        
        # ✅ CORRECCIÓN: Validar que SystemInfo existe antes de acceder
        if ($SystemInfo) {
            # Información del sistema
            $csvData += [PSCustomObject]@{
                Seccion = "SISTEMA"
                Propiedad = "Nombre del Equipo"
                Valor = if ($SystemInfo.ComputerName) { $SystemInfo.ComputerName } else { "N/A" }
            }
            
            $csvData += [PSCustomObject]@{
                Seccion = "SISTEMA"
                Propiedad = "Sistema Operativo"
                Valor = if ($SystemInfo.OSName -and $SystemInfo.OSVersion) { "$($SystemInfo.OSName) $($SystemInfo.OSVersion)" } else { "N/A" }
            }
            
            $csvData += [PSCustomObject]@{
                Seccion = "SISTEMA"
                Propiedad = "Build del SO"
                Valor = if ($SystemInfo.OSBuild) { $SystemInfo.OSBuild } else { "N/A" }
            }
            
            $csvData += [PSCustomObject]@{
                Seccion = "SISTEMA"
                Propiedad = "Dominio/Grupo de Trabajo"
                Valor = "$($SystemInfo.Domain)/$($SystemInfo.Workgroup)"
            }
            
            $csvData += [PSCustomObject]@{
                Seccion = "SISTEMA"
                Propiedad = "Fecha de Instalación"
                Valor = if ($SystemInfo.InstallDate) { $SystemInfo.InstallDate } else { "N/A" }
            }
            
            $csvData += [PSCustomObject]@{
                Seccion = "SISTEMA"
                Propiedad = "Último Arranque"
                Valor = if ($SystemInfo.LastBoot) { $SystemInfo.LastBoot } else { "N/A" }
            }
            
            $csvData += [PSCustomObject]@{
                Seccion = "SISTEMA"
                Propiedad = "Tiempo de Actividad (horas)"
                Valor = if ($SystemInfo.UptimeHours) { $SystemInfo.UptimeHours } else { "N/A" }
            }
            
            $csvData += [PSCustomObject]@{
                Seccion = "SISTEMA"
                Propiedad = "Zona Horaria"
                Valor = if ($SystemInfo.TimeZone) { $SystemInfo.TimeZone } else { "N/A" }
            }
            
            $csvData += [PSCustomObject]@{
                Seccion = "SISTEMA"
                Propiedad = "Configuración Regional"
                Valor = if ($SystemInfo.Locale) { $SystemInfo.Locale } else { "N/A" }
            }
        }
        
        # Separador
        $csvData += [PSCustomObject]@{
            Seccion = ""
            Propiedad = ""
            Valor = ""
        }
        
        # Discos
        if ($DiskInfo -and $DiskInfo.Count -gt 0) {
            $csvData += [PSCustomObject]@{
                Seccion = "DISCOS"
                Propiedad = "Número de Discos Detectados"
                Valor = $DiskInfo.Count
            }
            
            foreach ($disk in $DiskInfo) {
                $csvData += [PSCustomObject]@{
                    Seccion = "DISCOS"
                    Propiedad = "Disco: $($disk.Disco)"
                    Valor = "Modelo: $($disk.Model)"
                }
                
                $csvData += [PSCustomObject]@{
                    Seccion = "DISCOS"
                    Propiedad = "  Tipo"
                    Valor = $disk.Tipo
                }
                
                $csvData += [PSCustomObject]@{
                    Seccion = "DISCOS"
                    Propiedad = "  Tamaño Total"
                    Valor = "$($disk.SizeGB) GB"
                }
                
                $csvData += [PSCustomObject]@{
                    Seccion = "DISCOS"
                    Propiedad = "  Espacio Libre"
                    Valor = "$($disk.FreeGB) GB ($($disk.PercentFree)%)"
                }
                
                $csvData += [PSCustomObject]@{
                    Seccion = "DISCOS"
                    Propiedad = "  Estado de Salud"
                    Valor = $disk.HealthStatus
                }
                
                $csvData += [PSCustomObject]@{
                    Seccion = "DISCOS"
                    Propiedad = "  Temperatura"
                    Valor = $disk.Temperature
                }
                
                $csvData += [PSCustomObject]@{
                    Seccion = "DISCOS"
                    Propiedad = "  Número de Serie"
                    Valor = $disk.Serial
                }
            }
        }
        
        # Separador
        $csvData += [PSCustomObject]@{
            Seccion = ""
            Propiedad = ""
            Valor = ""
        }
        
        # Red
        if ($NetworkInfo -and $NetworkInfo.Interfaces -and $NetworkInfo.Interfaces.Count -gt 0) {
            $csvData += [PSCustomObject]@{
                Seccion = "RED"
                Propiedad = "Interfaces de Red Detectadas"
                Valor = $NetworkInfo.Interfaces.Count
            }
            
            foreach ($interface in $NetworkInfo.Interfaces) {
                $csvData += [PSCustomObject]@{
                    Seccion = "RED"
                    Propiedad = "Interfaz: $($interface.Name)"
                    Valor = $interface.Description
                }
                
                $csvData += [PSCustomObject]@{
                    Seccion = "RED"
                    Propiedad = "  Estado"
                    Valor = $interface.Status
                }
                
                $csvData += [PSCustomObject]@{
                    Seccion = "RED"
                    Propiedad = "  Velocidad"
                    Valor = $interface.Speed
                }
                
                $csvData += [PSCustomObject]@{
                    Seccion = "RED"
                    Propiedad = "  Dirección MAC"
                    Valor = $interface.MAC
                }
            }
            
            # Direcciones IP
            if ($NetworkInfo.IPAddresses -and $NetworkInfo.IPAddresses.Count -gt 0) {
                $csvData += [PSCustomObject]@{
                    Seccion = "RED"
                    Propiedad = "Direcciones IP Activas"
                    Valor = ($NetworkInfo.IPAddresses -join ", ")
                }
            }
        }
        
        # Exportar CSV
        $fase2CSV = Join-Path $PhaseFolders[2] "$ComputerName`_Fase2_$Timestamp.csv"
        $csvData | Export-Csv -Path $fase2CSV -NoTypeInformation -Encoding UTF8 -Delimiter ","
        Write-Log "Reporte CSV Fase 2 guardado: $fase2CSV" -Level "SUCCESS"
        
        # 2. Reporte resumen en consola
        Write-Host "`n=== RESUMEN FASE 2 ===" -ForegroundColor Cyan
        Write-Host "Auditoría completa diseñada por victor 3,1416" -ForegroundColor DarkGray
        Write-Host "Equipo: $ComputerName | Fecha: $(Get-Date -Format 'dd/MM/yyyy HH:mm')" -ForegroundColor DarkGray
        Write-Host ""
        
        if ($SystemInfo) {
            Write-Host "✓ Sistema: $($SystemInfo.ComputerName)" -ForegroundColor Green
            Write-Host "✓ SO: $($SystemInfo.OSName) $($SystemInfo.OSVersion)" -ForegroundColor Green
            Write-Host "✓ Uptime: $($SystemInfo.UptimeHours) horas" -ForegroundColor Green
            Write-Host "✓ Dominio/Grupo: $($SystemInfo.Domain)/$($SystemInfo.Workgroup)" -ForegroundColor Cyan
        }
        
        Write-Host "`n✓ Discos detectados: $($DiskInfo.Count)" -ForegroundColor Green
        foreach ($disk in $DiskInfo) {
            if ([double]$disk.SizeGB -gt 0) {
                Write-Host "  - $($disk.Disco): $($disk.SizeGB) GB ($($disk.PercentFree)% libre) [$($disk.Model)]" -ForegroundColor Cyan
            } else {
                Write-Host "  - $($disk.Disco): $($disk.Model) [$($disk.Tipo)]" -ForegroundColor Yellow
            }
        }
        
        if ($NetworkInfo -and $NetworkInfo.Interfaces) {
            Write-Host "`n✓ Interfaces detectadas: $($NetworkInfo.Interfaces.Count)" -ForegroundColor Green
            foreach ($interface in $NetworkInfo.Interfaces) {
                $statusColor = if ($interface.Status -eq "Up") { "Green" } else { "DarkGray" }
                Write-Host "  - $($interface.Name): $($interface.Status) ($($interface.Speed))" -ForegroundColor $statusColor
            }
            
            if ($NetworkInfo.IPAddresses -and $NetworkInfo.IPAddresses.Count -gt 0) {
                Write-Host "✓ Direcciones IP activas: $($NetworkInfo.IPAddresses -join ', ')" -ForegroundColor Cyan
            }
        }
        
        return $true
    }
    catch {
        Write-Log "Error generando reportes Fase 2: $_" -Level "ERROR"
        return $false
    }
}
#endregion

#region INICIO DEL SCRIPT PRINCIPAL
try {
    # Mostrar encabezado principal
    Write-Host "`n" + ("="*70) -ForegroundColor Green
    Write-Host "AUDITORÍA FINAL MAESTRA - INTEGRACIÓN COMPLETA" -ForegroundColor Green
    Write-Host "Versión: 2.0.1 (REPARADA) | Equipo: $ComputerName" -ForegroundColor Green
    Write-Host "="*70 -ForegroundColor Green
    Write-Host "Auditoría completa diseñada por victor 3,1416" -ForegroundColor DarkGray
    Write-Host "Fecha: $(Get-Date -Format 'dd/MM/yyyy') | Hora: $(Get-Date -Format 'HH:mm:ss')" -ForegroundColor DarkGray
    Write-Host "="*70 -ForegroundColor Green
    Write-Host ""
    
    # ✅ CORRECCIÓN: Definir fases con validación de existencia de funciones
    $phases = @(
        @{
            Name = "Fase 1"
            Function = { 
                if (Invoke-Fase1) {
                    Get-SystemAuditBasic
                } else {
                    $false
                }
            }
        }
        @{
            Name = "Fase 2"
            Function = { 
                # Verificar que la función existe
                if (Get-Command Invoke-Fase2 -ErrorAction SilentlyContinue) {
                    Invoke-Fase2
                } else {
                    Write-Log "⚠ Fase 2 no disponible (función no definida)" -Level "WARNING"
                    $true  # Continuar con las demás fases
                }
            }
        }
        @{
            Name = "Fase 3"
            Function = { 
                if (Get-Command Invoke-Fase3 -ErrorAction SilentlyContinue) {
                    Invoke-Fase3
                } else {
                    Write-Log "⚠ Fase 3 no disponible (función no definida)" -Level "WARNING"
                    $true
                }
            }
        }
        @{
            Name = "Fase 4"
            Function = { 
                if (Get-Command Invoke-Fase4 -ErrorAction SilentlyContinue) {
                    Invoke-Fase4
                } else {
                    Write-Log "⚠ Fase 4 no disponible (función no definida)" -Level "WARNING"
                    $true
                }
            }
        }
        @{
            Name = "Fase 5"
            Function = { 
                if (Get-Command Invoke-Fase5 -ErrorAction SilentlyContinue) {
                    Invoke-Fase5
                } else {
                    Write-Log "⚠ Fase 5 no disponible (función no definida)" -Level "WARNING"
                    $true
                }
            }
        }
    )
    
    $phaseResults = @{}
    $phaseNumber = 1
    
    foreach ($phase in $phases) {
        Write-Host "`n" + ("="*60) -ForegroundColor Cyan
        Write-Host "INICIANDO $($phase.Name.ToUpper())" -ForegroundColor Cyan
        Write-Host "="*60 -ForegroundColor Cyan
        
        try {
            # Ejecutar la fase
            $result = & $phase.Function
            $phaseResults[$phase.Name] = $result
            
            if ($result) {
                Write-Host "`n✅ $($phase.Name) COMPLETADA EXITOSAMENTE" -ForegroundColor Green
            } else {
                Write-Host "`n⚠️  $($phase.Name) COMPLETADA CON ADVERTENCIAS" -ForegroundColor Yellow
            }
        }
        catch {
            Write-Log "Error en $($phase.Name): $_" -Level "ERROR"
            Write-Host "`n❌ $($phase.Name) FALLÓ: $_" -ForegroundColor Red
            
            # Preguntar si continuar (solo si no es la última fase)
            if ($phaseNumber -lt $phases.Count) {
                Write-Host "`n¿Desea continuar con la siguiente fase? (S/N): " -ForegroundColor Yellow -NoNewline
                $response = Read-Host
                if ($response -notmatch '^[Ss]$') {
                    Write-Host "Auditoría interrumpida por el usuario." -ForegroundColor Red
                    break
                }
            }
        }
        
        $phaseNumber++
    }
    
    # Resumen final
    Write-Host "`n" + ("="*70) -ForegroundColor Green
    Write-Host "AUDITORÍA COMPLETADA" -ForegroundColor Green
    Write-Host "="*70 -ForegroundColor Green
    Write-Host ""
    
    # Mostrar estadísticas finales
    $successfulPhases = ($phaseResults.Values | Where-Object { $_ -eq $true }).Count
    $failedPhases = ($phaseResults.Values | Where-Object { $_ -eq $false }).Count
    
    Write-Host "📊 RESULTADOS FINALES:" -ForegroundColor Cyan
    Write-Host "   * Fases completadas exitosamente: $successfulPhases/$($phases.Count)" -ForegroundColor White
    Write-Host "   * Fases con advertencias/errores: $failedPhases/$($phases.Count)" -ForegroundColor White
    
    $totalDuration = [math]::Round(((Get-Date) - $scriptStartTime).TotalSeconds, 2)
    Write-Host "   * Duración total: $totalDuration segundos" -ForegroundColor White
    Write-Host ""
    
    Write-Host "📁 RESULTADOS GUARDADOS EN:" -ForegroundColor Cyan
    Write-Host "   * Carpeta principal: $OutputPath" -ForegroundColor White
    Write-Host "   * Archivo de log: $LogFile" -ForegroundColor White
    
    # Mostrar archivos generados si existen
    if (Test-Path $UnifiedJSON) {
        Write-Host "   * Reporte JSON: $UnifiedJSON" -ForegroundColor White
    }
    if (Test-Path $UnifiedCSV) {
        Write-Host "   * Reporte CSV: $UnifiedCSV" -ForegroundColor White
    }
    
    Write-Host "`n" + ("="*70) -ForegroundColor Green
    Write-Host "✅ AUDITORÍA FINALIZADA" -ForegroundColor Green
    Write-Host "="*70 -ForegroundColor Green
    
    Write-Log "=== FIN DE AUDITORÍA COMPLETA ===" -Level "SUCCESS"
    Write-Log "Duración total: $totalDuration segundos" -Level "INFO"
    
    # Pausar antes de finalizar para que el usuario pueda ver los resultados
    Write-Host "`nLa auditoría ha finalizado. El script se cerrará en 5 segundos..." -ForegroundColor Green
    Start-Sleep -Seconds 5
    
    exit 0
}
catch {
    Write-Log "Error crítico en el script principal: $_" -Level "ERROR"
    Write-Host "`n❌ ERROR CRÍTICO: $_" -ForegroundColor Red
    Write-Host "`n📄 Revisa el archivo de log para más detalles: $LogFile" -ForegroundColor Yellow
    
    Write-Host "`nLa auditoría ha finalizado. El script se cerrará en 5 segundos..." -ForegroundColor Green
    Start-Sleep -Seconds 5
    
    exit 1
}
finally {
    # Asegurar que el log se cierre correctamente
    if ($LogFile -and (Test-Path $LogFile)) {
        "=== Script finalizado a las $(Get-Date -Format 'HH:mm:ss') ===" | Out-File -FilePath $LogFile -Append -Encoding UTF8
    }
}
#endregion

# ============================================
# FIN DEL SCRIPT
# ============================================


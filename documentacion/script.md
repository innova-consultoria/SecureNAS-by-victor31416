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

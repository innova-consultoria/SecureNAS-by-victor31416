root@pve:/# ./SNAS-Auditoria-V2.2-Almacenamiento.sh
===============================================
    SNAS - AUDITORÍA DE ALMACENAMIENTO v2.2
           (Versión Profesional)
===============================================
🎯 Selecciona nivel de auditoría:
1) basic    - SMART + Info básica (5 min total)
2) standard - + Benchmarks rápidos (15 min total)
3) complete - + Tests completos (45 min total)

Tu elección [1-3]: 2
🔧 Verificando dependencias...
📦 Instalando paquetes faltantes: hdparm coreutils bc
Obj:1 http://deb.debian.org/debian bookworm InRelease
Obj:2 http://deb.debian.org/debian bookworm-updates InRelease
Obj:3 http://deb.debian.org/debian-security bookworm-security InRelease
Obj:4 http://repository.netdata.cloud/repos/edge/debian bookworm/ InRelease
Obj:5 http://download.proxmox.com/debian/pve bookworm InRelease
Obj:6 http://repository.netdata.cloud/repos/repoconfig/debian bookworm/ InRelease
Leyendo lista de paquetes... Hecho
Leyendo lista de paquetes... Hecho
Creando árbol de dependencias... Hecho
Leyendo la información de estado... Hecho
hdparm ya está en su versión más reciente (9.65+ds-1).
coreutils ya está en su versión más reciente (9.1-1).
bc ya está en su versión más reciente (1.07.1-3+b1).
0 actualizados, 0 nuevos se instalarán, 0 para eliminar y 0 no actualizados.
✅ Dependencias verificadas
🚀 Iniciando auditoría NIVEL 15
📀 Discos a auditar: 25
⏱️  Tiempo estimado: 15 min total
📄 Reportes: /var/log/snas/audit_almacenamiento_20251003_182558.log, /var/log/snas/audit_almacenamiento_20251003_182558.md, /var/log/snas/audit_almacenamiento_20251003_182558.json, /var/log/snas/audit_almacenamiento_20251003_182558.html
[Disco 🔍] [==                                                ] 4%
[Disco 🔍] 🚀 Nivel STANDARD - + Benchmarks
[Disco 🔍] 🚀 Nivel BÁSICO - SMART + Info
./SNAS-Auditoria-V2.2-Almacenamiento.sh: línea 163: SMART_CACHE[$disk]: variable sin asignar
lsblk: /dev/🔍: not a block device
lsblk: /dev/🔍: not a block device
./SNAS-Auditoria-V2.2-Almacenamiento.sh: línea 156: 🔍: error sintáctico: se esperaba un operando (el elemento de error es "🔍")
🧹 Limpiando archivos temporales...
root@pve:/# cat /var/log/snas/audit_almacenamiento_20251003_182558.log
SNAS AUDITORÍA DE ALMACENAMIENTO - vie 03 oct 2025 18:26:03 CEST
Nivel: 15
==========================================
Logs individuales por disco:
  - /var/log/snas/disk_🔍_20251003_182558.log
  - /var/log/snas/disk_Detectando_20251003_182558.log
  - /var/log/snas/disk_discos_20251003_182558.log
  - /var/log/snas/disk_físicos..._20251003_182558.log
  - /var/log/snas/disk_📀_20251003_182558.log
  - /var/log/snas/disk_Discos_20251003_182558.log
  - /var/log/snas/disk_detectados:_20251003_182558.log
  - /var/log/snas/disk_sda_20251003_182558.log
  - /var/log/snas/disk_sdb_20251003_182558.log
  - /var/log/snas/disk_sdc_20251003_182558.log
  - /var/log/snas/disk_sdd_20251003_182558.log
  - /var/log/snas/disk_zd0_20251003_182558.log
  - /var/log/snas/disk_zd16_20251003_182558.log
  - /var/log/snas/disk_⚠️_20251003_182558.log
  - /var/log/snas/disk_Discos_20251003_182558.log
  - /var/log/snas/disk_del_20251003_182558.log
  - /var/log/snas/disk_sistema:_20251003_182558.log
  - /var/log/snas/disk_├─pve-root_20251003_182558.log
  - /var/log/snas/disk_├─sdd_20251003_182558.log
  - /var/log/snas/disk_sda_20251003_182558.log
  - /var/log/snas/disk_sdb_20251003_182558.log
  - /var/log/snas/disk_sdc_20251003_182558.log
  - /var/log/snas/disk_sdd_20251003_182558.log
  - /var/log/snas/disk_zd0_20251003_182558.log
  - /var/log/snas/disk_zd16_20251003_182558.log

=== SISTEMAS DE ARCHIVOS AVANZADOS ===
🔍 Verificando pools ZFS...
NAME      SIZE  ALLOC   FREE    HEALTH
storage  10.9T   651G  10.3T    ONLINE
--- Detalles pools ---
  pool: storage
 state: ONLINE
  scan: resilvered 6.05G in 00:03:01 with 0 errors on Fri Oct  3 09:35:15 2025
config:

        NAME        STATE     READ WRITE CKSUM
        storage     ONLINE       0     0     0
          raidz1-0  ONLINE       0     0     0
            sda     ONLINE       0     0     0
            sdb     ONLINE       0     0     0
            sdc     ONLINE       0     0     0

errors: No known data errors

🔍 Verificando arrays RAID...
mdadm no disponible


==========================================
DISCO: 🔍
==========================================
[Disco 🔍] 🚀 Nivel STANDARD - + Benchmarks
[Disco 🔍] 🚀 Nivel BÁSICO - SMART + Info
root@pve:/#

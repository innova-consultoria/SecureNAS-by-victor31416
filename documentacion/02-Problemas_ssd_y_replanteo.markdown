# Resumen de Fases SNAS Realizadas y Pendientes

El plan SecureNAS-by-victor31416 se estructura en fases para construir una NAS segura con énfasis en la triada CIA (Confidencialidad, Integridad, Disponibilidad). Este informe resume el progreso hasta el 9 de octubre de 2025, abordando problemas con discos (ruido, velocidad SATA, bloqueos ZFS) y replanteando la configuración: WD Blue SA510 (500 GiB) para backups externos sincronizados con rclone/udev; Nextcloud en LXC con Office/Talk; ZFS con datasets tank/encrypted/nextcloud (3 TB), tank/encrypted/vms (1 TB, 200 GB por VM/LXC), tank/encrypted/backups (4 TB); VLANs (10 gestión, 20 servicios, 30 backups, 40 WireGuard); cifrado end-to-end (rclone crypt/Borg repokey); y auditorías/pruebas finales para experimentos multi-OS. Información sensible (IPs: 192.168.1.x, seriales: XXXXXXXX, UUIDs: UUID-REMOVIDO) anonimizada para GitHub.

## Bloque 0: Problemas con Discos SSD/HDD y Replanteamiento

Se identificaron y resolvieron problemas con los discos IronWolf 4TB (sda, sdb, sdc) y el pool ZFS, replanteando la configuración para optimizar seguridad y funcionalidad.

- ✅ Diagnóstico de ruido "tic, tic" (~8 segundos) en sda, bloqueos al importar pool ZFS storage, y velocidad SATA reducida (1.5 Gb/s en sda).
- ✅ Intercambio de cables SATA: cable original sda → sdc, sdb → sda, sdc → sdb, resolviendo velocidad a 6.0 Gb/s en todos.
- ✅ Verificación SMART: sda, sdb, sdc con PASSED, sin errores críticos.
- ✅ Identificación de sonido "cloc" (~5 segundos) en sdc, probablemente head parking normal (IronWolf CMR).
- ✅ Desactivación de ZFS import (systemctl disable zfs-import-cache/scan) y destrucción de pool storage.
- ✅ Backup completo en Seagate Ultra Touch 4TB para recuperación.
- ✅ Replanteamiento: pool ZFS con datasets (3 TB Nextcloud, 1 TB VMs/LXC, 4 TB backups), WD Blue SA510 para backups externos, Nextcloud en LXC con Office/Talk, VLANs asignadas, cifrado end-to-end.

**Pendientes**:
- Confirmar fuente del sonido "cloc" en sdc (físicamente) y reemplazar cable si persiste.
- Crear nuevo pool ZFS con distribución actualizada.

## Bloque 1: Fase 0 - Auditoría y Diagnóstico

Base técnica establecida mediante auditoría de hardware/software y preparación para hardening.

- ✅ Instalación limpia de Proxmox VE 9.0 en SSD Samsung 860 EVO 250 GB con LVM-thin (root 50 GB, thin pool 167 GB).
- ✅ Configuración manual de LVM-thin y resolución de errores de metadata.
- ✅ Configuración de locale es_ES.UTF-8 y eliminación de repositorios enterprise para community.
- ✅ Auditoría inicial de hardware (CPU, RAM, discos) y diagnóstico (ruido discos, ZFS).
- ✅ Backup completo en Seagate Ultra Touch 4TB.

**Pendientes**: Ninguno.

## Bloque 2: Fase 1 - Seguridad Base

Medidas iniciales de hardening para minimizar superficie de ataque y asegurar recuperación.

- ✅ Corrección de repositorios duplicados y actualización a pve-manager 9.0.10, zfsutils-linux 2.3.4-pve1.
- ✅ Unattended-upgrades para parches automáticos con eliminación de dependencias y reinicio nocturno.
- ✅ Swap ampliado a 8 GB y actualización de /etc/fstab con UUID nuevo.
- ✅ Desactivación de importación automática de ZFS y destrucción del pool storage.

**Pendientes**:
- Configurar usuarios no-root con 2FA.
- Hardening de SSH (cambiar puerto, claves, limitar root).
- Instalar OPNsense como cortafuegos (VLAN 10 para gestión).
- Configurar backups críticos y verificados (WD Blue SA510).

## Bloque 3: Fase 2 - Servicios Core

Despliegue de servicios esenciales para control de datos y acceso seguro.

**Pendientes**:
- AdGuard Home para DNS/DHCP local (VLAN 20).
- WireGuard para zero trust (VLAN 40, cifrado ChaCha20-Poly1305).
- Nextcloud en LXC (instalación limpia con Office/Talk, mover archivos manualmente a tank/encrypted/nextcloud, cifrado AES-256, VLAN 20).
- Netdata para monitorización básica.

## Bloque 4: Fase 3 - Servicios Avanzados

Funcionalidades extendidas con aislamiento para NAS completa.

**Pendientes**:
- Jellyfin para multimedia (usar Intel HD Graphics 530 para transcoding, VLAN 20).
- Home Assistant para domótica (VLAN 20).
- Logging centralizado con Grafana (VLAN 20).

## Bloque 5: Fase 4 - Optimización

Mejora de rendimiento y resiliencia con replicación.

**Pendientes**:
- Recrear pool ZFS: tank/encrypted/nextcloud (3 TB), tank/encrypted/vms (1 TB, 200 GB por VM/LXC), tank/encrypted/backups (4 TB).
- Optimizar ZFS (scrubs, backups externos en WD Blue SA510 via rclone con cifrado end-to-end, detección udev).
- Configurar replicación off-site (BorgBackup o rclone crypt).

## Bloque 6: Fase 5 - Monitorización y Mantenimiento

Vigilancia continua para detección temprana.

**Pendientes**:
- Netdata, Zabbix, Grafana para alertas (SMART, logs).
- Logwatch, Fail2ban para SSH/Proxmox.
- Scrubs ZFS, rotación de claves, tests de backups.

## Bloque 7: Pruebas de Auditoría y Finales

Auditoría para verificar seguridad/funcionalidad y pruebas para experimento controlado multi-OS.

**Pendientes**:
- **Auditoría**: Lynis system audit, ZFS checks (zpool status, zfs list), backups tests (borg check, rclone check), Netdata alertas.
- **Pruebas Finales**: Acceso multi-OS (Windows 11/Debian/Proxmox a backups en WD Blue SA510 via rclone/Samba/SFTP), cifrado end-to-end (rclone crypt para Nextcloud/backups), migración LXC/VM, rendimiento Jellyfin (transcoding CPU/Quick Sync), domótica Home Assistant, logging Grafana.
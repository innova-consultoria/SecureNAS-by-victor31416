# 🖥️ Instalación y Configuración de Proxmox VE - Proyecto SecureNAS

**Última actualización**: Octubre 2025  
**Auditoría ejecutada**: Instalación de Proxmox VE + Configuración Post-Problemas  
**Autor**: victor31416  
**Repositorio**: SecureNAS-by-victor31416  

## 📋 Objetivo

Instalar y configurar Proxmox VE 9.0 en un SSD Samsung 860 EVO 250 GB con LVM-thin personalizado para optimizar espacio para VMs/LXCs, estableciendo la base para el proyecto SecureNAS con énfasis en la triada CIA (Confidencialidad, Integridad, Disponibilidad).

## 🔧 Resumen de Acciones Realizadas

### Fase 1: Preparación e Instalación
- Descargada ISO oficial de Proxmox VE 9.0.
- Creado USB booteable con Ventoy.
- Configuradas particiones avanzadas:
  - Filesystem: ext4 (evita LVM automático).
  - Swap: 4 GB (inicial, luego ampliado).
  - Root: 50 GB (sistema Proxmox).
  - Max data: 1 GB (omite LVM-thin automático).
  - Min free: 8 GB (reserva para metadata).
- Configurado sistema base:
  - País: España.
  - Zona horaria: Madrid.
  - IP: 192.168.1.XX.
  - Contraseña root establecida.

### Fase 2: Configuración Post-Instalación
- Configurado LVM-thin manualmente:
  - Verificado espacio en Volume Group (pve, 176.88 GB).
  - Eliminados LVs automáticos si existían.
  - Creado thin pool data (167 GB, metadata 1 GB).
- Configurado en interfaz web:
  - Storage: local-lvm (thin pool data, contenido: discos VM/LXC).
- Ampliado swap a 8 GB y actualizado /etc/fstab con nuevo UUID.
- Configurado locale es_ES.UTF-8, eliminadas advertencias.
- Eliminados repositorios enterprise, añadido repositorio community (bookworm pve-no-subscription).
- Actualizado sistema a pve-manager/9.0.3 y zfsutils-linux 2.3.4-pve1.

### Fase 3: Diagnóstico y Resolución de Problemas
- Resuelto error LVM-thin automático con configuración manual.
- Corregidas advertencias de locale con es_ES.UTF-8.
- Eliminados repositorios enterprise duplicados.
- Diagnosticado ruido "tic, tic" (~8 segundos) en sda (XXXXXXXX), velocidad SATA 1.5 Gb/s.
- Intercambiados cables SATA (sda → sdc, sdb → sda, sdc → sdb), corregida velocidad a 6.0 Gb/s.
- Identificado ruido "cloc" (~5 segundos) en sdc (XXXXXXXX), probable head parking.
- Backup completo realizado previamente en Seagate Ultra Touch 4TB.
- Desactivada importación automática ZFS y destruido pool storage para estabilidad.


## 💾 Estructura Final del Almacenamiento

**SSD Samsung 860 EVO 250 GB**:
- sda1: EFI (1 GB).
- sda2: /boot/efi (1 GB).
- sda3: LVM Physical Volume (231.9 GB).
  - pve-root: 50 GB (ext4, sistema Proxmox).
  - pve-swap: 8 GB (ampliado).
  - pve/data: 167 GB (LVM-thin pool para VMs/LXC).

**Características LVM-thin**:
- Thin provisioning para asignación dinámica.
- Snapshots rápidos para backups/clones.
- Over-provisioning permite VMs >167 GB.
- Eficiencia en uso del espacio SSD.

**Discos IronWolf 4TB (sda, sdb, sdc)**:
- SMART PASSED, velocidad 6.0 Gb/s, pendiente cable sdc.
- Pool ZFS destruido, pendiente recreación con datasets:
  - nas/nc: 4 TB y (200 GB por VM/LXC).
  - nas/bkp: 3 TB.
  - nas/comun: 110 GB.

**WD Blue SA510 500 GiB**:
- Dedicado a backups externos (rclone con cifrado end-to-end, detección udev).
- Se cifra desde Debian y se coloca en equipo local 192.168.1.XXX con Windows 10 Pro.
- Sincronizará la/s imagen/es Clonezilla y Snapshot del sistema en ese SSD externo.

## ✅ Estado Final del Sistema

- **Verificaciones**:
  - Versión Proxmox: pve-manager/9.0.3 sin advertencias.
  - Locale: es_ES.UTF-8 en todos los LC_*.
  - Almacenamiento: LVM-thin data (167 GB) configurado.
  - Acceso web: https://192.168.1.x:8006 funcional.
  - Swap: 8 GB activo, UUID actualizado.
  - Discos IronWolf: SMART PASSED, velocidad 6.0 Gb/s.
  - Backup: Completo en Seagate Ultra Touch 4TB.
- **Problemas resueltos**:
  - Ruido "cloc" en sdc (probable head parking, verificado físicamente cables Sata III cambiados).
  - Error vmbr0 en arranque (requiere Ctrl+D). Solventado con carga correcta de zpool.

## 🧠 Observaciones Técnicas

- Proxmox VE 9.0 estable en SSD Samsung 860 EVO 250 GB, con LVM-thin optimizado para VMs/LXCs.
- Discos IronWolf 4TB (sda, sdb, sdc) operativos tras corrección de velocidad SATA (1.5 Gb/s a 6.0 Gb/s) mediante intercambio de cables. Ruido "cloc" (~5 segundos) en sdc (XXXXXXXX) probablemente normal, pero el cable se reemplaza.
- Pool ZFS destruido para resolver bloqueos, backup asegura recuperación.
- WD Blue SA510 500 GiB configurado para backups externos con cifrado (rclone crypt), accesible desde Windows 11/Debian/Proxmox via Samba/SFTP.
- Red estable (1 Gbps), pero error vmbr0 requiere diagnóstico.
- Swap ampliado a 8 GB soporta VMs/LXCs (Nextcloud, Jellyfin, etc.).
- VLANs planificadas: 10 (gestión), 20 (servicios: Nextcloud, AdGuard), 30 (backups), 40 (WireGuard).

## 🧩 Recomendaciones

- Recrear pool ZFS con datasets: nas/nc (4 TB), nas/bkp (3 TB), nas/comun (110 GB).
- Configurar backups automáticos de Proxmox en WD Blue SA510 (rclone con cifrado, detección udev).
- Proceder con Fase 1 (hardening: usuarios no-root, SSH, OPNsense).
- Mantener monitoreo SMART activo hasta configuración final del pool ZFS.

## 📋 Pruebas de Auditoría y Finales

- **Auditoría**:
  - Ejecutar Lynis para auditoría del sistema.
  - Verificar estado ZFS (zpool status, zfs list).
  - Comprobar integridad de backups (rclone check, borg check).
  - Configurar alertas Netdata para SMART, CPU, RAM.

- **Pruebas Finales**:
  - Acceso multi-OS a backups en WD Blue SA510 (Windows 11/Debian/Proxmox via rclone/Samba/SFTP).
  - Verificar cifrado end-to-end (rclone crypt para Nextcloud/backups).
  - Migración de LXC/VM en Proxmox.
  - Rendimiento de Jellyfin (transcoding con Intel HD Graphics 530).
  - Funcionalidad de Home Assistant y logging Grafana.

## 🚀 Próximos Pasos Recomendados

- **Inmediatos**:
  - Crear pool ZFS con datasets propuestos.
  - Configurar primera LXC para Nextcloud (instalación limpia, NextCloud con Office/Talk/etc).

- **Configuración ZFS Sugerida**:
  - Pool: RAIDZ1 con sda, sdb, sdc.
  - Datasets: nas/nc (4 TB), nas/bkp (3 TB), nas/comun (110 GB).
  - Propiedades: compression=lz4, atime=off, encryption=aes-256-gcm.

Este documento forma parte del módulo técnico de instalación del proyecto SecureNAS.  
Para más información, consulta el repositorio principal en github.com/innova-consultoria/SecureNAS-by-victor31416.

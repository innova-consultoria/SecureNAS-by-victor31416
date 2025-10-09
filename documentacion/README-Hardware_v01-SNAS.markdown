# 🖥️ Estado Actual del Sistema - Proyecto SecureNAS

**Última actualización**: Octubre 2025  
**Auditoría ejecutada**: Migración a Proxmox VE + Diagnóstico Hardware Post-Problemas  
**Autor**: victor31416  
**Repositorio**: SecureNAS-by-victor31416  

## 📋 Resumen técnico del equipo físico

| Componente          | Estado actual                              | Observación técnica                              |
|---------------------|--------------------------------------------|-------------------------------------------------|
| Plataforma          | ASRock H370M-ITX/ac + Intel i7-6700        | Host base para Proxmox VE, estable               |
| RAM instalada       | 2×8 GB DDR4 (16 GB reconocidos)            | Ambos módulos activos, suficiente para VMs/LXCs  |
| Discos IronWolf     | sda, sdb, sdc → ST4000VN006-3CW104        | 4 TB cada uno, SMART PASSED, pendiente cable sdc |
| SSD Sistema         | ✅ Samsung 860 EVO 250 GB SATA III          | Sistema operativo Proxmox VE, operativo          |
| SSD Backup Externo  | WD Blue SA510 500 GiB                      | Dedicado a backups externos, sincronización rclone |
| Swap                | 8 GB asignado, uso monitorizado            | Ajustado para virtualización                    |
| Virtualización      | Proxmox VE 9.0 instalado                   | Hipervisor base instalado                       |
| Red                 | 1 Gbps estable, vmbr0                      | Error vmbr0 en arranque, resuelto con Ctrl+D    |
| Monitorización      | Netdata pendiente                          | Integración planificada en Fase 2               |
| ZFS / RAID          | ❌ Pool destruido                          | Pendiente recreación con datasets optimizados   |

## 🔄 Comparativa de estado (antes vs. ahora)

| Componente          | Estado anterior                            | Estado actual                              |
|---------------------|--------------------------------------------|--------------------------------------------|
| Sistema Operativo   | Debian bare-metal                          | ✅ Proxmox VE 9.0 instalado                |
| SSD Sistema         | Samsung 860 EVO 250 GB operativo           | ✅ Samsung 860 EVO 250 GB operativo         |
| Cables SATA         | Problema en sda (1.5 Gb/s, ruido "tic, tic") | ⚠️ Todos a 6.0 Gb/s, ruido "cloc" en sdc   |
| Almacenamiento      | Pool ZFS storage (RAIDZ1)                  | ❌ Pool destruido, pendiente recreación    |
| Arquitectura        | Servicios directos sobre SO                | ⏳ Fase 0 completada, Fase 1 en progreso   |
| Swap                | 4 GB asignado                              | ✅ 8 GB asignado para virtualización       |

## 🧠 Observaciones técnicas

- Sistema con **Proxmox VE 9.0** instalado como hipervisor base en SSD Samsung 860 EVO 250 GB (LVM-thin: root 50 GB, thin pool 167 GB).
- **Discos IronWolf 4TB** (sda, sdb, sdc) operativos con SMART PASSED, velocidad SATA corregida a 6.0 Gb/s tras intercambio de cables. Ruido "tic, tic" (~8 segundos) en sda resuelto; ruido "cloc" (~5 segundos) en sdc (probable head parking normal, pendiente confirmación física).
- **Pool ZFS destruido** tras bloqueos en importación, asegurando estabilidad. Backup completo en Seagate Ultra Touch 4TB garantiza recuperación.
- **WD Blue SA510 500 GiB** dedicado a backups externos, sincronizados via rclone con cifrado end-to-end, detectado por udev para experimentos multi-OS (Windows 11, Debian, Proxmox).
- **Red** estable (1 Gbps, 192.168.1.x), pero error vmbr0 en arranque requiere Ctrl+D (pendiente diagnóstico).
- **Swap** ampliado a 8 GB, optimizado para soportar VMs/LXCs (Nextcloud, Jellyfin, etc.).
- **Replanteamiento**: Nuevo pool ZFS con datasets tank/encrypted/nextcloud (3 TB), tank/encrypted/vms (1 TB, 200 GB por VM/LXC), tank/encrypted/backups (4 TB). VLANs asignadas: 10 (gestión), 20 (servicios), 30 (backups), 40 (WireGuard).

## 🧩 Recomendaciones

- Confirmar físicamente el ruido "cloc" en sdc (XXXXXXXX) y reemplazar su cable SATA III si persiste.
- Adquirir cable SATA III de alta calidad (6 Gb/s, clips de seguridad) para sdc.
- Recrear pool ZFS con datasets optimizados: tank/encrypted/nextcloud (3 TB), tank/encrypted/vms (1 TB), tank/encrypted/backups (4 TB).
- Configurar backups automáticos de Proxmox en WD Blue SA510 (rclone con cifrado, udev para detección).
- Diagnosticar y resolver error vmbr0 en arranque.
- Proceder con Fase 1 (hardening: usuarios no-root, SSH, OPNsense) tras resolver cable sdc.
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

Este documento forma parte del módulo técnico de seguimiento del proyecto SecureNAS.  
Para más información, consulta el repositorio principal en github.com/innova-consultoria/SecureNAS-by-victor31416.
# SecureNAS: El Servidor NAS más Seguro de Código Abierto
¡Tus datos, tu territorio!

![Estado](https://img.shields.io/badge/estado-en%20desarrollo-yellow) ![Colaboraciones](https://img.shields.io/badge/colaboraciones-abiertas-green) ![Licencia](https://img.shields.io/badge/licencia-GPL--3.0-blue) 


**Proyecto creado por Innova Consultoría (Madrid) con la colaboración de victor31416.**  
Repositorio: [https://github.com/innova-consultoria/SecureNAS-by-victor31416](https://github.com/innova-consultoria/SecureNAS-by-victor31416)

## Descripción

SecureNAS es un servidor NAS profesional basado en hardware de más de 15 años y software 100% open-source, diseñado para tener la máxima seguridad, total privacidad y control de los datos sin dependender de nadie. Entre otras aspectos, implementa zero trust (solo WireGuard expuesto), cifrado AES-256, aislamiento de servicios (LXCs, VLANs) y backups 3-2-1. Y otro de los aspectos imprescindibles es que fuera compatible con Linux (cualquier distribución), Windows, macOS, Android e iOS. SNAS, ser dueñ@ de tu propio cielo.

## Características Principales de Diseño

- **Hipervisor**: Proxmox VE (Debian-based, GPL).
- **Almacenamiento**: SSD Samsung EVO 250 GB (sistema), ZFS RAIDZ1 (3x 4TB HDD Seagate IronWolf, cifrado AES-256), WD SSD 500 GB cifrado AES-256 en Windows 10 Pro (como bkp respaldo)
- **VPN**: WireGuard (UDP 51820, zero trust).
- **Servicios**: Nextcloud (almacenamiento, ofimatica, videollamada, calendario, nube compartida..., sync, 2FA, CSP), AdGuard Home (DNS/DHCP).
- **Backups**: 3-2-1 con BorgBackup, Rclone, Clonezilla, ZFS snapshots, sync a WD SSD 500 GB en Windows 10 Pro.
- **Hardware**: Intel Core i7-6700, 16 GB RAM, SSD Samsung EVO 250 GB (sistema).
- **Red**: Gestión SSH en 192.168.1.XX, dominio XX.esimportante.es (DDNS No-IP).

## Plan Estratégico
SecureNAS se implementa en 5 fases + auditoría inicial, detalladas en [documentacion/00-Plan_SNAS.markdown](documentacion/00-Plan_SNAS.markdown):
- **Fase 0: Auditoría** - Diagnóstico hardware/software (`smartctl`, `zpool status`).
- **Fase 1: Seguridad Base** - Firewall (iptables), SSH, WireGuard.
- **Fase 2: Servicios Core** - Nextcloud, AdGuard Home.
- **Fase 3: Servicios Avanzados** - Opcionales (e.g., Jellyfin, Home Assistant).
- **Fase 4: Optimización** - Rendimiento ZFS, backups off-site.
- **Fase 5: Monitorización** - Netdata, Grafana.
- 
## Estructura del Repositorio

- `docs/`: Guías, tarjetas técnicas (fases, comandos), auditorías hardware.
- `scripts/`: Bash para auditorías (SMART) y backups (cron).
- `configs/`: Ejemplos YAML/INI (WireGuard, iptables).
- `diagrams/`: Diagramas de red (PlantUML/ASCII).

## Equipo utilizado (2008)

- **Hardware**: 
  - CPU: Intel Core i7-6700 (4 cores/8 threads).
  - RAM: 16 GB (aplicados 4 GB para Nextcloud LXC).
  - Discos: 3x 4TB HDD (RAIDZ1), SSD Samsung 250 GB (sistema), WD 500 GB (backups).
  - Red: Bridge vmbr0, VLAN-aware, IP 192.168.1.XX.
- **Software**: Proxmox VE 9, Debian 12/13 LXCs, herramientas GPL (WireGuard, Nextcloud, BorgBackup).

## Guía de Instalación (Resumen)

1. **Fase 1: Proxmox y ZFS**
   - Actualizar: `apt update && apt full-upgrade -y`.
   - Verificar ZFS: `zpool status tank`.
   - Detalles: [docs/Tarjeta-ZFS.md](docs/Tarjeta-ZFS.md).

2. **Fase 2: WireGuard**
   - Configurar: `wg-quick up wg0` en LXC.
   - Detalles: [docs/Tarjeta-WireGuard.md](docs/Tarjeta-WireGuard.md).

3. **Fase 3: Nextcloud y SSL**
   - Instalar Certbot: `certbot --apache -d live.esimportante.es`.
   - Detalles: [docs/Tarjeta-Nextcloud.md](docs/Tarjeta-Nextcloud.md).

4. **Fase 4: Backups**
   - Configurar Borg: `borg init --encryption=repokey /mnt/tank/backups/repo`.
   - Detalles: [docs/Tarjeta-Backups.md](docs/Tarjeta-Backups.md).

## Auditorías Hardware

| Disco | Modelo | Cambio | SMART Antes | SMART Después | Notas |
|-------|--------|--------|-------------|---------------|-------|
| HDD1 (sda) | Seagate IronWolf 4TB | 15/10/2025 | Fallo: No responde | OK: 100% salud | Reemplazados cables Sata III |
| SSD Sistema | Kingston 120 GB → Samsung EVO 250 GB | 18/10/2025 | Kingston 20% vida útil | Samsung OK: 98% salud | Mejora fiabilidad con EVO 250 |
| SSD Backups | WD 500 GB | Sin cambios | OK: 95% salud | Ubicado en PC local con Windows 10 Pro | Sync /nas/bkp/ a /mnt/pve_bkp/ |

Ver [docs/Auditorias-Hardware.md](docs/Auditorias-Hardware.md) para detalles (`smartctl -a /dev/sdX`, FIO OK).

## Contribución

- **Roles**: victor31416 (admin), Innova Consultoría (soporte: innova.satmadrid@gmail.com).
- Crear issues/PRs siguiendo [CONTRIBUTING.md](CONTRIBUTING.md).
- Reportar bugs o sugerencias en issues con etiqueta "bug" o "feature".

## Licencia

Este proyecto está licenciado bajo [GPL-3.0](LICENSE.md).

## Contacto

- Email: innova.satmadrid@gmail.com
- Issues: [https://github.com/innova-consultoria/SecureNAS-by-victor31416/issues](https://github.com/innova-consultoria/SecureNAS-by-victor31416/issues)
  🩹 XX = Números o caracteres ocultos por privacidad o seguridad.

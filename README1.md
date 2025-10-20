# SecureNAS: Servidor NAS Seguro de Código Abierto

![Estado](https://img.shields.io/badge/estado-en%20desarrollo-yellow) ![Licencia](https://img.shields.io/badge/licencia-GPL--3.0-blue)

**Proyecto creado por Innova Consultoría (Madrid) con la colaboración de victor31416.**  
Repositorio: [https://github.com/innova-consultoria/SecureNAS-by-victor31416](https://github.com/innova-consultoria/SecureNAS-by-victor31416)

## Descripción

SecureNAS es un servidor NAS profesional basado en software 100% open-source, diseñado para máxima seguridad, privacidad y control de datos. Implementa zero trust (solo WireGuard expuesto), cifrado AES-256, aislamiento de servicios (LXCs, VLANs) y backups 3-2-1. Compatible con Windows, macOS, Android, iOS.

## Características Principales

- **Hipervisor**: Proxmox VE (Debian-based, GPL).
- **Almacenamiento**: ZFS RAIDZ1 (3x 4TB HDD Seagate IronWolf, cifrado AES-256).
- **VPN**: WireGuard (UDP 51820, zero trust).
- **Servicios**: Nextcloud (almacenamiento, sync, 2FA, CSP), AdGuard Home (DNS/DHCP).
- **Backups**: 3-2-1 con BorgBackup, Rclone, ZFS snapshots, sync a WD SSD 500 GB.
- **Hardware**: Intel Core i7-6700, 16 GB RAM, SSD Samsung EVO 250 GB (sistema).
- **Red**: Gestión SSH en 192.168.1.76, dominio live.esimportante.es (DDNS No-IP).

## Estructura del Repositorio

- `docs/`: Guías, tarjetas técnicas (fases, comandos), auditorías hardware.
- `scripts/`: Bash para auditorías (SMART) y backups (cron).
- `configs/`: Ejemplos YAML/INI (WireGuard, iptables).
- `diagrams/`: Diagramas de red (PlantUML/ASCII).

## Requisitos

- **Hardware**: 
  - CPU: Intel Core i7-6700 (4 cores/8 threads).
  - RAM: 16 GB (recomendado 4 GB para Nextcloud LXC).
  - Discos: 3x 4TB HDD (RAIDZ1), SSD Samsung 250 GB (sistema), WD 500 GB (backups).
  - Red: Bridge vmbr0, VLAN-aware, IP 192.168.1.76.
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
| HDD1 (sda) | Seagate IronWolf 4TB | 15/10/2025 | Fallo: No responde | OK: 100% salud | Reemplazado |
| SSD Sistema | Kingston 120 GB → Samsung EVO 250 GB | 18/10/2025 | 20% vida útil | OK: 98% salud | Mejora fiabilidad |
| SSD Backups | WD 500 GB | Sin cambio | OK: 95% salud | N/A | Sync /nas/bkp/ a /mnt/pve_bkp/ |

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

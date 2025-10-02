# SecureNAS-by-victor31416
**Secure Network Attached Storage (SNAS)** es un proyecto técnico y estratégico orientado a construir una infraestructura NAS segura, resistente y escalable, basada en tecnologías libres y estándares profesionales.

---

## 📚 Tabla de Contenido

- [🎯 Objetivos del Proyecto](#-objetivos-del-proyecto)
- [🧰 Inventario Técnico Actual](#-inventario-técnico-actual)
- [🔍 Estado Actual del Sistema](#-estado-actual-del-sistema)
- [🧱 Planificación por Fases](#-planificación-por-fases)
- [👥 Roles de Colaboración](#-roles-de-colaboración)
- [🧪 Tarjetas Técnicas](#-tarjetas-técnicas)
- [📁 Estructura del Repositorio](#-estructura-del-repositorio)
- [🚀 Guía para Contribuir](#-guía-para-contribuir)
- [📎 Documentación Asociada](#-documentación-asociada)

---

## 🎯 Objetivos del Proyecto

- Implementar un NAS seguro con ZFS y cifrado
- Integrar servicios críticos: cortafuegos, multimedia, DNS filtrado, backup, domótica
- Aplicar la Triada CIA: Confidencialidad, Integridad, Accesibilidad
- Diseñar una arquitectura virtualizada con Proxmox
- Documentar y automatizar mantenimiento, monitorización y recuperación

---

## 🧰 Inventario Técnico Actual

| Componente         | Especificación                        | Estado     |
|--------------------|----------------------------------------|------------|
| CPU                | Intel Core i7-6700 (8 hilos, VT-x)     | ✅ Operativo |
| RAM                | 8 GB DDR4 Kingston @2133MT/s           | ⚠️ Incompleto (plan: 16 GB) |
| Discos IronWolf    | 3x 4TB (ZFS RAID-Z1)                   | ⚠️ sda fallido, sdb/sdc OK |
| SSD Kingston       | 120 GB (Proxmox)                       | ⚠️ 3 % vida útil restante |
| Disco Backup       | Emtec 960 GB                           | ❓ No detectado en auditoría |
| Placa Base         | MSI B150M PRO-VDH                      | ✅ Operativa |
| Red                | 1Gbps LAN                              | ✅ Estable |
| Sistema Operativo  | Debian 12 + Proxmox VE                 | ✅ Actualizado |
| Servicios detectados | Netdata, Nextcloud, ZFS              | ✅ Instalados |

---

## 🔍 Estado Actual del Sistema

- `smartctl` confirma errores críticos en disco sda (no responde)
- SSD Kingston muestra 19 sectores reasignados y 7084 errores ATA
- ZFS pool `storage` montado con datasets (`iso`, `backup`, `images`, etc.)
- `/var` ocupa 9,3 GB, con archivos ISO y logs pesados
- 744 paquetes instalados, incluyendo Proxmox, ZFS, SSH, Netdata
- Servicios como Nextcloud y Netdata detectados, pero no auditados en ejecución
- No se confirma conexión del disco Emtec ni estado de VLANs o cortafuegos

---

## 🧱 Planificación por Fases

### Fase 0: Auditoría y Diagnóstico
- ✅ Script ejecutado (`SNAS-Auditoria-Completa-v2.sh`)
- ✅ Estado de discos, RAM, CPU, ZFS, servicios
- ⚠️ Requiere reemplazo de sda y SSD Kingston

### Fase 1: Seguridad Base
- Cortafuegos OPNsense
- Cambio puertos SSH/Web
- Backup crítico y verificado

### Fase 2: Servicios Core
- AdGuard Home (DNS)
- VPN WireGuard
- Nextcloud hardening
- Monitorización Netdata + alertas

### Fase 3: Servicios Avanzados
- Jellyfin/Plex
- Home Assistant
- Logging centralizado + Grafana

### Fase 4: Optimización
- Rendimiento ZFS
- Replicación off-site
- Auditoría final de seguridad

### Fase 5: Monitorización y Mantenimiento
- Netdata, Zabbix, Grafana, Logwatch, Fail2ban
- Scrubs ZFS, rotación claves, test backups

---

## 👥 Roles de Colaboración

| Rol                        | Descripción |
|----------------------------|-------------|
| **Administrador Principal** | victor31416 — control técnico y estratégico |
| **Backup Admin**           | Gestión de respaldos y restauración |
| **Seguridad y Cortafuegos**| Configuración OPNsense, políticas de acceso |
| **Monitorización y Alertas**| Stack Netdata, Zabbix, Grafana |
| **Documentación y Procedimientos**| Manuales, checklists, diagramas |

---

## 🧪 Tarjetas Técnicas

### 🔧 Diagnóstico de discos
```bash
smartctl -a /dev/sda
zpool status
zpool scrub storage

🔐 Seguridad básica
bash
ufw status
systemctl list-units --failed
grep 'NOPASSWD' /etc/sudoers*

📦 Auditoría de paquetes
bash
dpkg -l | wc -l
apt list --upgradable
📡 Monitorización
bash
systemctl status netdata
curl http://localhost:19999

🧱 ZFS y almacenamiento
bash
zfs list
zfs get all storage
df -hT

📁 Estructura del Repositorio
Código
SecureNAS-by-victor31416/
├── README.md
├── /docs
├── /scripts
├── /configs
├── /checklists
├── /backups
└── /images

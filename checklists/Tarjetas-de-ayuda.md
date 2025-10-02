🧪 Tarjetas de ayuda — Proyecto SNAS
Guía rápida de comandos técnicos organizados por función. Cada tarjeta incluye una descripción, etiquetas, comandos útiles y espacio para documentación visual.

🔧 Diagnóstico de discos
Soluciona: Verifica el estado físico y lógico de los discos duros y SSD. Detecta errores SMART, sectores defectuosos y estado del pool ZFS.
🏷️ Etiquetas: discos, smartctl, zfs, almacenamiento, diagnóstico
📸 Captura sugerida: images/diagnostico-discos.png
📄 Información técnica que ofrece:
Estado SMART de cada disco
Errores ATA, sectores reasignados
Estado del pool ZFS (status, scrub)
💻 Comandos:
bash
smartctl -a /dev/sda
zpool status
zpool scrub storage


🔐 Seguridad básica
Soluciona: Detecta configuraciones inseguras como servicios fallidos, sudo sin contraseña, puertos abiertos.
🏷️ Etiquetas: seguridad, sudo, servicios, firewall, usuarios
📸 Captura sugerida: images/seguridad-basica.png
📄 Información técnica que ofrece:
Servicios fallidos
Usuarios con privilegios inseguros
Estado del cortafuegos
💻 Comandos:
bash
ufw status
systemctl list-units --failed
grep 'NOPASSWD' /etc/sudoers*


📦 Auditoría de paquetes
Soluciona: Evalúa el estado de los paquetes instalados y pendientes de actualización.
🏷️ Etiquetas: paquetes, apt, dpkg, actualizaciones
📸 Captura sugerida: images/auditoria-paquetes.png
📄 Información técnica que ofrece:
Número total de paquetes
Paquetes críticos
Actualizaciones disponibles
💻 Comandos:
bash
dpkg -l | wc -l
apt list --upgradable


📡 Monitorización
Soluciona: Verifica si los agentes de monitorización están activos y accesibles.
🏷️ Etiquetas: netdata, zabbix, grafana, monitorización, estado
📸 Captura sugerida: images/monitorizacion.png
📄 Información técnica que ofrece:
Estado de Netdata
Acceso local a métricas
Estado de otros agentes
💻 Comandos:
bash
systemctl status netdata
curl http://localhost:19999


🧱 ZFS y almacenamiento
Soluciona: Muestra el estado de los datasets, uso de espacio y propiedades del sistema de archivos.
🏷️ Etiquetas: zfs, almacenamiento, datasets, espacio, volúmenes
📸 Captura sugerida: images/zfs-almacenamiento.png
📄 Información técnica que ofrece:
Listado de datasets
Propiedades ZFS
Uso de espacio por sistema de archivos
💻 Comandos:
bash
zfs list
zfs get all storage
df -hT


🛡️ Cortafuegos y puertos
Soluciona: Detecta servicios expuestos, reglas activas y puertos abiertos.
🏷️ Etiquetas: iptables, nftables, puertos, nmap, ss
📸 Captura sugerida: images/cortafuegos-puertos.png
📄 Información técnica que ofrece:
Reglas de firewall
Puertos abiertos
Servicios escuchando
💻 Comandos:
bash
iptables -L -n
nft list ruleset
ss -tuln
nmap -sT -O localhost


🧬 Virtualización y contenedores
Soluciona: Muestra el tipo de virtualización, máquinas virtuales activas y contenedores en ejecución.
🏷️ Etiquetas: proxmox, kvm, docker, lxc, kubernetes
📸 Captura sugerida: images/virtualizacion.png
📄 Información técnica que ofrece:
Tipo de hipervisor
VMs activas
Contenedores Docker, LXC, Kubernetes
💻 Comandos:
bash
systemd-detect-virt
virsh list --all
docker ps -a
lxc list
kubectl get pods -A


🧾 Usuarios y permisos
Soluciona: Detecta cuentas inseguras, duplicadas o sin contraseña.
🏷️ Etiquetas: usuarios, permisos, uid, shadow, passwd
📸 Captura sugerida: images/usuarios-permisos.png
📄 Información técnica que ofrece:
Cuentas sin contraseña
Usuarios con UID 0
Shells inválidos
💻 Comandos:
bash
getent passwd
getent shadow | awk -F: '($2 == "") { print $1 }'
getent passwd | awk -F: '($3 == 0) { print $1 }'


📁 Backup y restauración
Soluciona: Verifica el estado de los backups, snapshots y cron jobs de respaldo.
🏷️ Etiquetas: backup, restic, borg, zfs, cron
📸 Captura sugerida: images/backup.png
📄 Información técnica que ofrece:
Snapshots ZFS
Backups activos
Cron jobs de respaldo
💻 Comandos:
bash
restic snapshots
borg list /mnt/backup
zfs list -t snapshot
crontab -l | grep backup


🔍 Logs y errores
Soluciona: Muestra errores recientes del sistema, accesos fallidos y eventos críticos.
🏷️ Etiquetas: logs, syslog, auth.log, journalctl, errores
📸 Captura sugerida: images/logs-errores.png
📄 Información técnica que ofrece:
Últimos errores del sistema
Fallos de autenticación
Eventos críticos recientes
💻 Comandos:
bash
tail -n 50 /var/log/syslog
grep -i "error\|fail\|denied" /var/log/auth.log
journalctl -p 3 -xb


# 000 - Información del Sistema Completo.

---

## 📋 Tabla de Contenidos
- [🚀 Resumen y objetivo](#-resumen-y-objetivo)
- [💻 Información básica del host](#-información-básica-del-host)
- [🔧 Discos, ZFS y montajes (estado real)](#-discos-zfs-y-montajes-estado-real)
- [🌐 Samba y usuarios configurados](#-samba-y-usuarios-configurados)
- [✅ Almacenamientos en Proxmox (configuración)](#-almacenamientos-en-proxmox-configuración)
- [🛠 Comandos clave y salidas relevantes](#-comandos-clave-y-salidas-relevantes)
- [🔒 Consideraciones de seguridad y buenas prácticas](#-consideraciones-de-seguridad-y-buenas-prácticas)
- [📝 Notas Importantes](#-notas-importantes)

---

## 🚀 Resumen y objetivo

**Propósito:** Consolidar la información real y verificada del servidor Proxmox `pve` tras la reconfiguración completa: instalación directa de Proxmox VE, creación y verificación de pools ZFS (`nas`, `backup`), particionado y formateo de `sdd` (ext4 + ZFS), montaje de `/mnt/samba1tb`, configuración de Samba multiusuario (carpetas privadas + carpeta común) y la integración de los almacenamientos en Proxmox.

**Resultado esperado:** Documento técnico listo para auditoría y referencia operativa, con comandos reproducibles y estado actual del sistema.

---

## 💻 Información básica del host

- **Hostname:** `pve`  
- **IP de gestión:** `192.168.1.100`  
- **Interfaz web Proxmox:** `https://192.168.1.100:8006`  
- **Versión Proxmox VE:** `9.0.3`  
- **Kernel:** `6.14.8-2-pve`  
- **Acceso SSH:** habilitado (usuario `root`)  

**Comandos de verificación recomendados:**

```bash
uname -a
pveversion -v
ip a show
```
## 🔧 Discos, ZFS y montajes (estado real)
Discos físicos y asignación actual
Disco	FSTYPE / Rol	Punto de montaje / Uso
sda	zfs_member	miembro del pool nas (mirror)
sdb	zfs_member	miembro del pool nas (mirror)
sdc	SSD (sistema)	Proxmox + local-lvm (LVM thin)
sdd1	ext4	montado en /mnt/samba1tb (Samba)
sdd2	zfs_member	miembro del pool backup
sde..sdh	0B / no usados	sin uso detectado
Pools ZFS

    Pool nas

        Estado: ONLINE

        Composición: mirror (sda, sdb)

        Mountpoint: /nas

        Uso: datasets para VMs/CTs (configurado en Proxmox)

    Pool backup

        Estado: ONLINE

        Composición: sdd2 (disco único)

        Mountpoint: /backup

        Uso: almacenamiento secundario / copias

Volumen ext4 para Samba

    Partición: /dev/sdd1

    Sistema de archivos: ext4

    Punto de montaje: /mnt/samba1tb

    Uso: carpeta compartida Samba (carpetas privadas + carpeta común)

## 🌐 Samba y usuarios configurados
Usuarios del sistema y Samba

    victor (usuario principal)

    rorri

    helena

    admin

    root (sistema)

Todos los usuarios anteriores tienen cuenta de sistema y se añadieron a Samba con smbpasswd -a.
Estructura de carpetas en /mnt/samba1tb
text

/mnt/samba1tb/comun
/mnt/samba1tb/privado_victor
/mnt/samba1tb/privado_rorri
/mnt/samba1tb/privado_helena
/mnt/samba1tb/privado_admin

Permisos aplicados (Unix)
bash
```bash
chown victor:victor /mnt/samba1tb/privado_victor
chown rorri:rorri /mnt/samba1tb/privado_rorri
chown helena:helena /mnt/samba1tb/privado_helena
chown admin:admin /mnt/samba1tb/privado_admin

chmod 700 /mnt/samba1tb/privado_*
chown root:root /mnt/samba1tb/comun
chmod 775 /mnt/samba1tb/comun
```
Propósito: 700 en privados garantiza que solo el propietario puede listar/leer/escribir; 775 en comun permite colaboración entre usuarios del grupo.
Resumen del bloque smb.conf aplicado (extracto)
ini
```bash
[comun]
   path = /mnt/samba1tb/comun
   browseable = yes
   writable = yes
   guest ok = no
   read only = no
   create mask = 0664
   directory mask = 0775
   valid users = victor, rorri, helena, admin
   force group = root

[privado_victor]
   path = /mnt/samba1tb/privado_victor
   browseable = no
   writable = yes
   valid users = victor
   force user = victor
   force group = victor

# (equivalente para rorri, helena, admin)
```
Acceso desde Windows: validado. Se limpió el Administrador de credenciales de Windows cuando fue necesario para forzar autenticación.
## ✅ Almacenamientos en Proxmox (configuración)

Contenido actual de /etc/pve/storage.cfg (resumen verificado):
ID	Tipo	Path / Pool	Contenido configurado
local	dir	/var/lib/vz	iso,vztmpl,backup
local-lvm	lvmthin	vgname pve	rootdir,images
nas	zfspool	pool nas (mirror)	rootdir,images
backup	zfspool	pool backup	images,rootdir
samba1tb	dir	/mnt/samba1tb	iso,rootdir,snippets,backup,import,vztmpl,images

Acciones realizadas en GUI (Proxmox en castellano):

    Centro de datos → Almacenamiento → Añadir → ZFS → nas (pool nas)

    Centro de datos → Almacenamiento → Añadir → ZFS → backup (pool backup)

    Centro de datos → Almacenamiento → Añadir → Directorio → samba1tb (/mnt/samba1tb)

## 🛠 Comandos clave y salidas relevantes

    Propósito: registrar las salidas reales que se usaron para validar el estado del sistema.

zpool status (salida resumida)
bash
```bash
zpool status
```
Resultado (resumen):
Código

pool: backup
 state: ONLINE
  sdd2 ONLINE

pool: nas
 state: ONLINE
  mirror-0: sda, sdb ONLINE

✅ Estado: ambos pools ONLINE, sin errores conocidos.
lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT (salida resumida)
bash
```bash
lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT
```
Resultado (resumen):
Código

sda    3.6T  zfs_member
sdb    3.6T  zfs_member
sdc  232.9G  (SSD sistema)
sdd    3.6T
 ├─sdd1 1T  ext4   /mnt/samba1tb
 └─sdd2 2.6T zfs_member

pvesm status (salida resumida)
bash
```bash
pvesm status
```
Resultado (resumen):
Código

backup    zfspool active ...
local     dir     active ...
local-lvm lvmthin active ...
nas       zfspool active ...
samba1tb  dir     active ...

✅ Estado: todos los almacenamientos configurados en Proxmox están activos.
cat /etc/pve/storage.cfg (extracto)
bash
```bash
cat /etc/pve/storage.cfg
```
Extracto verificado (resumen):
Código

zfspool: nas
  pool nas
  content rootdir,images
  mountpoint /nas
  nodes pve

zfspool: backup
  pool backup
  content images,rootdir
  mountpoint /backup
  nodes pve

dir: samba1tb
  path /mnt/samba1tb
  content iso,rootdir,snippets,backup,import,vztmpl,images
  nodes pve

## 🔒 Consideraciones de seguridad y buenas prácticas

    No usar guest ok = yes en recursos con datos sensibles. ✅

    Permisos Unix estrictos en carpetas privadas (700) para evitar fugas de datos. ✅

    Limpiar credenciales en Windows tras cambios de permisos o usuarios para evitar sesiones persistentes. ✅

    Snapshots ZFS periódicos: programar snapshots automáticos en nas antes de cambios críticos. (Recomendado)

    Backups fuera del host: replicar backup a otro host o almacenamiento externo para tolerancia a fallos. (Recomendado)

    Monitorización de integridad ZFS: zpool scrub programado semanalmente. (Recomendado)

## 📝 Notas Importantes
🧾 Resumen del Proceso Realizado
Fase	Acción
1	Instalación directa de Proxmox VE 9.0.3 desde ISO
2	Preparación y borrado seguro de discos (wipefs, sgdisk)
3	Creación de pool ZFS nas (mirror sda+sdb)
4	Creación de pool ZFS backup (sdd2)
5	Particionado de sdd en sdd1 (ext4) y sdd2 (ZFS)
6	Formateo y montaje de /dev/sdd1 en /mnt/samba1tb
7	Instalación y configuración de Samba multiusuario
8	Creación de carpetas privadas y carpeta común con permisos adecuados
9	Integración de nas, backup, samba1tb en Proxmox
10	Validación final con zpool status, zfs list, lsblk, pvesm status
✅ Lo que SÍ se hizo correctamente

    Proxmox instalado directamente y accesible por web y SSH. ✅

    Pools ZFS nas y backup creados y ONLINE. ✅

    Volumen ext4 montado en /mnt/samba1tb y usado por Samba. ✅

    Samba configurado con usuarios y permisos privados/comunes. ✅

    Almacenamientos añadidos y activos en Proxmox. ✅

❌ Errores Comunes Evitados

    No se permitió acceso guest en Samba. ❌

    No se exportó el directorio raíz del disco por Samba (se eliminó recurso redundante). ❌

    No se usaron permisos inseguros (777). ❌

    No se dejaron pools sin montar ni sin añadir a Proxmox. ❌

🧩 Configuración Final del Sistema (resumen técnico)
Elemento	Valor
Hostname	pve
IP	192.168.1.100
Proxmox VE	9.0.3
Kernel	6.14.8-2-pve
Pools ZFS	nas (mirror sda+sdb), backup (sdd2)
ext4	/dev/sdd1 → /mnt/samba1tb
Samba	comun, privado_victor, privado_rorri, privado_helena, privado_admin
Usuarios Samba	victor, rorri, helena, admin
Almacenamientos Proxmox	local, local-lvm, nas, backup, samba1tb
Estado ZFS	ONLINE, sin errores
Estado discos	Correcto, sin particiones residuales


---


Documentación creada por: Victor 3,1416
Fecha de creación: 25/08/1989
Última actualización: 28/01/2026 05:25
Sistema: Proxmox (Virtual Environment 9.0.3)
Estado: ✅ Configuración completada y verificada

Esta documentación refleja el proceso REAL seguido durante la instalación y configuración del servidor.

markdown

# 002 - Instalación directa de Proxmox, configuración de almacenamiento y Samba multiusuario

---

## 📋 Tabla de Contenidos
- [🚀 Objetivo del documento](#🚀-objetivo-del-documento)
- [💻 Instalación directa de Proxmox VE 9.0](#💻-instalación-directa-de-proxmox-ve-90)
- [🧩 Configuración de discos y pools ZFS](#🧩-configuración-de-discos-y-pools-zfs)
- [🔐 Preparación de disco ext4 para Samba](#🔐-preparación-de-disco-ext4-para-samba)
- [🌐 Configuración de Samba multiusuario](#🌐-configuración-de-samba-multiusuario)
- [✅ Integración de almacenamiento en Proxmox](#✅-integración-de-almacenamiento-en-proxmox)
- [📝 Notas Importantes](#📝-notas-importantes)

---

## 🚀 Objetivo del documento

Este procedimiento documenta la instalación directa de Proxmox VE 9.0 sobre hardware físico, evitando la instalación previa de Debian. Se configura el almacenamiento completo del sistema, incluyendo pools ZFS y particiones ext4, y se implementa Samba con usuarios individuales y carpeta común. Finalmente, se integra todo el almacenamiento en la interfaz de Proxmox para uso en máquinas virtuales, contenedores y copias de seguridad.

---

## 💻 Instalación directa de Proxmox VE 9.0

- Se descarga la ISO oficial de Proxmox VE 9.0 desde [proxmox.com](https://www.proxmox.com).
- Se realiza instalación directa sobre el SSD principal (`sdc`, Samsung EVO 250GB).
- Se configura red estática y acceso SSH.
- Se accede a la interfaz web en `https://192.168.1.76:8006`.

---

## 🧩 Configuración de discos y pools ZFS

### Discos físicos detectados:

| Disco | Modelo                  | Tamaño | Uso asignado |
|-------|--------------------------|--------|--------------|
| sda   | ST4000VN006 IronWolf     | 4 TB   | ZFS mirror   |
| sdb   | ST4000VN006 IronWolf     | 4 TB   | ZFS mirror   |
| sdd   | ST4000VN006 IronWolf     | 4 TB   | ext4 + ZFS   |
| sdc   | Samsung SSD 860 EVO      | 250 GB | Sistema base |
| sdi   | SanDisk USB              | 57 GB  | Externo      |

### Creación de pools ZFS:

```bash
# Borrado completo de discos
wipefs -a /dev/sda
wipefs -a /dev/sdb
wipefs -a /dev/sdd
sgdisk --zap-all /dev/sda
sgdisk --zap-all /dev/sdb
sgdisk --zap-all /dev/sdd

# Pool ZFS mirror
zpool create -f \
  -o ashift=12 \
  -O compression=lz4 \
  -O atime=off \
  -O xattr=sa \
  -O acltype=posixacl \
  nas mirror /dev/sda /dev/sdb

# Pool ZFS para backups
zpool create -f \
  -o ashift=12 \
  -O compression=lz4 \
  -O atime=off \
  -O xattr=sa \
  -O acltype=posixacl \
  backup /dev/sdd2
```

### 🔐 Preparación de disco ext4 para Samba
Particionado de sdd:
bash
```bash
sgdisk -n 1:0:+1T -t 1:8300 /dev/sdd
sgdisk -n 2:0:0 -t 2:bf00 /dev/sdd
```
Formateo y montaje:
bash
```bash
mkfs.ext4 /dev/sdd1
mkdir -p /mnt/samba1tb
mount /dev/sdd1 /mnt/samba1tb
```
### 🌐 Configuración de Samba multiusuario
Instalación de Samba:
bash
```bash
apt update
apt install samba -y
```
Creación de usuarios:
bash
```bash
adduser victor
adduser rorri
adduser helena
adduser admin

smbpasswd -a victor
smbpasswd -a rorri
smbpasswd -a helena
smbpasswd -a admin
```
Estructura de carpetas:
bash
```bash
mkdir -p /mnt/samba1tb/comun
mkdir -p /mnt/samba1tb/privado_victor
mkdir -p /mnt/samba1tb/privado_rorri
mkdir -p /mnt/samba1tb/privado_helena
mkdir -p /mnt/samba1tb/privado_admin

chown victor:victor /mnt/samba1tb/privado_victor
chown rorri:rorri /mnt/samba1tb/privado_rorri
chown helena:helena /mnt/samba1tb/privado_helena
chown admin:admin /mnt/samba1tb/privado_admin
chmod 700 /mnt/samba1tb/privado_*

chown root:root /mnt/samba1tb/comun
chmod 775 /mnt/samba1tb/comun
```
Configuración en smb.conf:
ini

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

[privado_rorri]
   path = /mnt/samba1tb/privado_rorri
   browseable = no
   writable = yes
   valid users = rorri
   force user = rorri
   force group = rorri

[privado_helena]
   path = /mnt/samba1tb/privado_helena
   browseable = no
   writable = yes
   valid users = helena
   force user = helena
   force group = helena

[privado_admin]
   path = /mnt/samba1tb/privado_admin
   browseable = no
   writable = yes
   valid users = admin
   force user = admin
   force group = admin

Reinicio de servicios:
bash
```bash
systemctl restart smbd
systemctl restart nmbd
```
### ✅ Integración de almacenamiento en Proxmox
Añadido desde interfaz web (castellano):

    Centro de datos → Almacenamiento → Añadir → ZFS

        ID: nas

        Pool ZFS: nas

        Contenido: Disco de máquina virtual, Contenedor, Snippets

    Centro de datos → Almacenamiento → Añadir → ZFS

        ID: backup

        Pool ZFS: backup

        Contenido: Copia de seguridad, Snippets

    Centro de datos → Almacenamiento → Añadir → Directorio

        ID: samba1tb

        Ruta: /mnt/samba1tb

        Contenido: ISO, Copia de seguridad, Snippets, Plantillas, Imágenes

### 📝 Notas Importantes
🧾 Resumen del Proceso Realizado
Componente	Acción realizada
Proxmox VE	Instalación directa desde ISO
Discos IronWolf	Borrado, particionado y formateo
ZFS Pools	nas (mirror), backup (single)
ext4	Montaje en /mnt/samba1tb
Samba	Instalación y configuración multiusuario
Proxmox Storage	Integración completa en interfaz web
✅ Lo que SÍ se hizo correctamente

    Instalación directa de Proxmox sin Debian intermedio

    Borrado seguro de discos con wipefs y sgdisk

    Creación de pools ZFS con parámetros óptimos

    Particionado manual de disco para ext4 + ZFS

    Configuración de Samba con usuarios y permisos individuales

    Integración de almacenamiento en Proxmox con tipos correctos

    Validación desde terminal (zpool status, lsblk, pvesm status)

❌ Errores Comunes Evitados

    No se mezclaron credenciales Samba en Windows

    No se exportó el disco raíz completo por Samba

    No se dejaron pools sin montar ni sin añadir a Proxmox

    No se usaron permisos inseguros en carpetas privadas

    No se omitió el montaje persistente en /etc/fstab


### 🧩 Configuración Final del Sistema

| Componente                     | Estado Final Configurado |
|-------------------------------|---------------------------|
| Sistema base                  | Proxmox VE 9.0 instalado directamente desde ISO |
| Disco del sistema (sdc)       | Particionado por instalador, LVM-Thin para `local-lvm` |
| Pool ZFS `nas`                | RAID1 (mirror) con discos `sda` + `sdb` |
| Pool ZFS `backup`             | Disco único `sdd2` dedicado a copias y almacenamiento secundario |
| Partición ext4 `sdd1`         | Montada en `/mnt/samba1tb` para Samba |
| Samba                         | Instalado, configurado y operativo |
| Usuarios Samba                | `victor`, `rorri`, `helena`, `admin` |
| Carpetas privadas             | Acceso exclusivo por usuario, permisos 700 |
| Carpeta común                 | Acceso compartido, permisos 775 |
| Recursos Samba exportados     | `comun`, `privado_victor`, `privado_rorri`, `privado_helena`, `privado_admin` |
| Almacenamiento en Proxmox     | `nas`, `backup`, `samba1tb`, `local`, `local-lvm` |
| Estado de pools ZFS           | ONLINE, sin errores (`zpool status`) |
| Estado de discos              | Correcto (`lsblk`), sin particiones residuales |
| Montajes persistentes         | Definidos en `/etc/fstab` |
| Acceso desde Windows          | Validado, permisos correctos por usuario |

---

## 📝 Notas Importantes

### 📌 Resumen del Proceso Realizado

| Fase | Acción |
|------|--------|
| 1 | Instalación directa de Proxmox VE 9.0 desde ISO oficial |
| 2 | Borrado seguro de discos y preparación de estructura de almacenamiento |
| 3 | Creación de pools ZFS `nas` (mirror) y `backup` (single) |
| 4 | Particionado manual del disco `sdd` en ext4 + ZFS |
| 5 | Montaje persistente del volumen ext4 en `/mnt/samba1tb` |
| 6 | Instalación y configuración completa de Samba multiusuario |
| 7 | Creación de carpetas privadas y carpeta común |
| 8 | Configuración de permisos Unix y reglas Samba |
| 9 | Integración de todos los almacenamientos en Proxmox |
| 10 | Validación final del sistema desde terminal y desde Windows |

---

### ✅ Lo que SÍ se hizo correctamente

- Instalación limpia de Proxmox sin capas intermedias.
- Borrado seguro de discos con `wipefs` y `sgdisk`.
- Creación de pools ZFS con parámetros óptimos (`ashift=12`, `lz4`, `atime=off`).
- Particionado manual del disco `sdd` en ext4 + ZFS sin solapamientos.
- Montaje persistente del volumen ext4 en `/etc/fstab`.
- Configuración de Samba con usuarios individuales y permisos estrictos.
- Eliminación del recurso Samba raíz para evitar accesos no deseados.
- Integración correcta de `nas`, `backup` y `samba1tb` en Proxmox.
- Validación completa con `zpool status`, `zfs list`, `lsblk`, `pvesm status`.
- Limpieza de credenciales en Windows para evitar conflictos de autenticación.

---

### ❌ Errores Comunes Evitados

- No se mezclaron permisos entre carpetas privadas.
- No se exportó el directorio raíz del disco por Samba.
- No se dejaron pools ZFS sin montar o sin añadir a Proxmox.
- No se usaron permisos 777 ni configuraciones inseguras.
- No se creó un RAID incorrecto (mirror vs stripe).
- No se dejó el disco ext4 sin entrada en `fstab`.
- No se permitió acceso invitado en Samba.
- No se mezclaron credenciales en Windows (se limpiaron correctamente).

---

### 🧩 Configuración Final del Sistema (Resumen Técnico)

| Elemento | Valor |
|---------|-------|
| Hostname | `pve` |
| IP estática | `192.168.1.76` |
| Proxmox VE | 9.0.3 |
| Kernel | 6.14.8-2-pve |
| Pools ZFS | `nas` (mirror), `backup` (single) |
| ext4 | `/dev/sdd1` → `/mnt/samba1tb` |
| Samba | Activo, multiusuario |
| Usuarios Samba | victor, rorri, helena, admin |
| Carpetas privadas | 4 (una por usuario) |
| Carpeta común | `/mnt/samba1tb/comun` |
| Almacenamientos Proxmox | local, local-lvm, nas, backup, samba1tb |
| Estado ZFS | ONLINE, sin errores |
| Estado discos | Correcto, sin particiones residuales |

---

### ✍️ Autor, Fecha y Estado

Documentación creada por: Victor 3,1416
Fecha de creación: 28/01/2026
Última actualización: 28/01/2026 00:40
Sistema: Proxmox (Virtual Environment 9.0.3)
Estado: ✅ Configuración completada y verificada

Esta documentación refleja el proceso REAL seguido durante la instalación y configuración del servidor.

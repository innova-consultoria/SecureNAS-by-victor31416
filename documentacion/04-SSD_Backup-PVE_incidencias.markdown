# 📋 INFORME TÉCNICO – SSD WD Blue 500GB y Backup PVE  
**Archivo:** `04-SSD_Backup-PVE_incidencias.md`  
**Fecha:** 10 de octubre de 2025  
**Proyecto:** [SecureNAS-by-victor31416](https://github.com/innova-consultoria/SecureNAS-by-victor31416)

---

## 🧭 FASE 1: INVESTIGACIÓN FORENSE Y ANÁLISIS DE DATOS RESIDUALES

### 🔧 Configuración inicial

- Se conecta el disco WD Blue SSD 500GB a un MiniPC con Windows 10 Pro mediante SATA III interno.
- Se realiza una investigación forense para verificar si contiene datos sensibles.

### 🧪 Herramientas utilizadas

- **TestDisk**: se detecta una partición XFS con trazas de Debian y Nextcloud.
- **PhotoRec**: se recuperan archivos de configuración, logs y metadatos.

### ✅ Conclusión

- No se detectan datos sensibles.
- El disco queda apto para formateo y reutilización.

---

## 🔄 FASE 2: FORMATEO Y MONTAJE EN PROXMOX

### 🔌 Conexión

- Se conecta el disco a Proxmox mediante adaptador USB 3.0 externo.

### 🔍 Verificación SMART

```bash
smartctl -i /dev/sde
smartctl -x /dev/sde
```

- Estado: PASSED
- Horas de uso: 2
- Temperatura: 31 °C
- Sectores reasignados: 0
- Indicador de desgaste: 510 (óptimo)

### 🧹 Formateo y montaje

```bash
mkfs.ntfs /dev/sde1 -f
blkid /dev/sde1
mkdir -p /mnt/pve_bkp
mount /dev/sde1 /mnt/pve_bkp
echo "/dev/sde1 /mnt/pve_bkp ntfs defaults 0 2" >> /etc/fstab
```

### 📊 Pruebas de rendimiento

- Se realizan pruebas con `fio`.
- Resultado: disco estable y listo para producción.

---

## 🔁 FASE 3: RETORNO A WINDOWS 10 PRO

- Se desconecta el disco de Proxmox y se vuelve a conectar al MiniPC por SATA III.
- Se verifica que el disco está vacío y formateado en NTFS.
- Se prepara para recibir backups sincronizados desde Proxmox.

---

## 🚨 FASE 4: INCIDENTE CRÍTICO EN PROXMOX

### ❗ Problema

- El sistema no arranca debido a una dependencia residual en `/etc/fstab`.
- El disco `/dev/sde1` no está presente y el sistema entra en modo emergencia.

### 🧭 Diagnóstico

```bash
journalctl -b -1 | grep sde1
```

- Se detecta timeout en `/dev/sde1`.
- El servicio `mnt-pvc_bkp.mount` falla.

---

## 🧯 FASE 5: RESOLUCIÓN DEL INCIDENTE

### 🛠️ Acciones realizadas

```bash
cat /etc/fstab | grep sde
systemctl list-units --all | grep mount
cp /etc/fstab /etc/fstab.backup
sed -i '/sde1/d' /etc/fstab
systemctl disable mnt-pvc_bkp.mount
systemctl mask mnt-pvc_bkp.mount
systemctl status local-fs.target
```

### ✅ Resultado

- El sistema arranca correctamente.
- Se eliminan dependencias conflictivas.
- Se bloquea el servicio conflictivo.

---

## 💾 FASE 6: IMPLEMENTACIÓN DE BACKUP CON RCLONE

### 🔧 Configuración Rclone

- Se configura Rclone en Windows para conectarse al servidor Proxmox por SFTP.

```bash
rclone lsd proxmox_backup:/
```

### 📁 Estructura de backup

```
PVE_BKP/
└── YYYYMMDD_HHMM_Bkp_01/
    ├── etc_backup.tar.gz
    ├── root_backup.tar.gz
    ├── var_lib_backup.tar.gz
    ├── installed_packages.txt
    └── checksum.sha256
```

### 📝 Script de backup

```bash
#!/bin/bash
FECHA=$(date "+%Y%m%d_%H%M")
BACKUP_NAME="${FECHA}_Bkp_01"
BACKUP_DIR="/mnt/pve_bkp/PVE_BKP/$BACKUP_NAME"

mkdir -p $BACKUP_DIR
tar -czf $BACKUP_DIR/etc_backup.tar.gz /etc/
tar -czf $BACKUP_DIR/root_backup.tar.gz /root/ --exclude=/root/.cache
tar -czf $BACKUP_DIR/var_lib_backup.tar.gz /var/lib/
dpkg --get-selections > $BACKUP_DIR/installed_packages.txt
cd $BACKUP_DIR && sha256sum * > checksum.sha256
```

### 🔁 Sincronización a Windows

```bash
rclone sync proxmox_backup:/mnt/pve_bkp/PVE_BKP/ D:\PVE_BKP
```

---

## 📊 MÉTRICAS Y VERIFICACIONES FINALES

- `local-fs.target`: activo
- Espacio en disco: suficiente
- Conectividad: estable
- Backup: verificado vía SHA256
- Accesibilidad: desde Windows y Proxmox
- Estado SMART del disco: óptimo

---

## 📚 LECCIONES APRENDIDAS

- Realizar investigación forense antes de reutilizar discos.
- Documentar movimientos físicos y cambios de interfaz.
- Desmontar discos correctamente antes de apagar el sistema.
- Limpiar configuraciones obsoletas en `/etc/fstab`.
- Usar `systemctl mask` para evitar reactivaciones no deseadas.
- Validar integridad de backups con checksums.

---

## 🎯 PRÓXIMOS PASOS

### ⏱️ Corto plazo

- Automatizar backups vía `cron` en Proxmox.
- Programar sincronización en Windows.
- Probar restauración desde backup.

### 📆 Medio plazo

- Implementar retención automática de backups antiguos.
- Configurar alertas de estado de backups.
- Documentar recuperación ante desastres.

### 🌐 Largo plazo

- Evaluar estrategia de backup off-site.
- Encriptar backups sensibles.
- Automatizar todo el pipeline de respaldo.

---

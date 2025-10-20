# ✅ ANÁLISIS DETALLADO - PROYECTO SNAS

## 📊 ESTADO GLOBAL: FASE 0 COMPLETADA ✅
PROYECTO SNAS (Secure Network Attached Storage)

📅 Fecha de Análisis: 20 de octubre de 2025

🔍 Análisis realizado por: victor31416

### 🔍 Fase 0: Auditoría inicial

✅ Todas las tareas completadas. El sistema está validado para iniciar la Fase 1.

- [x] 0.1 Auditoría completa de hardware (CPU, RAM, discos)  
- [x] 0.2 Diagnóstico SMART de todos los discos  
- [x] 0.3 Verificación estado ZFS pool `nas`  
- [x] 0.4 Análisis configuración red actual  
- [x] 0.5 Inventario servicios y puertos activos  
- [x] 0.6 Identificación riesgos de seguridad  
- [x] 0.7 Descarte falso positivo disco fallido  
- [x] 0.8 Validación sistema listo para Fase 1  

### 🎯 Fase 1: Seguridad base

En progreso. Tareas organizadas por bloques funcionales.

#### 1.1 Planificación de seguridad

- [ ] 1.1.1 Decidir firewall: OPNsense vs pfSense  
- [ ] 1.1.2 Definir nuevo puerto SSH (no 22)  
- [ ] 1.1.3 Planificar estructura VLANs  
- [ ] 1.1.4 Confirmar recursos para VM firewall (mínimo 2GB RAM)  

#### 1.2 Implementación del firewall

- [ ] 1.2.1 Descargar ISO OPNsense/pfSense  
- [ ] 1.2.2 Crear VM-100 (firewall) en Proxmox  
- [ ] 1.2.3 Configurar 2 interfaces de red (WAN/LAN)  
- [ ] 1.2.4 Instalar sistema firewall  
- [ ] 1.2.5 Configurar IP de gestión (ej: 192.168.1.100)  
- [ ] 1.2.6 Establecer reglas base  
- [ ] 1.2.7 Configurar servidor DHCP  

#### 1.3 Hardening SSH

- [ ] 1.3.1 Backup configuración SSH actual  
- [ ] 1.3.2 Cambiar puerto SSH  
- [ ] 1.3.3 Deshabilitar login root directo  
- [ ] 1.3.4 Configurar autenticación por claves SSH  
- [ ] 1.3.5 Instalar y configurar fail2ban  
- [ ] 1.3.6 Reiniciar servicio SSH y verificar  
- [ ] 1.3.7 Actualizar reglas firewall para nuevo puerto  

#### 1.4 Backup de configuración crítica

- [ ] 1.4.1 Backup configuración Proxmox  
- [ ] 1.4.2 Backup configuración ZFS pool  
- [ ] 1.4.3 Backup configuración red  
- [ ] 1.4.4 Documentar acceso de emergencia  

#### 1.5 Monitorización base

- [ ] 1.5.1 Verificar Netdata operativo (puerto 19999)  
- [ ] 1.5.2 Configurar alertas básicas  
- [ ] 1.5.3 Monitorizar recursos del sistema  


### 🚀 Fase 2: Servicios core

#### 2.1 AdGuard Home (DNS + filtrado)

- [ ] 2.1.1 Crear LXC-1 (Debian 12) - 512MB RAM  
- [ ] 2.1.2 Configurar IP estática (192.168.1.53)  
- [ ] 2.1.3 Instalar AdGuard Home  
- [ ] 2.1.4 Configurar como servidor DNS (puerto 53)  
- [ ] 2.1.5 Agregar listas de bloqueo de anuncios  
- [ ] 2.1.6 Configurar clientes DNS en firewall  
- [ ] 2.1.7 Probar filtrado DNS  

#### 2.2 VPN WireGuard

- [ ] 2.2.1 Crear LXC-2 (Debian 12) - 512MB RAM  
- [ ] 2.2.2 Configurar IP estática (192.168.1.54)  
- [ ] 2.2.3 Instalar WireGuard  
- [ ] 2.2.4 Generar claves servidor y clientes  
- [ ] 2.2.5 Configurar interfaz VPN (10.8.0.1/24)  
- [ ] 2.2.6 Abrir puerto 51820 UDP en firewall  
- [ ] 2.2.7 Configurar 2–3 clientes de prueba  
- [ ] 2.2.8 Probar conectividad remota  

#### 2.3 Nextcloud hardening

- [ ] 2.3.1 Crear LXC-3 (Debian 12) - 4GB RAM  
- [ ] 2.3.2 Configurar IP estática (192.168.1.55)  
- [ ] 2.3.3 Montar dataset ZFS nas/nc  
- [ ] 2.3.4 Instalar stack LAMP/LEMP  
- [ ] 2.3.5 Instalar y configurar Nextcloud  
- [ ] 2.3.6 Configurar base de datos PostgreSQL  
- [ ] 2.3.7 Implementar SSL/TLS (certificado)  
- [ ] 2.3.8 Configurar políticas de seguridad  
- [ ] 2.3.9 Probar acceso web y sincronización  

#### 2.4 Monitorización avanzada

- [ ] 2.4.1 Instalar Zabbix Agent en todos los sistemas  
- [ ] 2.4.2 Configurar alertas por email  
- [ ] 2.4.3 Crear dashboard consolidado de servicios  

---

### 🎬 Fase 3: Servicios avanzados

#### 3.1 Plataforma multimedia

- [ ] 3.1.1 Decidir plataforma: Jellyfin vs Plex  
- [ ] 3.1.2 Crear LXC/VM multimedia - 2GB RAM  
- [ ] 3.1.3 Configurar IP estática (192.168.1.56)  
- [ ] 3.1.4 Montar dataset ZFS nas/media  
- [ ] 3.1.5 Instalar Jellyfin/Plex  
- [ ] 3.1.6 Configurar bibliotecas multimedia  
- [ ] 3.1.7 Optimizar transcodificación hardware (Intel HD 530)  
- [ ] 3.1.8 Configurar acceso seguro (HTTPS)  
- [ ] 3.1.9 Probar streaming local/remoto  

#### 3.2 Sistema domótica

- [ ] 3.2.1 Crear LXC-4 (Debian 12) - 1GB RAM  
- [ ] 3.2.2 Configurar IP estática (192.168.1.57)  
- [ ] 3.2.3 Instalar Home Assistant  
- [ ] 3.2.4 Configurar VLAN IOT (192.168.30.0/24)  
- [ ] 3.2.5 Integrar dispositivos IOT iniciales  
- [ ] 3.2.6 Configurar automatizaciones básicas  
- [ ] 3.2.7 Crear dashboard de control  

#### 3.3 Backup automatizado

- [ ] 3.3.1 Configurar backups automáticos en Proxmox  
- [ ] 3.3.2 Programar backups diarios de LXC/VM  
- [ ] 3.3.3 Configurar retención (diario 7d, semanal 4w, mensual 12m)  
- [ ] 3.3.4 Implementar backup de configuraciones  
- [ ] 3.3.5 Verificar restauración desde backup  

---

### 🔧 Fase 4: Optimización y mantenimiento

#### 4.1 Optimización rendimiento

- [ ] 4.1.1 Ajustar parámetros ZFS (recordsize, compression)  
- [ ] 4.1.2 Optimizar uso de memoria y swap  
- [ ] 4.1.3 Configurar ajustes de red  
- [ ] 4.1.4 Optimizar servicios críticos  

#### 4.2 Seguridad avanzada

- [ ] 4.2.1 Implementar 2FA para acceso web  
- [ ] 4.2.2 Configurar IDS/IPS (Suricata)  
- [ ] 4.2.3 Realizar auditoría de seguridad completa  
- [ ] 4.2.4 Rotar claves y certificados  

#### 4.3 Monitorización completa

- [ ] 4.3.1 Implementar Grafana + Prometheus  
- [ ] 4.3.2 Configurar dashboards personalizados  
- [ ] 4.3.3 Activar alertas proactivas (espacio, carga, errores)  
- [ ] 4.3.4 Monitorización externa (Healthchecks)  

#### 4.4 Backup 3-2-1

- [ ] 4.4.1 Configurar replicación ZFS a disco externo  
- [ ] 4.4.2 Implementar backup en cloud (opcional)  
- [ ] 4.4.3 Documentar procedimiento de recuperación  
- [ ] 4.4.4 Test completo de recuperación ante desastres  

#### 4.5 Documentación final

- [ ] 4.5.1 Documentar arquitectura completa  
- [ ] 4.5.2 Crear manuales operativos por servicio  
- [ ] 4.5.3 Definir procedimientos de emergencia  
- [ ] 4.5.4 Establecer plan de mantenimiento periódico  

---

### 📋 Checklist mantenimiento periódico

**Diario:**

- [ ] Revisar alertas críticas  
- [ ] Verificar estado de backups  
- [ ] Comprobar espacio en disco  
- [ ] Revisar logs de seguridad  

**Semanal:**

- [ ] Aplicar actualizaciones de seguridad  
- [ ] Limpiar logs y archivos temporales  
- [ ] Verificar integridad del pool ZFS  
- [ ] Testear servicios críticos  

**Mensual:**

- [ ] Ejecutar scrub ZFS programado  
- [ ] Realizar auditoría de seguridad  
- [ ] Probar restauración desde backup  
- [ ] Rotar claves de acceso  

**Anual:**

- [ ] Revisar estado físico del hardware  
- [ ] Aplicar actualizaciones mayores de software  
- [ ] Ejecutar test completo de recuperación ante desastres  
- [ ] Revisar políticas de seguridad y mantenimiento  

---

### Próximos pasos inmediatos

**Fase 1.1 - Prioridad alta:**

- [ ] Decidir: OPNsense vs pfSense  
- [ ] Definir: Nuevo puerto SSH  
- [ ] Ejecutar: `pvesh get /cluster/resources --type vm --type lxc`  
- [ ] Confirmar: Recursos disponibles para VM firewall  


Proyecto: https://github.com/innova-consultoria/SecureNAS-by-victor31416

🩹 XX = Números o caracteres ocultos por privacidad o seguridad.

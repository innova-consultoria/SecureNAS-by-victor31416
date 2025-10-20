# 🔐 INFORME EJECUTIVO  
## Proyecto SNAS (Secure Network Attached Storage)

**📅 Fecha de análisis:** 20 de octubre de 2025  
**👤 Autor:** Consultor Senior DevOps & Seguridad  

---

## 1. VISIÓN GENERAL DEL PROYECTO

El Proyecto SNAS es una iniciativa de infraestructura crítica orientada a implementar un sistema de almacenamiento en red seguro, escalable y de alta disponibilidad. Se basa en tecnologías open-source y sigue principios de la Triada CIA: **Confidencialidad, Integridad y Disponibilidad**.

### 🏗️ Arquitectura Base

- **Hipervisor:** Proxmox VE 8.x  
- **Sistema Operativo:** Debian 12  
- **Almacenamiento:** ZFS RAID-Z1 (3×4TB Seagate IronWolf)  
- **Seguridad:** Defense in Depth  

---

## 2. PLAN MAESTRO POR FASES

### ✅ FASE 0: Auditoría Inicial

- Hardware verificado: Intel i7-6700, 16GB RAM  
- Pool ZFS `nas` operativo y estable  
- Falso positivo en disco corregido  
- Sistema base listo para producción  

### 🟡 FASE 1: Seguridad Base

Fortificación del sistema base antes de exponer servicios.

### ⏳ FASE 2: Servicios de Red y Monitorización

Despliegue de servicios de red seguros y herramientas de observabilidad.

### ⏳ FASE 3: Almacenamiento y Backup

Implementación de servicios de almacenamiento colaborativo y estrategias de respaldo.

### 🎯 FASE 4: Implementación Iterativa

Despliegue controlado por servicio con validación técnica y documentación reproducible.

# FASE 1: Seguridad Base
sudo nano /etc/ssh/sshd_config
# Port 6022

sudo iptables -A INPUT -p tcp --dport 6022 -j ACCEPT

# SSH Hardening
PermitRootLogin no
PasswordAuthentication no

# FASE 2: Servicios de Red y Monitorización
# OPNsense en VM-100
# Configurar interfaces WAN/LAN
# Políticas base: denegar todo / permitir explícito
# VLANs para segmentación

# VPN
# WireGuard o OpenVPN para acceso remoto

# Monitorización
# Zabbix o Prometheus para métricas
# AdGuard Home para filtrado DNS

# FASE 3: Almacenamiento y Backup
# Nextcloud en contenedor LXC
# Montar dataset nas/nc
# Configurar reverse proxy con SSL/TLS (Let's Encrypt)

# Backups
# rsync local/remoto
# zfs send | zfs receive para replicación

# S3 Object Storage
# Evaluar MinIO o integración con proveedores externos

# Snapshots
# Automatización con zfs-auto-snapshot
# Retención diaria/semanal/mensual

# FASE 4: Implementación Iterativa
# Ciclo por servicio
# Desplegar → probar → documentar → validar

# Checklist por fase
# Seguridad
# Disponibilidad
# Integridad

# Repositorio Git
# Markdown + Bash
# Auditoría completa

## 3. ESTADO ACTUAL DE LA INFRAESTRUCTURA

La infraestructura base ha sido verificada y se encuentra en estado óptimo para iniciar la fase de implementación. El pool ZFS está operativo, los discos han superado las pruebas SMART, y el hardware cumple con los requisitos mínimos para los servicios proyectados.

### 💾 Pool ZFS `nas`

- Tipo: RAID-Z1  
- Capacidad usable: 7.14 TB  
- Estado: ONLINE - ÓPTIMO  

**Discos verificados:**

- /dev/sdb — ST4000VN006 — ZW63A3YJ — 1,460 horas — ✅ HEALTHY  
- /dev/sdc — ST4000VN006 — ZW639X9J — 1,411 horas — ✅ HEALTHY  
- /dev/sdd — ST4000VN006 — ZW63A2RB — 1,484 horas — ✅ HEALTHY  

**Datasets configurados:**

- nas/bkp     (4.00T)  → Backups  
- nas/comun   (110G)   → Datos compartidos  
- nas/nc      (3.00T)  → Nextcloud  

### ⚙️ Hardware Verificado

- CPU: Intel i7-6700 (4 cores / 8 threads)  
- RAM: 16GB DDR4  
- Red: Gigabit Ethernet  
- UPS: Recomendado para alta disponibilidad  

---

## 4. RIESGOS IDENTIFICADOS Y MITIGACIÓN

Se han identificado riesgos en tres niveles: críticos, medios y bajos. Las medidas de mitigación están definidas y deben aplicarse antes de exponer servicios al entorno de producción.

### 🔴 Riesgos Críticos

- SSH en puerto predeterminado (22/tcp)  
  → Exposición a ataques automatizados  
  → Mitigación: cambio inmediato a puerto 6022  

- Configuración sudo sin contraseña para ZFS  
  → Riesgo de escalada de privilegios  
  → Mitigación: revisión de políticas sudo  

### 🟡 Riesgos Medios

- Servicios ZFS con error en arranque (`zfs-import`, `zfs-load-keys`)  
  → Causa probable: pool sin cifrado  
  → Mitigación: deshabilitar servicios innecesarios  

### 🟢 Riesgos Bajos

- Monitorización no implementada  
- Backup automatizado pendiente  

---

## 5. PLAN DE IMPLEMENTACIÓN RECOMENDADO (7 DÍAS)

El siguiente plan propone una ejecución escalonada de tareas críticas, priorizando la seguridad base y el despliegue de servicios esenciales.

# Día 1-2: Seguridad Base
sudo nano /etc/ssh/sshd_config
# Port 6022

sudo iptables -A INPUT -p tcp --dport 6022 -j ACCEPT

# SSH Hardening
PermitRootLogin no
PasswordAuthentication no

# Día 3-4: Firewall Principal
# OPNsense en VM-100
# Configurar interfaces WAN/LAN
# Políticas: denegar todo / permitir explícito
# VLANs de segregación

# Día 5-7: Servicio Crítico #1
# Nextcloud en contenedor LXC
# Montar dataset nas/nc
# Configurar reverse proxy
# SSL/TLS con Let's Encrypt

## 6. ARQUITECTURA FUTURA PROPUESTA
La siguiente topología representa la arquitectura proyectada para implantar en el entorno SNAS, incluyendo virtualización, servicios críticos y almacenamiento:

┌─────────────────┐    ┌──────────────────┐
│   INTERNET      │    │  OPNsense VM-100 │
└────────┬────────┘    └─────────┬────────┘
         │                       │
┌────────┴────────┐              │
│   Proxmox VE    │◄─────────────┤
│   Hypervisor    │              │
└─────────┬───────┘              │
          │                      │
     ┌────┴─────┐                │
┌────┴────┐ ┌───┴─────┐          │
│Nextcloud│ │WireGuard│          │
│   LXC   │ │   LXC   │          │
└─────────┘ └─────────┘  ┌───────┴───────┐
                         │ ZFS Storage   │
                         │   nas pool    │
                         └───────────────┘

## 7. MÉTRICAS DE ÉXITO Y MONITORIZACIÓN

El éxito del proyecto SNAS se medirá mediante indicadores técnicos clave (KPIs) y un sistema de monitorización integral. Estos parámetros permiten validar la disponibilidad, rendimiento, seguridad y eficacia de los respaldos.

### 📊 KPIs Recomendados

- **Disponibilidad:** ≥ 99.9%  
- **Rendimiento:** > 150 MB/s en transferencia sostenida  
- **Seguridad:** 0 incidentes registrados  
- **Backup:** 100% de tareas completadas exitosamente  

### 🔍 Monitorización

- **Zabbix:** métricas de CPU, RAM, red, disco y servicios  
- **ZFS health:** verificación automática del estado del pool y discos  
- **Graylog / ELK:** agregación y análisis de logs del sistema  

# Instalación de Zabbix Agent
sudo apt update
sudo apt install zabbix-agent
sudo systemctl enable zabbix-agent
sudo systemctl start zabbix-agent

# Verificación de estado ZFS
zpool status
zpool list
zfs list

# Configuración de zfs-auto-snapshot
sudo apt install zfs-auto-snapshot
sudo systemctl enable zfs-auto-snapshot
sudo systemctl start zfs-auto-snapshot

# Configuración básica de Graylog (requiere MongoDB, Elasticsearch y Java)
# Este bloque es representativo, se recomienda usar contenedores o playbooks
sudo apt install openjdk-11-jre-headless
sudo apt install mongodb-org
sudo apt install elasticsearch
# Descargar e instalar Graylog desde repositorio oficial

## 8. RECOMENDACIONES ESTRATÉGICAS

Las siguientes acciones están organizadas por prioridad temporal y nivel de impacto en la seguridad, disponibilidad y automatización del sistema SNAS.

### 🎯 Inmediatas (48 horas)

- Cambiar el puerto SSH por uno no estándar  
- Implementar OPNsense como firewall principal  
- Desplegar Nextcloud como servicio crítico inicial  

### 📈 Medio Plazo (2–4 semanas)

- Configurar VPN segura con WireGuard  
- Activar monitorización con Zabbix  
- Automatizar backups con ZFS send/receive  

### 🚀 Largo Plazo (1–3 meses)

- Configurar alta disponibilidad (HA)  
- Definir y documentar un plan de recuperación ante desastres (DRP)  
- Automatizar despliegues y auditorías con Ansible  

# Recomendaciones inmediatas
sudo nano /etc/ssh/sshd_config
# Port 6022

sudo iptables -A INPUT -p tcp --dport 6022 -j ACCEPT

# Desplegar OPNsense en VM-100
# Configurar WAN/LAN, reglas base y VLANs

# Desplegar Nextcloud en contenedor LXC
# Montar dataset nas/nc
# Configurar proxy inverso con SSL/TLS

# Recomendaciones medio plazo
# Instalar y configurar WireGuard
sudo apt install wireguard

# Instalar Zabbix Agent
sudo apt update
sudo apt install zabbix-agent
sudo systemctl enable zabbix-agent
sudo systemctl start zabbix-agent

# Automatizar backups
zfs send nas/bkp@snapshot | ssh backuphost zfs receive backupnas/bkp

# Recomendaciones largo plazo
# Configurar DRP documentado en /root/secureSNAS/
# Crear playbooks Ansible para servicios críticos
ansible-playbook deploy-nextcloud.yml
ansible-playbook hardening.yml

## 9. CONCLUSIÓN EJECUTIVA

El Proyecto SNAS presenta una base técnica robusta, una arquitectura bien definida y una metodología de implementación por fases que garantiza reproducibilidad, seguridad y escalabilidad.

La auditoría inicial ha validado el estado óptimo del hardware y del pool ZFS. Sin embargo, antes de exponer servicios al entorno de producción, es imprescindible aplicar las medidas de seguridad base.

**Recomendación principal:**  
Iniciar de inmediato la Fase 1 (Seguridad Base), seguida por la implementación de OPNsense como firewall y Nextcloud como servicio crítico inicial.

**Estado actual:**  
✅ LISTO PARA INICIAR FASE 1 DE IMPLEMENTACIÓN

# Validación final del estado del sistema
zpool status
zfs list
uptime
free -h
df -h

# Confirmación de servicios críticos
systemctl status ssh
systemctl status zabbix-agent
systemctl status zfs-auto-snapshot

# Preparación para despliegue
# Verificar conectividad y acceso remoto
ping -c 4 firewall.local
ping -c 4 nextcloud.local

# Revisión de documentación
ls /root/secureSNAS/
cat /root/secureSNAS/auditoria_inicial.md
cat /root/secureSNAS/plan_implementacion.md

Proyecto SecureNAS - https://github.com/innova-consultoria/SecureNAS-by-victor31416

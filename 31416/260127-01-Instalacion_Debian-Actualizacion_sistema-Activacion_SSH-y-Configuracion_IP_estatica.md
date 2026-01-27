# 001 - Instalación y Configuración de Debian 13 como Servidor - Actualización del Sistema - SSH e IP estática

## 📋 Tabla de Contenidos
1. [🚀 Preparación e Instalación](#-preparación-e-instalación)
2. [💻 Configuración Inicial desde la Terminal Local](#-configuración-inicial-desde-la-terminal-local)
3. [🔐 Acceso por SSH y Configuración como Root](#-acceso-por-ssh-y-configuración-como-root)
4. [🌐 Configuración de IP Estática](#-configuración-de-ip-estática)
5. [✅ Verificación y Pruebas Finales](#-verificación-y-pruebas-finales)
6. [📝 Notas Importantes](#-notas-importantes)

---

## 🚀 Preparación e Instalación

### Preparación del Medio de Instalación
Para la instalación de Debian 13 se utilizó un USB preparado con **Ventoy**, una herramienta que permite arrancar múltiples imágenes ISO desde un mismo dispositivo USB.

**Proceso de preparación del USB:**
1. Descargar e instalar Ventoy en el USB
2. Copiar la imagen ISO de Debian 13 en el USB
3. Arrancar el servidor desde el USB
4. Seleccionar "Instalación gráfica" del menú de Ventoy

### Configuración Durante la Instalación

#### 1. Configuración Regional
| Parámetro | Valor Configurado | Notas |
|-----------|-------------------|-------|
| Idioma | Español | |
| País | España | |
| Zona horaria | Madrid | |

#### 2. Configuración de Red
- **Nombre de host:** `pve` (introducido manualmente)
- **Nombre de dominio:** (dejado en blanco)

#### 3. Usuarios y Contraseñas
| Usuario | Configuración |
|---------|---------------|
| **root** | Contraseña establecida durante la instalación |
| **Usuario normal** | Nombre completo: Victor 3,1416<br>Nombre de usuario: victor<br>Contraseña: establecida durante instalación |

#### 4. Particionado del Disco
**Disco:** Samsung SSD de 250GB  
**Configuración:** Particionado automático sin LVM

- Método seleccionado: "Particionado guiado - usar disco completo"
- Esquema: "Todos los archivos en una partición"
- **Importante:** Opción LVM NO marcada
- Confirmación de cambios en el disco

#### 5. Selección de Paquetes
Durante la instalación se seleccionaron únicamente:
- ❌ Entorno de escritorio Debian (Deseleccionar)
- ✅ Servidor SSH (para acceso remoto)
- ✅ Utilidades del sistema estándar (herramientas básicas)

#### 6. Configuraciones Finales
- No apareció la opción de instalar GRUB (posiblemente omitida o automática)
- Se seleccionó NO participar en las estadísticas de paquetes
- Para actualizaciones: se configuró usar el servidor FTP de España

---

## 💻 Configuración Inicial desde la Terminal Local

### Primer Acceso al Sistema
Una vez completada la instalación y reiniciado el sistema, se accedió directamente a la terminal del servidor.

**Login inicial:**
```bash
root
```

Password: [contraseña establecida durante instalación]

### Actualización del Sistema
Es fundamental actualizar el sistema inmediatamente después de la instalación para obtener las últimas correcciones de seguridad y actualizaciones de paquetes.

**Comandos ejecutados:**
```bash
# Actualizar lista de paquetes disponibles
apt update

# Actualizar todos los paquetes instalados
apt upgrade -y
```

### Instalación de Herramientas Básicas
Se instalaron herramientas esenciales para la administración del sistema:

```bash
# Instalar editores, herramientas de red y utilidades de sistema
apt install -y vim nano curl wget htop net-tools tmux screen git
```

**Herramientas instaladas:**

| Paquete | Propósito | Uso Común |
|---------|-----------|-----------|
| **vim** | Editor de texto avanzado y modal | `vim archivo.conf` - Editar archivos de configuración |
| **nano** | Editor de texto simple e intuitivo | `nano /etc/network/interfaces` - Edición rápida |
| **curl** | Cliente para transferencia de datos URL | `curl -I https://google.com` - Ver encabezados HTTP |
| **wget** | Herramienta para descargar archivos web | `wget https://ejemplo.com/archivo.tar.gz` - Descargas |
| **htop** | Monitor de procesos interactivo | `htop` - Ver procesos, CPU, memoria en tiempo real |
| **net-tools** | Utilidades clásicas de red | `ifconfig`, `netstat`, `route` - Diagnóstico de red |
| **tmux** | Multiplexor de terminales | `tmux new -s sesion1` - Múltiples terminales en una |
| **screen** | Alternativa a tmux para sesiones persistentes | `screen -S backup` - Mantener procesos tras desconexión |
| **git** | Sistema de control de versiones | `git clone https://github.com/usuario/repo.git` |

### Activación del Servicio SSH
Para permitir el acceso remoto al servidor, se habilitó el servicio SSH:

```bash
# Habilitar SSH para que se inicie automáticamente al arrancar
systemctl enable ssh

# Iniciar el servicio SSH inmediatamente
systemctl start ssh

# Verificar el estado del servicio
systemctl status ssh
```

### Identificación de la IP Asignada
Para poder conectarse remotamente, fue necesario identificar la IP que DHCP había asignado al servidor:

```bash
# Mostrar todas las interfaces de red y sus direcciones IP
ip addr show
```

**Información obtenida:**
- Interfaz principal: `enp1s0`
- IP asignada por DHCP: `192.168.1.100`
- Máscara de red: `/24` (255.255.255.0)

## 🔐 Acceso por SSH y Configuración como Root

### Conexión SSH desde otro Equipo
Desde un equipo en la misma red local, se estableció la conexión SSH:

```bash
# Comando ejecutado en el equipo cliente
ssh victor@192.168.1.100
```

**Proceso de conexión:**
1. Primera conexión: aceptar la huella digital del servidor
2. Introducir la contraseña del usuario `victor`
3. Conexión establecida exitosamente

### Cambio a Usuario Root
Dentro de la sesión SSH, se cambió al usuario root para realizar configuraciones de sistema:

```bash
# Cambiar a usuario root
su root
``````

### Introducir la contraseña de root
Password: [contraseña de root]


**Nota importante:** Todos los comandos de configuración posteriores se ejecutaron desde esta sesión SSH como usuario root.

## 🌐 Configuración de IP Estática

### Fase 1: Preparación y Backup

#### Verificación del Estado Actual de Red
Antes de realizar cambios, se verificó la configuración actual de red:

```bash
# Mostrar todas las interfaces de red disponibles
ip link show

# Ver detalles específicos de la interfaz principal
ip addr show enp1s0

# Ver la tabla de enrutamiento actual
ip route show

# Ver la configuración DNS actual
cat /etc/resolv.conf
```

**Información recopilada:**
- Interfaz activa: `enp1s0`
- IP actual: `192.168.1.100/24` (dinámica, DHCP)
- Gateway: `192.168.1.1`
- DNS: Configurado por DHCP

#### Configurar IP de Rescate
Para evitar perder acceso al servidor durante la configuración, se añadió una IP secundaria:

```bash
# Agregar IP secundaria en la misma red
ip addr add 192.168.1.101/24 dev enp1s0 label enp1s0:rescue

# Verificar que la IP se agregó correctamente
ip addr show enp1s0
```

**Propósito de la IP de rescate:** Proporcionar un método alternativo de acceso en caso de que la configuración estática falle.

### Fase 2: Prueba de Configuración Estática

#### Script de Prueba Temporal
Se creó un script para probar la configuración estática sin hacer cambios permanentes:

```bash
# Crear script de prueba
cat > /tmp/network-test.sh << 'EOF'
#!/bin/bash
echo "=== PRUEBA CONFIGURACIÓN IP ESTÁTICA ==="

# Limpiar configuración actual
ip addr flush dev enp1s0

# Configurar IP estática
ip addr add 192.168.1.100/24 dev enp1s0
ip route add default via 192.168.1.1

# Configurar DNS temporal con Movistar y Cloudflare
echo "nameserver 80.58.61.250" > /etc/resolv.conf
echo "nameserver 1.1.1.1" >> /etc/resolv.conf

# Probar conectividad con ping a Router y Google
echo "Probando conectividad..."
ping -c 3 192.168.1.1
ping -c 3 8.8.8.8
nslookup google.com
EOF

# Hacer ejecutable el script
chmod +x /tmp/network-test.sh

# Ejecutar la prueba
/tmp/network-test.sh
```

**Resultado de la prueba:** ✅ Todo funcionó correctamente, confirmando que la configuración estática era viable.

### Fase 3: Configuración Permanente

#### Backup de Configuración Actual
Antes de modificar la configuración de red, se creó un backup:

```bash
# Crear backup con timestamp
cp /etc/network/interfaces /etc/network/interfaces.backup.$(date +%Y%m%d_%H%M%S)

# Confirmar creación del backup
echo "Backup creado: /etc/network/interfaces.backup.*"
```

#### Crear Nueva Configuración Estática
Se configuró la IP estática permanentemente en el archivo de configuración:

```bash
# Configurar IP estática permanente
cat > /etc/network/interfaces << 'EOF'
# Loopback interface
auto lo
iface lo inet loopback

# Primary network interface - STATIC
auto enp1s0
iface enp1s0 inet static
    address 192.168.1.100
    netmask 255.255.255.0
    gateway 192.168.1.1
    dns-nameservers 80.58.61.250 1.1.1.1
EOF

# Verificar el contenido del archivo creado
cat /etc/network/interfaces
```

### Fase 4: Desactivación de DHCP

#### Identificar y Detener Procesos DHCP
Para evitar conflictos, se identificaron y detuvieron los procesos DHCP:

```bash
# Buscar procesos DHCP activos en el sistema
ps aux | grep -i dhc

# Si se encuentran procesos dhcpcd, detenerlos
if pgrep dhcpcd >/dev/null 2>&1; then
    echo "Deteniendo dhcpcd..."
    pkill dhcpcd
fi
```

#### Configurar DNS Permanente
Se estableció una configuración DNS estática:

```bash
# Configurar DNS estático
cat > /etc/resolv.conf << 'EOF'
# Static DNS configuration
nameserver 80.58.61.250
nameserver 1.1.1.1
EOF

# Verificar la configuración DNS
cat /etc/resolv.conf
```

### Fase 5: Aplicación de Cambios

#### Aplicar Configuración Estática
Finalmente, se aplicaron los cambios reiniciando el servicio de red:

```bash
# Reiniciar servicio de red para aplicar cambios
systemctl restart networking

# Esperar unos segundos para que se estabilice la configuración
sleep 5
```

## ✅ Verificación y Pruebas Finales

### Verificación de Configuración Aplicada

#### Comprobar Configuración IP
```bash
echo "=== Verificando IP estática ==="
ip addr show enp1s0
```

**Indicadores de éxito:**
- ✅ Muestra `scope global enp1s0`
- ✅ Muestra `valid_lft forever preferred_lft forever`
- ❌ **NO** muestra tiempos de expiración como `valid_lft 86399sec`

#### Comprobar Configuración de Rutas
```bash
echo "=== Verificando rutas ==="
ip route show
```

**Indicadores de éxito:**
- ✅ Muestra `default via 192.168.1.1 dev enp1s0`
- ❌ **NO** muestra `proto dhcp` en las rutas

### Pruebas de Conectividad

#### Prueba de Gateway Local
```bash
# Probar conexión al gateway de red
ping -c 2 192.168.1.1 && echo "✓ Gateway accesible"
```

#### Prueba de Conexión a Internet
```bash
# Probar conexión a un servidor público de Google
ping -c 2 8.8.8.8 && echo "✓ Internet accesible"
```

#### Prueba de Resolución DNS
```bash
# Probar el funcionamiento del DNS
nslookup google.com && echo "✓ DNS funcionando"
```

### Verificación de Procesos DHCP
Para asegurar que DHCP no interfiera con la configuración estática:

```bash
# Verificar que no hay procesos DHCP activos
ps aux | grep -i dhc | grep -v grep
```

**Resultado esperado:** No debe mostrar ningún proceso DHCP activo.

### Información para Conexiones Futuras
```bash
echo "=== INFORMACIÓN DE CONEXIÓN ==="
echo "Hostname: $(hostname)"
echo "IP Principal: 192.168.1.100"
echo "IP de Rescate: 192.168.1.101"
echo "Usuario SSH: victor"
echo "Comando: ssh victor@192.168.1.100"
```

### Comando para apagar el sistema correctamente

Apagado limpio gestionando init con systemctl sin mensajes de error
```bash
systemctl poweroff
```

## 📝 Notas Importantes

### Resumen del Proceso Realizado
| Paso | Acción | Método | Estado |
|------|--------|--------|--------|
| 1 | Instalación del sistema | USB Ventoy (modo gráfico) | ✅ Completado |
| 2 | Configuración básica | Durante instalación | ✅ Completado |
| 3 | Activación de SSH | Terminal local | ✅ Completado |
| 4 | Conexión remota | SSH desde otro equipo | ✅ Completado |
| 5 | Configuración IP estática | Por SSH como root | ✅ Completado |
| 6 | Verificación final | Comandos SSH | ✅ Completado |

### Lo que SÍ se hizo correctamente:
- ✅ Instalación gráfica de Debian 13 - Completa y sin errores
- ✅ Configuración de hostname - Establecido como `pve`
- ✅ Creación de usuarios - `root` y `victor` (Victor 3,1416)
- ✅ Particionado - Automático sin LVM
- ✅ Selección de paquetes - Solo servidor SSH y utilidades
- ✅ Activación SSH - Inmediatamente después de instalación
- ✅ Configuración de red - Realizada de forma segura por SSH
- ✅ IP estática - Configurada y verificada correctamente

### Errores Comunes Evitados:
- ❌ No perder acceso durante configuración - Se usó IP de rescate
- ❌ No sobreescribir configuración sin backup - Backup creado
- ❌ No ignorar procesos DHCP activos - Verificados y detenidos
- ❌ No asumir que funciona - Todas las pruebas ejecutadas

### Comandos de Rescate (en caso de problemas)

**Opción 1: Usar la IP de rescate**
```bash
ssh victor@192.168.1.101
```

**Opción 2: Restaurar configuración anterior**
```bash
# Desde la terminal local del servidor o por IP de rescate
cp /etc/network/interfaces.backup* /etc/network/interfaces
systemctl restart networking
```

### Configuración Final del Sistema
| Parámetro | Valor Configurado |
|-----------|-------------------|
| Sistema Operativo | Debian 13 (Bookworm) |
| Hostname | `pve` |
| Usuario principal | `victor` |
| IP Estática | `192.168.1.100/24` |
| IP de Rescate | `192.168.1.101/24` |
| Gateway | `192.168.1.1` |
| DNS Primario | `80.58.61.250` |
| DNS Secundario | `1.1.1.1` |
| Servicio SSH | Activado y funcionando |

---
**Documentación creada por:** Victor 3,1416  
**Fecha de creación:** 27/01/2026  
**Última actualización:** 27/01/2026 11:30  
**Sistema:** Debian 13 (Bookworm)  
**Estado:** ✅ Configuración completada y verificada  

*Esta documentación refleja el proceso REAL seguido durante la instalación y configuración del servidor.*

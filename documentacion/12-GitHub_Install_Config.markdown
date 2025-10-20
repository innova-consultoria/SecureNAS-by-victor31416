# 🧩 INSTALACIÓN Y CONFIGURACIÓN (GitHub en Debian) 
PROYECTO SNAS (Secure Network Attached Storage)

📅 Fecha: 20 de octubre de 2025

🔍 Auditoría realizada por: Consultoría Innova

## Guía técnica reproducible para sincronización local y remota

Este documento explica cómo instalar Git, configurar el entorno local en Debian, y sincronizar un repositorio GitHub paso a paso. Está basado en la instalación real del proyecto SecureNAS en `/root/GitHub_SNAS/`.

---

## 1. Instalación de Git y dependencias

```bash
apt update
apt install git curl -y
```

## 2. Configuración de identidad Git

```bash
git config --global user.name "innova-consultoria"
git config --global user.email "innova.satmadrid@gmail.com"
```

Puedes verificarlo con:

```bash
git config --list
```

## 3. Creación de directorio local y permisos

```bash
mkdir -p /root/GitHub_SNAS
chmod 700 /root/GitHub_SNAS
cd /root/GitHub_SNAS
```

Este directorio contendrá el repositorio clonado y debe tener acceso restringido.

## 4. Autenticación con GitHub

### Opción A: Token personal (recomendado para HTTPS)
- Ve a GitHub → Settings → Developer settings → Personal access tokens
- Crea un token con permisos repo y workflow
- Guarda el token en un gestor seguro

### Opción B: Usuario + contraseña (obsoleto)
GitHub ha deshabilitado la autenticación por contraseña para operaciones Git. Usa token o SSH.

## 5. Clonación del repositorio desde GitHub

```bash
git clone https://<TOKEN>@github.com/innova-consultoria/SecureNAS-by-victor31416.git GitHub_SNAS
cd GitHub_SNAS
```

🔐 Sustituye `<TOKEN>` por tu token personal. Ejemplo:

```bash
https://ghp_abc123xyz456@github.com/innova-consultoria/SecureNAS-by-victor31416.git
```

## 6. Verificación del estado del repositorio

```bash
git status
git branch
```

Salida esperada:

```
En la rama main
Tu rama está actualizada con 'origin/main'.
```

## 7. Sincronización desde el sistema (local → remoto)

```bash
git add .
git commit -m "Actualización desde Debian"
git push origin main
```

## 8. Sincronización desde la web (remoto → local)

```bash
git pull origin main
```

Esto traerá los últimos cambios realizados desde GitHub Web o por otros colaboradores.

## 9. Sincronización dual (bidireccional)

Para mantener el sistema sincronizado en ambas direcciones:

```bash
# Paso 1: Obtener cambios remotos
git pull origin main

# Paso 2: Aplicar cambios locales
git add .
git commit -m "Cambios locales"
git push origin main
```

## 10. Verificación del historial de commits

```bash
git log --oneline --graph --decorate
```

Esto muestra el árbol de commits y confirma que estás sincronizado con origin/main.

## 11. Automatización opcional (cron diario)

```bash
crontab -e
```

Agrega la siguiente línea para sincronizar cada día a las 03:00:

```bash
0 3 * * * cd /root/GitHub_SNAS/SecureNAS-by-victor31416 && git pull origin main && git add . && git commit -m "Sync automático" && git push origin main
```

## 12. Buenas prácticas
- Usa mensajes de commit descriptivos
- Verifica siempre el estado antes de hacer push
- No edites directamente desde GitHub Web y desde Debian al mismo tiempo sin hacer pull
- Protege tu token personal y no lo compartas
- Documenta cada cambio relevante en el repositorio

## 13. Referencia del entorno real
- Sistema: Debian 12
- Usuario: root
- Ruta local: /root/GitHub_SNAS/SecureNAS-by-victor31416
- Repositorio: SecureNAS-by-victor31416
- Rama principal: main
- Autenticación: token personal GitHub

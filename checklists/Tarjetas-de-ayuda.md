# 🧪 Tarjetas de ayuda — Proyecto SNAS

Guía rápida de comandos técnicos organizados por función. Cada tarjeta incluye una descripción sencilla, etiquetas temáticas, comandos útiles y espacio para documentación visual.

---

## 🔧 Diagnóstico de discos

**Soluciona:** Verifica el estado físico y lógico de los discos duros y SSD. Detecta errores SMART, sectores defectuosos y estado del pool ZFS.

**Etiquetas:** `discos`, `smartctl`, `zfs`, `almacenamiento`, `diagnóstico`

**Captura sugerida:** `images/diagnostico-discos.png`

**Información técnica que ofrece:**
- Estado SMART de cada disco
- Errores ATA, sectores reasignados
- Estado del pool ZFS (`status`, `scrub`)

**Comandos:**
```bash
smartctl -a /dev/sda
zpool status
zpool scrub storage

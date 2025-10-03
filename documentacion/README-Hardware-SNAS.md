# 🖥️ Estado Actual del Hardware - Proyecto SecureNAS

**Última actualización:** Octubre 2025  
**Auditoría ejecutada:** `SNAS-Auditoria-v2.2-Almacenamiento.sh`  
**Autor:** victor31416  
**Repositorio:** [SecureNAS-by-victor31416](https://github.com/innova-consultoria/SecureNAS-by-victor31416)

---

## 📋 Resumen técnico del equipo físico

| Componente        | Estado actual                         | Observación técnica |
|-------------------|----------------------------------------|---------------------|
| **Plataforma**    | MSI B150 + Intel i7-6700               | Confirmado como host físico |
| **RAM instalada** | 2×8 GB DDR4 (15.9 GB reconocidos)      | Ambos módulos activos |
| **Discos IronWolf** | sda, sdb, sdc → ST4000VN006-3CW104    | 3.6 TB cada uno, sin errores SMART |
| **SSD Kingston**  | SUV400S37120G (111.8 GB)               | Operativo, desgaste progresivo |
| **SSD EMTEC**     | ❌ Retirado del sistema                | Inconsistencias detectadas |
| **Swap**          | 2 GB asignado, 0 MB usado              | RAM suficiente para carga actual |
| **Virtualización**| `systemd-detect-virt: none`            | Host físico confirmado |
| **Red**           | 1 Gbps estable                         | Sin errores detectados |
| **Monitorización**| Netdata activo                         | Integrado en auditoría |
| **ZFS / RAID**    | No configurado actualmente             | Sin pools ni arrays activos |

---

## 🔄 Comparativa de estado (antes vs. ahora)

| Componente        | Estado anterior                        | Estado actual                          |
|-------------------|----------------------------------------|----------------------------------------|
| **RAM**           | 1×8 GB (slot único activo)             | 2×8 GB (ambos slots activos)           |
| **SSD EMTEC**     | Presente, con errores SMART            | ❌ Retirado                            |
| **IronWolf**      | sda y sdb activos, sdc en revisión     | sda, sdb, sdc activos y auditados      |
| **Virtualización**| No confirmada                          | Confirmado como host físico            |
| **Auditoría**     | Script v1.0                            | Script v2.2 Profesional                |

---

## 🧠 Observaciones técnicas

- La memoria ha sido ampliada y correctamente reconocida por el sistema.
- El SSD EMTEC ha sido retirado por inconsistencias y no forma parte del sistema actual.
- Los discos IronWolf están en buen estado, sin sectores reasignados ni errores críticos.
- El SSD Kingston sigue operativo, pero se recomienda monitorear su desgaste.
- El sistema no utiliza swap, lo que indica buena disponibilidad de RAM.
- No se han configurado pools ZFS ni arrays RAID en esta fase del proyecto.

---

## 🧩 Recomendaciones

- Mantener monitoreo SMART activo con alertas predictivas.
- Planificar reemplazo del SSD si la vida útil baja del 20%.
- Documentar cambios físicos tras cada auditoría.
- Evitar pruebas intensivas en discos del sistema (`/dev/sda`).
- Considerar ZFS o RAID si se requiere redundancia futura.

---

**Este documento forma parte del módulo técnico de auditoría de almacenamiento del proyecto SecureNAS.**  
Para más información, consulta el script principal en [`scripts/SNAS-Auditoria-v2.2-Almacenamiento.sh`](../scripts/SNAS-Auditoria-v2.2-Almacenamiento.sh).

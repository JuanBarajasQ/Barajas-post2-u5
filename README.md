
# Laboratorio: Creación y Gestión de Máquinas Virtuales en VirtualBox
Este proyecto documenta la configuración técnica de una máquina virtual funcional utilizando Alpine Linux, explorando diferentes modos de red, gestión de estados mediante snapshots y exportación de artefactos virtuales.

* **Estudiante:** Juan Carlos Barajas Quintero 
* **Curso:** Arquitectura de Computadores - Unidad 5
* **Institución:** Universidad Francisco de Paula Santander

## 1. Descripción de la Máquina Virtual (VM)
La máquina virtual fue configurada con parámetros minimalistas para optimizar el uso de recursos, siguiendo las especificaciones del laboratorio:

*   **Sistema Operativo (SO):** Alpine Linux 3.19 (Edición Standard).
*   **Memoria RAM:** 1024 MB (1 GB).
*   **Disco Duro:** 10 GB en formato VDI con asignación dinámica.
*   **Procesador:** 1 CPU asignada.

## 2. Tabla de Direccionamiento IP por Modo de Red
Se configuraron y verificaron tres modos de red distintos para observar su comportamiento técnico y conectividad. Las capturas de pantalla de estas configuraciones se encuentran en el repositorio adjunto.

| Modo de Red | Dirección IP Obtenida | Acceso a Internet | Comunicación con Anfitrión |
| :--- | :--- | :--- | :--- |
| **NAT** | 10.0.2.15 (típica) | Sí | Sí (vía gateway 10.0.2.2) |
| **Host-Only** | 192.168.56.101 (Rango 192.168.56.x) | No | Sí (red aislada) |
| **Bridge** | 192.168.1.36 (Asignada por DHCP local) | Sí | Sí (misma red física) |

## 3. Árbol de Snapshots
Para garantizar la reproducibilidad y permitir experimentación segura, se gestionó el siguiente árbol de estados:

*   **snap_base:** Estado inicial del sistema con Alpine Linux 3.19 recién instalado, sin modificaciones adicionales.
    *   **snap_con_herramientas:** Snapshot tomado tras la instalación de paquetes adicionales (`curl`, `wget`, `nano` e `htop`).

*Nota: Se verificó la restauración exitosa al snapshot base para confirmar la eliminación del software adicional.*

## 4. Conclusiones Técnicas
*   **Aislamiento vs. Conectividad:** Se determinó que el modo **NAT** es ideal para actualizaciones de software rápidas, mientras que **Host-Only** permite un entorno de desarrollo seguro y aislado del tráfico externo.
*   **Gestión de Estados:** Los **snapshots** demostraron ser fundamentales para la persistencia en laboratorios, permitiendo guardar el estado completo de la RAM y el disco para revertir cambios accidentales o fallos de configuración.
*   **Portabilidad Estándar:** El uso del formato **OVF/OVA** es crítico para la entrega de evidencia técnica, ya que consolida metadatos y discos en un único archivo portable entre diferentes hipervisores como VMware o VirtualBox.

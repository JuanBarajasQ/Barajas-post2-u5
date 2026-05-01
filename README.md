
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

## 2. Documentación del Proceso
El laboratorio se desarrolló en cinco fases críticas para asegurar un despliegue profesional:

1.  **Creación de la VM:** Configuración de parámetros de hardware mediante la interfaz de VirtualBox y comandos `VBoxManage`.
2.  **Instalación del SO:** Uso del script `setup-alpine` para configurar el teclado, hostname, red (DHCP), zona horaria y particionado de disco (modo `sys`).
3.  **Configuración de Red:** Experimentación secuencial con modos NAT, Host-Only y Bridge para verificar el direccionamiento IP y la salida a internet.
4.  **Gestión de Estados:** Captura de snapshots en caliente para registrar el estado base y el estado con herramientas instaladas (`curl`, `wget`, `nano`, `htop`).
5.  **Exportación:** Generación de un artefacto portable en formato **OVA** para distribución externa.

## 3. Tabla de Direccionamiento IP por Modo de Red
Se configuraron y verificaron tres modos de red distintos para observar su comportamiento técnico y conectividad. Las capturas de pantalla de estas configuraciones se encuentran en el repositorio adjunto.

| Modo de Red | Dirección IP Obtenida | Acceso a Internet | Comunicación con Anfitrión |
| :--- | :--- | :--- | :--- |
| **NAT** | 10.0.2.15 (típica) | Sí | Sí (vía gateway 10.0.2.2) |
| **Host-Only** | 192.168.56.101 (Rango 192.168.56.x) | No | Sí (red aislada) |
| **Bridge** | 192.168.1.36 (Asignada por DHCP local) | Sí | Sí (misma red física) |

## 4. Árbol de Snapshots
Para garantizar la reproducibilidad y permitir experimentación segura, se gestionó el siguiente árbol de estados:

*   **snap_base:** Estado inicial del sistema con Alpine Linux 3.19 recién instalado, sin modificaciones adicionales.
    *   **snap_con_herramientas:** Snapshot tomado tras la instalación de paquetes adicionales (`curl`, `wget`, `nano` e `htop`).

*Nota: Se verificó la restauración exitosa al snapshot base para confirmar la eliminación del software adicional.*

## 5. Conclusiones Técnicas

### Sobre los Modos de Red
*   **Aislamiento vs. Funcionalidad:** El modo **NAT** es la opción más segura y sencilla para que la VM tenga internet sin exponerla a la red local. Sin embargo, para tareas de administración remota desde el anfitrión, el modo **Host-Only** es superior al crear un canal de comunicación directo y privado, aunque carezca de salida a internet. El modo **Bridge** es el más potente para servicios que deben ser visibles en la red física, comportándose la VM como un dispositivo independiente.
*   **Dependencia de Infraestructura:** Se observó que mientras NAT y Host-Only dependen exclusivamente del hipervisor, el modo Bridge depende de la existencia de un servidor DHCP en la red física local para asignar una IP válida.

### Sobre el Uso de Snapshots
*   **Seguridad en el Aprendizaje:** Los snapshots demostraron ser una herramienta crítica en entornos de laboratorio. Permiten la experimentación destructiva (como modificar archivos críticos del sistema) con la garantía de poder regresar a un estado funcional en segundos, ahorrando el tiempo de una reinstalación completa.
*   **Persistencia Integral:** A diferencia de un respaldo de archivos simple, el snapshot captura no solo el disco, sino también el estado de la **memoria RAM** y el procesador, permitiendo reanudar el trabajo exactamente donde se dejó.

## 6. Estructura del Repositorio
*   `capturas/`: Evidencias visuales de cada checkpoint del laboratorio.
*   `VBoxManage_commands.sh`: Script con todos los comandos ejecutados.
*   `README.md`: Documentación completa.
   
*Nota: El archivo .ova generado (Lab5-Alpine-export.ova) no se incluye en el repositorio debido a su tamaño, conforme a las instrucciones del laboratorio.*



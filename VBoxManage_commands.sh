#CHECKPOINT 1 CREAR LA VM 
#Crear la VM con VBoxManage (línea de comandos)
VBoxManage createvm --name "Lab5-Alpine" --ostype "Linux_64" --register
VBoxManage modifyvm "Lab5-Alpine" ^
 --memory 1024 --vram 16 ^
 --cpus 1 ^
 --nic1 nat
VBoxManage createmedium disk ^
 --filename "Lab5-Alpine.vdi" ^
 --size 10240 ^
 --format VDI
VBoxManage storagectl "Lab5-Alpine" --name "SATA" --add sata
VBoxManage storageattach "Lab5-Alpine" ^
 --storagectl "SATA" --port 0 --device 0 ^
 --type hdd --medium "Lab5-Alpine.vdi"
VBoxManage storagectl "Lab5-Alpine" --name "IDE" --add ide
VBoxManage storageattach "Lab5-Alpine" ^
 --storagectl "IDE" --port 0 --device 0 ^
 --type dvddrive --medium "alpine-standard-3.19.0-x86_64.iso"

#CHECKPOINT 2 INSTALACION
# Al arrancar desde el ISO, Alpine inicia en modo live con usuario root
localhost:~# setup-alpine
# El script solicita las siguientes configuraciones:
# Keyboard layout: us (teclado en inglés para compatibilidad)
# Variant: (Enter para dejar vacío)
# Hostname: lab5-vm
# Network interface: eth0
# IP address: dhcp (obtener IP automáticamente via NAT)
# DNS nameserver: 8.8.8.8
# Root password: [definir una contraseña segura]
# Timezone: America/Bogota
# Proxy: none
# NTP client: chrony
# Mirror: 1 (primer espejo de la lista)
# SSH server: openssh
# Disk to use: sda
# How to use disk: sys (instalación completa en disco)
# Confirmar borrado del disco: y
# Esperar la instalación (~2 minutos)
# Al finalizar, apagar la VM y retirar el ISO
localhost:~# poweroff

#CHECKPOINT 3 CONFIGURACIONES DE MODOS DE RED
# Apagar la VM antes de cambiar la configuración de red
VBoxManage controlvm "Lab5-Alpine" poweroff
# Modo 1: NAT (predeterminado — ya configurado)
# La VM accede a internet a través del anfitrión
# IP típica: 10.0.2.15 / Gateway: 10.0.2.2
# Modo 2: Host-Only (red aislada VM ↔ anfitrión, sin internet)
# Primero crear una interfaz Host-Only si no existe:
VBoxManage hostonlyif create
# Asignar la red Host-Only a la NIC de la VM:
VBoxManage modifyvm "Lab5-Alpine" --nic1 hostonly --hostonlyadapter1
"vboxnet0"
# Iniciar VM, verificar IP (rango 192.168.56.x)
# Desde el anfitrión: ping 192.168.56.101 debe responder
# Desde la VM: ping 8.8.8.8 debe fallar (sin internet en Host-Only)
# Modo 3: Bridge (VM conectada directamente a la red física del
anfitrión)
VBoxManage modifyvm "Lab5-Alpine" --nic1 bridged --bridgeadapter1
"Ethernet"
# La VM obtiene IP del router de la red local (DHCP)
# Verificar con: ip addr show eth0 dentro de la VM

#CHECKPOINT 4 SNAPSHOTS
# La VM debe estar encendida para tomar un snapshot en caliente
# (con contenido de RAM incluido)
# Tomar snapshot del estado base (Alpine recién instalado)
VBoxManage snapshot "Lab5-Alpine" take "snap_base" ^
 --description "Alpine Linux 3.19 recién instalado, sin modificaciones"
# Instalar software adicional dentro de la VM
# (conectar a NAT primero si se estaba usando Host-Only)
lab5-vm:~# apk update
lab5-vm:~# apk add curl wget nano htop
# Tomar segundo snapshot con el software instalado
VBoxManage snapshot "Lab5-Alpine" take "snap_con_herramientas" ^
 --description "Alpine con curl, wget, nano y htop instalados"
# Verificar la lista de snapshots
VBoxManage snapshot "Lab5-Alpine" list
# Restaurar al estado base (sin desinstalar el software manualmente)
VBoxManage controlvm "Lab5-Alpine" poweroff
VBoxManage snapshot "Lab5-Alpine" restore "snap_base"
VBoxManage startvm "Lab5-Alpine" --type gui
# Verificar que curl ya no está disponible (apk info curl devuelve
vacío)

#CHECKPOINT 5 EXPORTAR OVA
# Apagar la VM antes de exportar
VBoxManage controlvm "Lab5-Alpine" poweroff
# Exportar la VM en formato OVA (OVF comprimido, un solo archivo)
VBoxManage export "Lab5-Alpine" ^
 --output "Lab5-Alpine-export.ova" ^
 --manifest ^
 --options manifest
# Verificar el archivo exportado
dir Lab5-Alpine-export.ova # Windows
ls -lh Lab5-Alpine-export.ova # Linux/macOS
# El archivo .ova puede importarse en otra instalación de VirtualBox o
VMware
# con: VBoxManage import Lab5-Alpine-export.ova

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
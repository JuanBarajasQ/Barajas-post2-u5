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
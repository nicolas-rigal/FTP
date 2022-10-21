#met a jour les programes et instale un synchonisateur de fichier 
sudo apt update && sudo apt-get install rsync

#permet d'afficher la date selon le format que l'on souhaite
d=$(date +%d-%m-%Y-%H-%M)

case 
sudo rsync -agloprtz /* jerome@192.168.87.1:C:\Users\jerom\Desktop\Backup-$d.tar.gz

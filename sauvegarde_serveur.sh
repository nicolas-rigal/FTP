#met a jour les programes et instale un synchonisateur de fichier 
sudo apt update && sudo apt-get install rsync

#permet d'afficher la date selon le format que l'on souhaite
d=$(date +%d-%m-%Y-%H-%M)

case 
sudo rsync -agloprtz /* nicolas@10.10.66.246:C:\Users\nicolas\Desktop\Backup-$d.tar.gz
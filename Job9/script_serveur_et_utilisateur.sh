#!/binbash

#Cette commande permet de définir le séparateur de tableau comme étant une virgule
export IFS=","

#cat permet de lire le fichier csv 
#while read créer une boucle pour recupére les information quil contien

#BOUCLE
#sudo useradd créer des utilisateurs aveec les  variables du tableau
#echo et sudo chpasswd définir des mots de passe grace aux variables du tableau
#sudo usermod permet ici grâce à l'option -u de créer des UID, celles ci correspond à celles du tableau
#if vérifie la condition est correcte Si oui usemod -aG j'ajoute au groupe sudo 

cat /home/nicolas/Documents/job9/Shell_Userlist.csv | while read Id Prenom Nom Mdp Role	
	do
	sudo useradd -m $Prenom-$Nom
        echo "$Prenom-$Nom:$Mdp" | sudo chpasswd
        sudo usermod -u $Id "$Prenom-$Nom"
                if [ $Role = "Admin" ]
                then
                sudo usermod -aG sudo "$Prenom-$Nom"
                fi
        done

#in verifier les eventuel mise a jour des logiciels et d'instaler le mise a jour et proftpd avec tous ces paquets 
sudo apt update && sudo apt upgrade && sudo apt install proftpd-*

# on declare nos variables 
conf=$(sudo /etc/proftpd/proftpd.conf)
tls=$(sudo /etc/proftpd/tls.conf)

# on incremante notre fichier conf pour le parametre 
echo "<Anonymous ~ftp>" >> $conf
echo " User ftp" >> $conf
echo " Group nogroup" >> $conf
echo " UserAlias anonymous ftp" >> $conf
echo " DirFakeUser on ftp" >> $conf
echo " DirFakeGroup on ftp" >> $conf
echo " RequireValidShell off" >> $conf
echo " MaxClients 10" >> $conf
echo " <Directory *" >> $conf
echo "  <Limit Write>" >> $conf
echo "   DenyAll" >> $conf
echo "  </Limit>" >> $conf
echo " </Directory>" >> $conf
echo "</Anonymous>" >> $conf
echo "Include /etc/proftpd/tls.conf" >> $conf

#crée un dossier shell
sudo mkdir /etc/proftpd/shell

#crée un clée ssl 
sudo openssl req -newkey rsa:4096 -x509 -keyout /etc/proftpd/ssl/proftpd.key.pem -days 30 -nodes -out /etc/proftpd/ssl/proftpd.cert.pem 

# modifie les droits pour etre uniquement lu et ecrit 
sudo chmod 666 /etc/proftpd/ssl/proftpd.key.pem
sudo chmod 666 /etc/proftpd/ssl/proftpd.cert.pem

#incremante le fichier tls par les echo
echo "<IfModule mod_tls.c>" >> $tls
echo " TLSEngine on" >> $tls
echo " TLSLog /var/log/proftpd/tls.log" >> $tls
echo " TLSProtocol SSLv23" >> $tls
echo " TLSRSACertificateFile /etc/proftpd/ssl/proftpd.cert.pem" >> $tls
echo " TLSRSACertificateKeyFile /etc/proftpd/ssl/proftpd.key.pem" >> $tls
echo " TLSVerifyClient off" >> $tls
echo " TLSRequired on" >> $tls
echo "</IfModule>" >> $tls

#redemare le programme 
sudo /etc/init.d/proftpd restart

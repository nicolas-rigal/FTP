#!/bin/bash                                                                                                                                   
# rechercher les mises à jour les programmes installés
# installe les dernier mise a jour identifier par la commande precedent
# installe proftpd avec tous ces paquet (-* = -all)                      
sudo apt update && sudo apt upgrade && sudo apt install proftpd-*

# on declare les variables pour leur assigner les arborecences
conf=/etc/proftpd/proftpd.conf
tls=/etc/proftpd/tls.conf

# on donne un accée total au fichier precedament
sudo chmod 777 $conf
sudo chmod 777 $tls

##a retravallier pour aller code              
#répète la chaîne de caractere dans le fichier conf 
echo "<Anonymous ~ftp>" >> $conf
echo " User ftp" >> $conf
echo " Group nogroup" >> $conf
echo " UserAlias anonymous ftp" >> $conf
echo " DirFakeUser on ftp" >> $conf
echo " DirFakeGroup on ftp" >> $conf
echo " RequireValidShell off" >> $conf
echo " MaxClients 10" >> $conf
echo " <Directory *>" >> $conf
echo "  <Limit WRITE>" >> $conf
echo "   DenyAll" >> $conf
echo "  </Limit>" >> $conf
echo " </Directory>" >> $conf
echo "</Anonymous>" >> $conf
echo "Include /etc/proftpd/tls.conf" >> $conf

# on crée un dossier ssl               
sudo mkdir /etc/proftpd/ssl

#                                
# \ ajoute un saut a la lingne                          
# la chaine de caractére permet de repondre automatiquement au question 
echo -en "\n\n\n\n\n\n\n" | sudo openssl req -x509 -days 30 -newkey rsa:2048 -\
keyout /etc/proftpd/ssl/proftpd.key.pem -out /etc/proftpd/ssl/proftpd.cert.pem\

# on leur donne droit a lire et écrire                                         
sudo chmod 666 /etc/proftpd/ssl/proftpd.key.pem
sudo chmod 666 /etc/proftpd/ssl/proftpd.cert.pem

##a retravallier pour aller code                                               
#répète la chaîne de caractere dans le fichier tls                             
echo " IfModule mod_tls.c>" >> $tls
echo " TLSEngine on" >> $tls
echo " TLSLog /var/log/proftpd/tls.log" >> $tls
echo " TLSProtocol SSLv23" >> $tls
echo " TLSRSACertificateFile /etc/proftpd/ssl/proftpd.cert.pem" >> $tls
echo " TLSRSACertificateKeyFile /etc/proftpd/ssl/proftpd.key.pem" >> $tls
echo " TLSVerifyClient off" >> $tls
echo " TLSRequired on" >> $tls
echo "</IfModule>" >> $tls

# redemare proftpd
sudo /etc/init.d/proftpd restart

# on reduit les permission          
sudo chmod 644 $conf
sudo chmod 644 $tls
#!/bin/bash

#éface les dossier
rm /etc/proftpd/ssl/proftpd.cert.pem 
rm /etc/proftpd/ssl/proftp.key.pem
# suprime le paquet
sudo apt --purge remove proftpd-*

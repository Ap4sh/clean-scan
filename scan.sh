#!/bin/bash


echo -e "\nThis script will create a file named 'nmap' with the output of the final nmap scan.\n"
sleep 1
# ask for ip
read -p "IP: " ip_address

# masscan
echo -e "\nMasscan on : $ip_address...\n"
sleep 1
sudo masscan -p1-65535,U:1-65535 $ip_address --max-rate 1000 --wait=1 -e tun0 > masscan

# clean masscan output
sleep 1
awk '/Discovered open port/ {print $4}' masscan | cut -d'/' -f1 | tr '\n' ',' | sed 's/,$//' > ports
echo -e "\nPorts discovered :\n"
sleep 1
cat ports

# nmap
echo -e "\n\nnmap on discovered ports now\n"
sleep 1
sudo nmap -sC -sV -Pn -p$(/usr/bin/cat ports) -O $ip_address -A --min-rate=500 > nmap

# Clean files
rm ports masscan
echo -e "\nScan finished\n"
sleep 1
cat nmap

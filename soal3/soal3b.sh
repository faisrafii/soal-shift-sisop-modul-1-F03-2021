#!/bin/bash
bash "/home/zaki/Documents/Sisop/Shift1/soal3/soal3a.sh"
datee="%m-%d-%Y"
file=$(date +"$datee")
mkdir $file


mv Koleksi_* $file
mv Foto.log $file

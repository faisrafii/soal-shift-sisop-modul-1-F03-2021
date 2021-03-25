#!/bin/bash

namafile=" "

data_namafile () {
if [ $1 -le 9 ]
then
        namafile="Koleksi_0$1.jpg"
else
        namafile="Koleksi_$1.jpg"
fi
}


for ((i=1; i<24; i++))
do
        data_namafile "$i"
        wget -O $namafile https://loremflickr.com/320/240/kitten >> foto.log
done
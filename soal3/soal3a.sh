#!/bin/bash

for ((num=1; num<=23; num++))
do
        wget -O "Koleksi_$num.jpg" https://loremflickr.com/320/240/kitten 2>> Foto.log 
done

for ((i=1; i<=23; i++))
do
        for ((j=i+1; j<=23; j++))
        do
                cek=$(cmp "Koleksi_$i.jpg" "Koleksi_$j.jpg")
                beda=$?
                if [ $beda -eq 0 ]
                then
                        rm Koleksi_$j.jpg
                fi
        done
done

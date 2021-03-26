#!/bin/bash
data_namafile () {
if [ $1 -le 9 ]
then
        namafile="Koleksi_0$1.jpg"
fi
}

for ((i=1; i<=23; i++))
do
        wget -a Foto.log https://loremflickr.com/320/240/kitten -O "Koleksi_$i.jpg"
        for ((j=1; j<i; j++))
        do
 	      	if comm Koleksi_$i.jpg Koleksi_$j.jpg &> /dev/null
                then
                        rm Koleksi_$i.jpg
                        break
                fi
        done
done

for ((i=1; i<=23; i++))
do
	if [ ! -f Koleksi_$i.jpg ];
	then
		for ((j=23; j>i; j--))
		do
			if [ -f Koleksi_$j.jpg ];
			then
				mv Koleksi_$j.jpg Koleksi_$i.jpg
				break
			fi
		done
	fi
done

for ((i=1; i<10; i=i+1))
do
	data_namafile "$i"
	if [ -f Koleksi_$i.jpg ]
	then
		mv Koleksi_$i.jpg $namafile
	fi
done

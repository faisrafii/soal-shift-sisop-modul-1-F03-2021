#!/bin/bash

kucing(){
    size=23
    for(( i=1 ; i<=size; i++ ))
    do
    	wget -O "Koleksi_$i" -a "Foto.log" https://loremflickr.com/320/240/kitten
    	for (( j=1 ; j<i ; j++ ))
    	do
    		if [[ j -lt 10 ]]
    		then
    			if cmp -s "Koleksi_$i" "Koleksi_0$j"
    			then
    				rm "Koleksi_$i"
    				(( i-- ))
    				(( size-- ))
    			fi
    		else
    			if cmp -s "Koleksi_$i" "Koleksi_$j"
    			then
    				rm "Koleksi_$i"
    				(( i-- ))
    				(( size-- ))
    				break
    			fi
    		fi
    	done

    	if [[ i -lt 10 ]]
    	then
    		mv "Koleksi_$i" "Koleksi_0$i"
    	fi
    done



    datee="%m-%d-%Y"
    file=$(date +"$datee")
    mkdir "Kucing_$file"


    mv Koleksi_* "Kucing_$file"
    mv Foto.log "Kucing_$file"
}

kelinci(){
    size=23
    for(( i=1 ; i<=size; i++ ))
    do
    	wget -O "Koleksi_$i" -a "Foto.log" https://loremflickr.com/320/240/bunny
    	for (( j=1 ; j<i ; j++ ))
    	do
    		if [[ j -lt 10 ]]
    		then
    			if cmp -s "Koleksi_$i" "Koleksi_0$j"
    			then
    				rm "Koleksi_$i"
    				(( i-- ))
    				(( size-- ))
    			fi
    		else
    			if cmp -s "Koleksi_$i" "Koleksi_$j"
    			then
    				rm "Koleksi_$i"
    				(( i-- ))
    				(( size-- ))
    				break
    			fi
    		fi
    	done

    	if [[ i -lt 10 ]]
    	then
    		mv "Koleksi_$i" "Koleksi_0$i"
    	fi
    done



    datee="%m-%d-%Y"
    file=$(date +"$datee")
    mkdir "Kelinci_$file"


    mv Koleksi_* "Kelinci_$file"
    mv Foto.log "Kelinci_$file"
}

kucingcount=$(ls | grep "Kucing_" | wc -l)
kelincicount=$(ls | grep "Kelinci_" | wc -l)

if [[ $kucingcount -eq $kelincicount ]]
then
    kelinci
else [[ $kucingcount -ne $kelincicount ]]
    kucing
fi
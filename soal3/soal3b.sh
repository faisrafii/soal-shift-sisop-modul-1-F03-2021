#!/bin/bash
datee="%m-%d-%Y"
file=$(date +"$datee")
mkdir $file

mv *.jpg $file
mv Foto.log $file

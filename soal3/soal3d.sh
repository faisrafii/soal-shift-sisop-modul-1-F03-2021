#!/bin/bash
kolzip="%m%d%Y"
pass=$(date +"$kolzip")

zip -P $pass -r Koleksi.zip ./Koleksi*
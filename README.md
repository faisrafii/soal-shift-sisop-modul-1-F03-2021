# soal-shift-sisop-modul-1-F03-2021

## NO 1 
Pada pengerjaan soal no 1 ini, dibutuhkan data dari syslog.log. Sehingga dilakukan input file data tersebut yaitu
```
input="syslog.log"
```

### 1a
Untuk mengumpulkan informasi dari syslog berupa jenis log (ERROR/INFO), pesan log, dan username pada setiap baris lognya. Diperluakn

## NO 2 : TokoShiShop
Pada pengerjaan soal no 2 ini, dibutuhkan data TokoShiSop. Sehingga dilakukan input file data tersebut yaitu "Laporan-TokoShiSop.tsv"
```
export LC_ALL=C
input="/home/zaki/Downloads/Laporan-TokoShiSop.tsv"
```

### 2a 
Steven ingin mengetahui Row ID dan profit percentage terbesar
```
awk -F "\t" '
BEGIN{ max=0;idmax=0}
{
	{if(NR!=1)
		profitpercentage=(($21/($18-$21))*100)
		id=$1
		{if(profitpercentage>=max)
			{
				max=profitpercentage
				idmax=id
			}
		}
	}
}
END
```
- Proses akan dilakukan ketika Baris != 1
- Presentase profit didapatkan dengan membagi kolom profit dengan pengurangan sales dengan profit, kemudian dikalikan dengan 100
- Id dimulai dari angka 1
- Lalu dilakukan pengecekan untuk mendapatkan profit maksimal sampai semua data yang ada selesai dicek dengan cara setiap pengecekan apakah presentase profit lebih besar dari
  profit terbesar sekarang. Jika iya maka profit terbesar akan diubah beserta idnya, dengan inisialisasi awal profit terbesar dan id adalah 0. 

### 2b
Clemong membutuhkan daftar nama customer pada transaksi tahun 2017 di Albuquerque.
```
awk -F "\t" '
BEGIN{printf "Daftar nama customer di Albuquerque pada tahun 2017 antara lain: \n"}
{
	{if(NR!=1)
		{
			{if($10~"Albuquerque" && $3 ~ /17$/)
					a[$7]++
			}
		}
	}
}
END
```
- Proses akan dilakukan ketika Baris != 1
- Dilakukan pengecekan apakah kolom 10 atau _city_ adalah Alburquerque dan kolom 3 atau_ date _ adalah pada tahun 2017, maka _customer name_ akan disimpan ke dalam array

### 2c
Clemong membutuhkan segment customer dan jumlah transaksinya yang paling sedikit.
```
awk -F "\t" '
BEGIN{consumer=0;homeoffice=0;corp=0}
{
	{if(NR!=1)
		{
			{if($8~"Consumer")
				consumer++
			 else if($8~"Home Office")
			 	homeoffice++
			 else if($8~"Corporate")
			 	corp++;
			}
		}
	}
}
END
```
- Proses akan dilakukan ketika Baris != 1
- Dilakukan pengecekan apakah kolom 8 atau _segmen_ adalah "Consumer" bukan. Jika iya maka akan dilakukan penjumlahan variabel consumer dimana variabel tersebut berguna untuk menyimpan jumlah _segmen_ yang bertipe Customer pada data Laporan-TokoShiSop.tsv
- Pengecekan yang sama juga dilakukan untuk _segmen_ bertipe Home Office dan Corporate

### 2d
Wilayah bagian (region) yang memiliki total keuntungan (profit) paling sedikit dan total keuntungan wilayah tersebut.
```
awk -F "\t" '
BEGIN{}
{
	{if(NR!=1)
		arr[$13]+= $21
	}
}
END{
	a=0;
	{for(i in arr)
		{
			{if(a==1)
				{
					min=arr[i]
					regionmin=i
				}
			}
			
			{if(a < min)
				{
					min=arr[i]
					regionmin=i
				}
			}
			a++
		}
	}
	{printf "Wilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah %s dengan total keuntungan %.2f\n",regionmin, arr[regionmin]}
}
' "$input" >> hasil.txt
```
- Proses akan dilakukan ketika Baris != 1
- Menyimpan total profit dari setiap region dengan menggunakan array yang memiliki index region dan valuenya adalah jumlah dari profit
- Setelah semua data selesai di proses, dilanjutkan dengan pencarian total profit yang paling sedikit. Pertama diinisialisasi bahwa yang terkecil adalah region paling awal. Lalu ketika dilakukan pengecekan untuk region selanjutnya, profitnya lebih kecil dari yang sekarang maka profit terkecilnya beserta regionnya akan diganti. Proses tersebut dilakukan sampai semua region telah dicek.

### 2e
Membuat sebuah script yang akan menghasilkan file “hasil.txt”
```
{printf "Transaksi terakhir dengan profit percentage terbesar yaitu %d dengan persentase  %.2f%%.\n\n", idmax, max}
' "$input" >> hasil.txt
```
Menyimpan id dan persentase profit terbesar ke dalam file "hasil.txt"

```
{ for(b in a){ print b} {printf "\n"}}
' "$input" >> hasil.txt
```
Semua _customer name_ yang ada pada array a disimpan ke dalam file "hasil.txt"

```
{
	printf "Tipe segmen customer yang penjualannya paling sedikit adalah "
	{if(consumer < homeoffice && consumer < corp)
		printf "Consumer dengan %d transaksi.\n\n",consumer
	 else if(homeoffice < consumer && homeoffice < corp)
	 	printf "Home Office dengan %d transaksi.\n\n", homeoffice
	 else if(corp < homeoffice && corp < consumer)
	 	printf "Corporate dengan %d transaksi.\n\n", corp
	}
}
' "$input" >> hasil.txt
```
Data jumlah Segmen bertipe Customer, Home Ofiice, dan Corperate yang didapatkan dibandingkan mana yang paling besar dari ketiga data tersebut dan kemudian hasilnya disimpan ke dalam file "hasil.txt"

```
{printf "Wilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah %s dengan total keuntungan %.2f\n",regionmin, arr[regionmin]}
}
' "$input" >> hasil.txt
```
Menyimpan wilayah dengan total profit paling sedikit beserta total profitnya ke dalam file "hasil.txt"


## NO 3

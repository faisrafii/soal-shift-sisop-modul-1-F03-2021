# soal-shift-sisop-modul-1-F03-2021

Nama Anggota | NRP
------------------- | --------------		
Dias Tri Kurniasari | 05111940000035
Akmal Zaki Asmara | 05111940000154
M. Fikri Sandi Pratama | 05111940000195

List of Contents :
- [No 1](#no-1)
	- [1a](#1a)
	- [1b](#1b)
	- [1c](#1c)
	- [1d](#1d)
	- [1e](#1e)
- [No 2](#no-2:tokoshisop)
	- [2a](#2a)
	- [2b](#2b)
	- [2c](#2c)
	- [2d](#2d)
	- [2e](#2e)
- No 3

## NO 1 
Pada pengerjaan soal no 1 ini, dibutuhkan data dari syslog.log. Sehingga dilakukan input file data tersebut yaitu
```bash
input="syslog.log"
```

### 1a
Untuk mengumpulkan informasi dari syslog berupa jenis log (ERROR/INFO), pesan log, dan username pada setiap baris lognya. Diperlukan adanya regex untuk memfilter kolom dari syslog
```bash
regex="(ERROR |INFO )(.*) \((.*)\)"
```
Regex diatas terbagi menjadi 3 bagian yaitu :
1. (ERROR|INFO) akan mencari line yang mengandung kata error atau info dan menjadikannya sebagai regex group 1 yang akan menampilkan jenis log
2. (.*) akan mengambil karakter sembarang dengan jumlah 0 hingga tak terbatas setelah ERROR atau INFO dan menjadikannya sebagai regex group 2 yang akan menampilkan pesan log
3. \((.*)\) akan mengambil karakter sembarang dengan jumlah 0 hingga tak terbatas setelah group 2 dan setelah karakter '(' dan sebelum karakter ')' dan menjadikannya sebagai regex group 3 yang akan menampilkan username

### 1b
Untuk menampilkan pesan error dan jumlah kemunculannya, maka kita dapat memodifikasi regex sebelumnya menjadi :
```bash
regex2="(ERROR )(.*) \((.*)\)"
```
Regex dimodifikasi agar regex hanya mencari line yang memiliki kata ERROR saja
```bash
get_error_log(){
	local s=$1 regex=$2 
	while [[ $s =~ $regex ]]; do
		printf "${BASH_REMATCH[2]}\n"
		s=${s#*"${BASH_REMATCH[0]}"}
	done
}
```
Fungsi get_error_log berfungsi untuk mendapatkan grup ke 2 dari regex group yang berisi pesan log

```bash
IFS=
errorlog=$(
while read -r line
do
	get_error_log "$line" "$regex2"
done < "$input")

sortederrorlog=$(echo $errorlog | sort | uniq -c | sort -nr | tr -s [:space:])
```
Fungsi `get_error_log` akan dijalankan setiap pembacaan line pada input yaitu syslog.log menggunakan regex yang telah dimodifikasi. IFS= digunakan untuk menyimpan formatting '\n' agar tidak hilang ketika dimasukkan kedalam variabel errorlog

Hasil dari proses filtering menggunakan regex diurutkan dengan `sort` agar dapat diambil jumlah pesan yang berbeda dengan `uniq -c`. Setelah dicari jumlah pesan berbeda, hasil di sort kembali berdasarkan angka dengan `sort -n` dan `-r` agar disort dari angka terbesar. `tr -s [:space:]` digunakan untuk menghapus spasi yang dihasilkan dari `uniq -c`. Setelah itu hasil disimpan pada variabel `sortederrorlog`

### 1c
Untuk menampilkan jumlah error dan info setiap user, maka dibutuhkan group ke 3 dari regex pertama yang telah dibuat. Cara pengambilan group ke 3 regex menggunakan cara yang sama seperti pada 1b
```bash
get_user_log(){
	local s=$1 regex=$2
	while [[ $s =~ $regex ]]; do
		printf "${BASH_REMATCH[3]}\n"
		s=${s#*"${BASH_REMATCH[0]}"}
	done
}
userlog=$(
while read -r line
do
	get_user_log "$line" "$regex"
done < "$input")

sorteduserlog=$(echo $userlog | sort | uniq | sort)
```
Proses pembacaan juga dilakukan per line dari input dengan menggunakan `while`. Hasil disort dan diambil nama-nama yang tidak sama dan diurutkan sesuai abjad

### 1d
Untuk menampilkan informasi yang disediakan di 1b dan memformat penulisan agar sesuai dengan format .csv dapat dilakukan dengan melakukan print pada `sortederrorlog` yaitu pesan log yang telah diurutkan sesuai jumlah pesan.
```bash
printf "Error,Count\n" >> "error_message.csv"
echo "$sortederrorlog" | grep -oP "^ *[0-9]+ \K.*" | while read -r line
do
	count=$(grep "$line" "$input" | wc -l)
	printf "$line,$count\n"
	
done >> "error_message.csv"
```
Sebelum diprint, kita perlu untuk mengambil pesan lognya saja pada variabel `sortederrorlog`
```bash
grep -oP "^ *[0-9]+ \K.*"
```
Regex pada grep diatas bermakna bahwa :
1. Kita akan mengambil line yang diawali dengan spasi dengan jumlah 0 sampa dengan tak terhingga (^ *),
2. Diikuti dengan angka dengan jumlah 1 sampai dengan tak terhingga [0-9]+,
3. Setelah itu dikuti dengan spasi
4. Dan regex matchnya akan dimulai setelah spasi dilanjutkan sampai karakter terserah dengan jumlah 0 hingga tak terhingga \K.*
```bash
grep "$line" "$input" | wc -l
```
Setelah melakukan filtering, setiap line dari variabel `sortederrorlog` diprint dan dicari jumlah kemunculannya pada file syslog.log dengan menggunakan `wc -l` dan diprint juga jumlahnya.

Setelah selesai, output dimasukkan pada file error message.csv

### 1e
Untuk menampilkan informasi yang didapat dari poin c ke dalam file user_statistic.csv dapat dilakukan dengan cara yang hampir sama dengan 1d
```bash
error=$(grep "ERROR" "$input") 
info=$(grep "INFO" "$input")
printf "Username,INFO,ERROR\n" >> "user_statistic.csv"
echo "$sorteduserlog" | while read -r line
do
	errcount=$(echo "$error" | grep -w "$line" | wc -l)
	infocount=$(echo "$info" | grep -w "$line" | wc -l)
	printf "$line,$infocount,$errcount\n"
done >> "user_statistic.csv"
```
Variabel `error` dan `info` digunakan untuk mengambil line yang beris error dan info dari input. Lalu setiap line dari variabel `sorteduserlog` diprint dan dicari kemunculan user pada line yang dibaca saat itu pada variabel `error` dan `info` dan kemudian diprint. Setelah selesai diprint, output dimasukkan ke user_statistic.csv

## NO 2 : TokoShiSop
Pada pengerjaan soal no 2 ini, dibutuhkan data TokoShiSop. Sehingga dilakukan input file data tersebut yaitu "Laporan-TokoShiSop.tsv"
```bash
export LC_ALL=C
input="/home/zaki/Downloads/Laporan-TokoShiSop.tsv"
```

### 2a 
Steven ingin mengetahui Row ID dan profit percentage terbesar
```bash
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
```bash
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
```bash
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
```bash
awk -F "\t" '
BEGIN{}
{
	{if(NR!=1)
		arr[$13]+= $21
	}
#	{if(NR!=1)
#	printf "%f %f\n",$21,min
#		{if($21 < min)
#			{
#				printf "compared\n"
#				min=$21
#				regionmin=$13
#			}
#		}
#	}
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
- 

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

# Sequence Diagram Review

Ini merupakan dokuemntasi dari hasil review [sequence diagram](./sequence_rad_revised-review.md). Ketentuan yang kurang tepat akan dijabarkan pada section sebagai berikut yang disusun sesuai dengan nama halaman
Di setiap dokumen terdapat penempatan elemen yang masih sesuai seperti:

- Arrow message yang masih overlap dengan activation box. Panjang dari arrow message seharusnya tidak boleh melebihi jarak antara dua activation box. Hal ini juga menyebabkan arrow tidak terhubung atau tidak ter hooked dengan activation box
- Penempatan text pada arrow message terkadang memiliki space yang terlalu jauh atau menimpa arrow message. Penempatan teks yang benar harus persis di atas arrow. Jika panjang teks melebihi arrow maka teksnya dipersingkat atau membuat spacing yang lebih lebar dari elemen lain seperti lifeline dan activation box.
- Penempatan nama alternative frame masih belum tepat. Harusnya terdapat satu label teks di sebelah teks alt yang bertuliskan nama case dibungkus dengan []. Lihat contoh pada penjelasan Page Kelola Tugas untuk penempatan nama alternative case yang benar.

## Page Login

- Kurang objek fitur login
  Di tiap diagram harus punya empat objek sebagai berikut
  - Aktor
  - Nama Fitur
  - Sistem
  - Database
    Pada halaman ini tidak ada objek Login di antara aktor Petugas dan Kepala Seksi.
- Tidak ada alternative case
  Pada diagram ini tidak ada alternative frame untuk membungkus message yang menggambarkan kasus kredensial tidak valid

## Page Kelola Tugas

- Penggambaran untuk alternative case terlalu umum dan sederahana
  Buat alternative frame terpisah untuk operasi CRUD yang menggambarkan masing-masing proses dengan detail namun tidak terlalu teknis seperti [berikut](./images/crud_example.png)

## Page Submit Progress Tugas

- Alternative frame lebih baik diganti menjadi loop. Karena aksi pada tiap tahap tetap sama, yang berbeda hanya data yang dikirim ke database.
- Objek Storage tidak diperlukan, message yang dikirimkan ke storage atau dari storage dipindahkan ke objek Database

## Page Pengajuan Cuti

- Alternative case yang harus digambarkan pada diagram ini hanya validasi jatah cuti yang menggambarkan tahap pengecekan jika jatah cuti masih tersedia.

## Page Kelola Petugas

- Yang harus di revisi sama dengan [Section Kelola Tugas](./sequence_rad_revised-review.md#page-kelola-tugas)

## Page Kelola Akun

- Yang harus di revisi sama dengan [Section Kelola Tugas](./sequence_rad_revised-review.md#page-kelola-tugas)

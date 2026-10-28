# Sequence Diagram Review - Iterasi #1

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

---

# Sequence Diagram Review - Iterasi #2

Pada iterasi sebelumnya, penempatan alternative frame sudah benar meskipun aturan penamaan pada iterasi sebelumnya belum terpenuhi. Hasil dari iterasi pertama memiliki permasalahan yang seragam dimana activation box kurang merepresentasikan estimasi  waktu pada sebuah proses.

- **Bentuk Objek Aktor**:
  Objek aktor pada seluruh diagram wajib menggunakan shape `umlActor` dengan style:
  `shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;labelPerimeter=1;`
  (Bukan menggunakan kotak persegi/rounded rectangle seperti boundary/control/entity).


## Page Kelola Tugas

- Panjang dan jumlah activation box masih belum sesuai, terutama pada lifeline database
Panjang dari suatu lifeline seharusnya dibuat dengan mengamati jarak antara message dan responsnya seperti pada contoh gambar yang ada di [Section Kelola Tugas](./sequence_rad_revised-review.md#page-kelola-tugas). Dapat dilihat bahwa activation boxnya bukan hanya satu yang panjangnya hampir sama seperti lifeline, namun panjang dan jumlahnya disesuaikan berdasarkan jarak antara message dan response serta estimasi waktu imajiner pada suatu proses.

## Page Kelola Petugas

Sama dengan Section Kelola Tugas di Iterasi ke-2

## Page Kelola Akun

Sama dengan Section Kelola Tugas di Iterasi ke-2

## Page Submit Progress Tugas

Sama dengan Section Kelola Tugas di Iterasi ke-2

## Page Pengajuan Cuti

Sama dengan Section Kelola Tugas di Iterasi ke-2

---

## Status Eksekusi Iterasi #2

Perbaikan telah diimplementasikan pada berkas terpisah: [sequence_rad_revised_v2.drawio](./sequence_rad_revised_v2.drawio).

**Ringkasan Perubahan**:
1. **Pemisahan Activation Box Statis**: Seluruh diagram target tidak lagi menggunakan satu activation box tunggal (~1170px / ~570px) dari awal hingga akhir diagram.
2. **Lifeline Database**: Dipecah menjadi activation box diskrit yang hanya aktif saat mengeksekusi query/transaksi (SELECT/INSERT/UPDATE/DELETE) hingga mengembalikan hasil (Operasi berhasil / return data) ke Sistem. Di luar rentang transaksi, lifeline database berada dalam status idle (garis putus-putus terlihat).
3. **Lifeline Sistem & Boundary**: Mengikuti durasi pemrosesan permintaan dari aktor, validasi, komunikasi database, hingga penyajian kembali (feedback/notifikasi/refresh) ke antarmuka.
4. **Halaman yang Diperbarui**:
   - login: Activation box terpisah untuk pembukaan halaman serta pemrosesan autentikasi akun ke Database.
   - kelola_tugas: 4 pasang segmented activation boxes untuk operasi Load Data Awal, Tambah (Create), Ubah (Update), dan Hapus (Delete).
   - kelola_petugas: 4 pasang segmented activation boxes untuk operasi CRUD.
   - kelola_akun: 4 pasang segmented activation boxes untuk operasi CRUD (Load, Tambah, Nonaktifkan, Reset Password).
   - submit_progress_tugas: Segmented activation boxes terpisah untuk simpan foto/lokasi dan pembaruan status progress.
   - pengajuan_cuti: Segmented activation boxes terpisah untuk pengambilan sisa kuota dan submit pengajuan.
   - 5. **Standarisasi Objek Aktor**: Seluruh 11 halaman diagram pada `sequence_rad_revised_v2.drawio` telah diperbarui menggunakan shape `umlActor` (`shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;labelPerimeter=1;`).

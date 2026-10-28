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

Pada iterasi sebelumnya, penempatan alternative frame sudah benar meskipun aturan penamaan pada iterasi sebelumnya belum terpenuhi. Hasil dari iterasi pertama memiliki permasalahan yang seragam dimana activation box kurang merepresentasikan estimasi waktu pada sebuah proses.

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
   - 1. **Standarisasi Objek Aktor**: Seluruh 11 halaman diagram pada `sequence_rad_revised_v2.drawio` telah diperbarui menggunakan shape `umlActor` (`shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;labelPerimeter=1;`).

---

# Sequence Diagram Review - Iterasi #3

Terdapat perubahan manual pada halaman kelola tugas. Perubahan tersebut mencakup perubahan penulisan nama alternative frame untuk case CRUD. Halaman ini wajib dijadikan acuan untuk halaman lain dengan proses yang mirip seperti halaman Kelola Petugas dan Kelola Akun.

## Page Input penilaian

Terdapat perubahan manual pada halaman ini. Perubahannya mencakup penempatan alternative frame serta penambahan messages dan response untuk merepresentasikan tahapan yang lebih detail. Namun activation box belum terdapat perubahan sama sekali. Sesuaikan penempatan activation box berdasarkan aturan dari iterasi sebelumnya.

## Page Kelola Petugas

Jadikan diagram pada halaman Kelola Tugas sebagai pedoman dalam revisi diagram Kelola Petugas

## Page Kelola Akun

Jadikan diagram pada halaman Kelola Tugas sebagai pedoman dalam revisi diagram Kelola Akun

---

## Status Eksekusi Iterasi #3

Perbaikan iterasi ke-3 telah diimplementasikan pada berkas [sequence_rad_revised_v2.drawio](./sequence_rad_revised_v2.drawio).

**Ringkasan Perubahan**:

1. **Standarisasi Penulisan Nama Alternative Frame**:
   - Menjadikan halaman **Kelola Tugas** sebagai acuan penulisan nama alternative frame untuk halaman dengan karakteristik CRUD serupa.
   - Pada halaman **Kelola Petugas**: Frame diset `value="alt"` murni, dengan label anak independen di samping kata alt: `[Tambah]`, `[Ubah]`, dan `[Hapus]`.
   - Pada halaman **Kelola Akun**: Frame diset `value="alt"` murni, dengan label anak independen di samping kata alt: `[Tambah]`, `[Nonaktifkan]`, dan `[Reset Password]`.
2. **Rekonstruksi, Segmentasi & Perapihan Halaman Input Penilaian**:
   - Menghapus activation box statis/monolitik panjang pada lifeline Fitur Penilaian, Sistem, dan Database.
   - Mengimplementasikan 4 pasang segmented activation boxes diskrit sesuai estimasi durasi dan fase tahapan proses:
     - **Fase Load Data Awal**: `act_bound_load`, `act_sys_load`, `act_db_load`.
     - **Fase Buka & Ambil Pengajuan Banding**: `act_bound_appeal_req`, `act_sys_appeal_req`, `act_db_appeal_req`.
     - **Fase Cabang Disetujui (True)**: `act_bound_approve`, `act_sys_approve`, `act_db_approve`.
     - **Fase Cabang Ditolak (Else)**: `act_bound_reject`, `act_sys_reject`, `act_db_reject`.
   - **Perapihan Geometri & Urutan Kronologis (Y-Ordering)**:
     - Mengurutkan posisi Y seluruh 21 pesan dan respon secara strictly monotonic tanpa ada panah yang mendahului proses dependensinya (Database mengembalikan data pengajuan terlebih dahulu sebelum Fitur Penilaian menampilkannya ke Operator).
     - Menghubungkan seluruh panah pesan/respon secara horizontal sempurna langsung ke activation box terkait (`source` dan `target` terhubung presisi tanpa offset manual usang).
     - Menambahkan panah respon dari Database ke Sistem pada cabang penolakan (*"Operasi berhasil"*) sebelum menampilkan notifikasi ditolak ke Operator.
   - **Nesting Frame Alternatif Proporsional**:
     - Outer frame `alt [Terdapat data pengajuan banding?]` diperluas dan melingkupi inner frame secara sempurna tanpa tabrakan batas.
     - Inner frame `alt [Pengajuan sesuai kriteria?]` ditata rapi dengan pembatas garis putus-putus dan label `else` di koordinat yang presisi.
   - Lifeline diperpanjang hingga batas bawah diagram (`y=1400`) agar proporsional dan tidak terpotong.

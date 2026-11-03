# Plan Activity Diagram Petugas

## Tujuan

Menambahkan activity diagram untuk seluruh use case yang dapat diakses oleh
aktor **Petugas** berdasarkan diagram use case Petugas. Diagram dibuat sebagai
halaman baru di `activity_rest_updated.drawio.xml` dengan menjadikan halaman
activity diagram yang sudah ada sebagai acuan tata letak, swimlane, gaya
penulisan, dan alur proses.

## Acuan Diagram

- Sumber use case: `diagram/usecase/use_case_updated-uc_petugas.png`
- File target: `diagram/activity/activity_rest_updated.drawio.xml`
- Contoh tata letak: halaman `Kelola Tugas`, `Kelola Petugas`, `Kelola Akun`,
  `Kelola Penilaian`, dan `Kelola Cuti`
- Swimlane utama:
  - `Petugas`
  - `Sistem`
- Arah alur: dari atas ke bawah
- Bentuk proses: rounded rectangle berwarna kuning
- Bentuk keputusan: diamond dengan label cabang seperti `Ya` dan `Tidak`
- Awal dan akhir proses: `startState` dan `endState`

## Daftar Halaman yang Dibuat

### 1. Login Petugas

Alur utama:

1. Petugas membuka halaman login.
2. Petugas mengisi username dan password.
3. Petugas menekan tombol `Login`.
4. Sistem memvalidasi kredensial.
5. Jika valid, sistem menampilkan dashboard.
6. Jika tidak valid, sistem menampilkan pesan kesalahan dan menyediakan
   pengulangan proses login.

### 2. Membuat Laporan Pengerjaan Tugas

Alur utama:

1. Petugas membuka daftar tugas.
2. Petugas memilih tugas yang akan dilaporkan.
3. Sistem menampilkan form laporan.
4. Petugas mengisi laporan pengerjaan.
5. Petugas mengirim laporan.
6. Sistem memvalidasi input laporan.
7. Jika valid, sistem menyimpan data laporan.
8. Sistem menampilkan notifikasi berhasil.
9. Jika tidak valid, sistem menampilkan pesan kesalahan dan mengulang proses
   input.

### 3. Melihat Daftar Riwayat Tugas

Alur utama:

1. Petugas mengakses menu `Tugas`.
2. Petugas memilih riwayat tugas.
3. Sistem mengambil data riwayat tugas.
4. Sistem menampilkan daftar riwayat tugas.

### 4. Melihat Kuota Cuti

Alur utama:

1. Petugas mengakses menu `Cuti`.
2. Sistem menghitung sisa kuota cuti.
3. Sistem menampilkan kuota cuti.

### 5. Mengajukan Cuti

Alur utama:

1. Petugas mengakses menu `Cuti`.
2. Petugas mengisi form pengajuan cuti.
3. Petugas mengirim pengajuan.
4. Sistem memvalidasi pengajuan cuti.
5. Jika valid, sistem menyimpan pengajuan cuti.
6. Sistem menampilkan notifikasi berhasil.
7. Jika tidak valid, sistem menampilkan pesan kesalahan dan mengulang proses
   pengisian.

### 6. Melihat Riwayat Cuti

Alur utama:

1. Petugas mengakses menu `Cuti`.
2. Petugas memilih riwayat cuti.
3. Sistem mengambil data riwayat cuti.
4. Sistem menampilkan daftar riwayat cuti.

### 7. Melihat Daftar Penilaian

Alur utama:

1. Petugas mengakses menu `Penilaian`.
2. Sistem mengambil data penilaian.
3. Sistem menampilkan daftar penilaian.

### 8. Mengajukan Banding

Alur utama:

1. Petugas mengakses menu `Penilaian`.
2. Petugas memilih penilaian.
3. Petugas mengisi alasan banding.
4. Petugas mengirim banding.
5. Sistem memvalidasi data banding.
6. Jika valid, sistem menyimpan pengajuan banding.
7. Sistem menampilkan notifikasi berhasil.
8. Jika tidak valid, sistem menampilkan pesan kesalahan dan mengulang proses
   pengisian.

## Ketentuan Konsistensi

- Setiap use case dibuat sebagai satu halaman Draw.io.
- Nama halaman menggunakan nama use case yang mudah dibaca.
- Setiap halaman memiliki node awal dan node akhir.
- Setiap decision memiliki label cabang.
- Setiap jalur proses harus berakhir pada node akhir atau kembali ke proses
  input yang sesuai.
- Istilah aktor dan sistem menggunakan `Petugas` dan `Sistem`.
- Perubahan dilakukan dengan menambahkan halaman baru tanpa menghapus halaman
  activity diagram yang sudah ada.

## Validasi

- Pastikan XML dapat dibuka kembali di Draw.io.
- Pastikan seluruh halaman baru tampil pada daftar halaman.
- Pastikan setiap edge memiliki source dan target yang valid.
- Pastikan swimlane, node, decision, dan label dapat dirender dengan benar.

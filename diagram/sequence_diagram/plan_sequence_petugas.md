# Plan Pembuatan Sequence Diagram Petugas

## Tujuan

Membuat sequence diagram yang melengkapi dokumentasi Petugas. Use case
diagram dan activity diagram Petugas menjadi referensi utama untuk fungsi,
urutan interaksi, hasil proses, dan kondisi alternatif.

## Referensi utama

- Use case Petugas:
  `diagram/usecase/use_case_petugas_updated.drawio.xml`
- Activity Petugas:
  `diagram/activity/activity_rest_updated.drawio.xml`
- Aturan notasi:
  `diagram/diagram.md`
- Review sequence:
  `diagram/sequence_diagram/sequence_rad_revised-review.md`
- Contoh implementasi:
  `diagram/sequence_diagram/sequence_rad_revised_v2.drawio`
  dan sumber PlantUML pada `diagram/sequence_diagram/puml/`

## Halaman sequence yang dibuat

1. `Login Petugas`
2. `Membuat Laporan Pengerjaan Tugas`
3. `Melihat Log Laporan`
4. `Melihat Daftar Riwayat Tugas`
5. `Melihat Kuota Cuti`
6. `Mengajukan Cuti`
7. `Melihat Riwayat Cuti`
8. `Melihat Daftar Penilaian`
9. `Mengajukan Banding`

## Model objek

Setiap halaman maksimal memuat empat objek:

- `actor`: `Petugas`
- `boundary`: nama fitur yang sedang digunakan
- `control`: `Sistem`
- `entity`: `Database`

Objek teknis tambahan seperti Storage, hook, service, atau controller khusus
tidak ditambahkan. Upload bukti, lampiran, lokasi, dan status disampaikan
melalui message umum antara boundary, Sistem, dan Database.

## Rancangan alur dan kondisi alternatif

### Login Petugas

Petugas mengirim kredensial melalui boundary. Sistem memeriksa akun ke
Database dan mengembalikan dashboard jika valid. Gunakan
`alt [Kredensial tidak valid]` untuk pesan kesalahan dan pengulangan login.

### Membuat Laporan Pengerjaan Tugas

Petugas memilih tugas, mengisi laporan, mengunggah bukti, lalu mengirim data.
Sistem memvalidasi dan menyimpan laporan ke Database. Gunakan
`alt [Data laporan tidak valid]` untuk jalur gagal.

### Melihat Log Laporan

Sistem mengambil daftar log beserta status dari Database, menampilkannya
melalui boundary, lalu mengambil detail saat Petugas memilih laporan.
Gunakan `alt [Data log tidak tersedia]` untuk kondisi kosong.

### Melihat Daftar Riwayat Tugas

Sistem mengambil riwayat tugas dari Database dan menampilkannya. Gunakan
`alt [Data riwayat tidak tersedia]` bila tidak ada data.

### Melihat Kuota Cuti

Sistem mengambil kuota tahunan, jumlah terpakai, dan sisa kuota dari
Database, lalu menampilkannya. Gunakan `alt [Data kuota tidak tersedia]`
untuk kegagalan pengambilan data.

### Mengajukan Cuti

Petugas mengisi periode, alasan, dan lampiran opsional. Sistem memeriksa
kuota serta validitas data. Gunakan
`alt [Kuota tidak mencukupi atau data tidak valid]` untuk jalur gagal.
Jalur berhasil menyimpan pengajuan dengan status menunggu persetujuan.

### Melihat Riwayat Cuti

Sistem mengambil daftar pengajuan beserta status dari Database dan
menampilkannya. Gunakan `alt [Belum ada pengajuan]` untuk kondisi kosong.

### Melihat Daftar Penilaian

Sistem mengambil daftar penilaian dan total nilai dari Database, kemudian
menampilkannya. Gunakan `alt [Data penilaian tidak tersedia]` bila data
belum ada.

### Mengajukan Banding

Petugas memilih penilaian, mengisi alasan, dan mengirim banding. Sistem
memvalidasi lalu menyimpan pengajuan ke Database. Gunakan
`alt [Data banding tidak valid]` untuk jalur gagal; jalur berhasil
menampilkan status menunggu pemeriksaan.

## Konvensi visual dan teknis

- Gunakan stereotype UML `actor`, `boundary`, `control`, dan `entity`.
- Objek aktor memakai shape `umlActor` dengan style standar project.
- Message utama menggunakan panah solid.
- Response menggunakan panah dashed/open.
- Percabangan menggunakan frame `alt`, bukan decision diamond.
- Frame memakai `alt` sebagai label utama dan label kasus terpisah dalam
  format `[Nama kondisi]`.
- Activation box disegmentasi sesuai fase interaksi; hindari activation box
  monolitik sepanjang lifeline.
- Setiap message terhubung langsung ke activation box pengirim dan penerima.
- Teks message diletakkan tepat di atas garis panah dan menggunakan istilah
  umum yang konsisten dengan activity diagram.

## Tahapan implementasi

1. Audit pola XML dan layout pada sequence diagram existing.
2. Buat salinan atau halaman baru khusus sequence Petugas.
3. Tambahkan sembilan halaman sesuai daftar target.
4. Isi message, response, activation box, dan frame alternatif berdasarkan
   activity diagram masing-masing.
5. Perbarui `sequence_rad_revised-review.md` setelah iterasi implementasi.
6. Validasi XML, jumlah objek, endpoint panah, segmentasi activation, dan
   keterbacaan diagram.

## Kriteria selesai

- Sembilan use case Petugas memiliki sequence diagram.
- Setiap halaman mengikuti batas maksimal empat objek dan stereotype yang benar.
- Alur utama serta kondisi alternatif sesuai activity diagram.
- Login, validasi, data kosong, kuota cuti, status menunggu, dan banding
  tercakup pada halaman yang relevan.
- Tidak ada activation box monolitik atau panah dangling.
- Diagram sequence existing tidak tertimpa tanpa salinan.

# Perbandingan Activity Diagram dengan Use Case Scenario

## 1. Sumber dan Ruang Lingkup

Perbandingan ini menggunakan:

- **Use Case Scenario** pada `draft_TA_20104057_Gregorius Damar(3).docx`.
- **Activity diagram** pada `diagram/activity/activity_rest_updated.drawio.xml`.
- **Rancangan halaman Petugas** pada `plan_activity_petugas.md`.

Perbandingan difokuskan pada kesesuaian aktor, alur utama, kondisi awal/akhir,
alur abnormal, validasi, serta hasil proses. Kondisi awal dan post-condition
dicatat sebagai gap apabila belum direpresentasikan oleh aktivitas atau hasil
yang terlihat pada diagram.

## 2. Ringkasan Temuan

| Prioritas | Temuan |
|---|---|
| Tinggi | Use case **Melihat log laporan** belum memiliki halaman activity diagram. |
| Tinggi | Activity **Membuat Laporan Pengerjaan Tugas** belum memuat aktivitas mengunggah bukti. |
| Tinggi | Activity **Kelola Penilaian** belum memiliki jalur Hapus, padahal use case scenario mencantumkannya. |
| Tinggi | Activity **Kelola Cuti** belum menggambarkan seluruh alur abnormal dan belum memisahkan/menjelaskan approval serta penolakan secara lengkap. |
| Sedang | Beberapa activity belum memiliki jalur ketika data tidak tersedia. |
| Sedang | Beberapa hasil proses, seperti status pengajuan, total nilai, dan data yang telah digunakan, belum ditampilkan secara eksplisit. |
| Rendah | Nama aktivitas dan nama halaman belum selalu sama dengan istilah pada use case scenario. |

## 3. Perbandingan Use Case Petugas

### 3.1 Login

**Status: sebagian besar sesuai.**

Activity `Login Petugas` sudah memuat:

- Membuka halaman login.
- Mengisi username dan password.
- Menekan tombol Login.
- Validasi kredensial.
- Keputusan kredensial valid.
- Menampilkan dashboard jika valid.
- Pesan kesalahan jika tidak valid.

**Kekurangan:**

- Aktivitas `Menampilkan dashboard` belum secara eksplisit menggunakan istilah
  “mengarahkan Petugas ke halaman dashboard” seperti post-condition pada
  scenario.
- Belum ada batas percobaan login atau aktivitas pengulangan yang eksplisit,
  walaupun cabang tidak valid sudah tersedia.

**Prioritas:** Rendah.

### 3.2 Membuat Laporan Pengerjaan Tugas

**Status: belum lengkap.**

Activity sudah memuat membuka daftar tugas, memilih tugas, menampilkan form,
mengisi laporan, mengirim laporan, validasi, menyimpan data, notifikasi sukses,
serta pesan kesalahan.

**Kekurangan:**

1. Use case scenario mensyaratkan Petugas **mengunggah bukti**, tetapi activity
   hanya memiliki `Mengisi laporan pengerjaan`.
2. Pre-condition “memiliki tugas yang sedang berjalan” belum direpresentasikan.
   Sebaiknya ditambahkan keputusan `Tugas sedang berjalan?`.
3. Post-condition bahwa laporan dapat dilihat pihak berwenang belum ditunjukkan
   melalui aktivitas setelah penyimpanan.
4. Kebutuhan penelitian tentang bukti foto, geotagging, dan timestamp belum
   tampak sebagai aktivitas terpisah. Geotagging dan timestamp perlu ditambahkan
   apabila memang menjadi bagian dari implementasi final.

**Prioritas:** Tinggi.

### 3.3 Melihat Log Laporan

**Status: belum tersedia.**

Use case scenario mendefinisikan alur:

1. Petugas membuka fitur log laporan.
2. Sistem menampilkan riwayat laporan beserta status.
3. Petugas memilih laporan.
4. Sistem menampilkan detail log laporan.

Belum ada halaman bernama `Melihat Log Laporan` pada
`activity_rest_updated.drawio.xml`. Halaman `Melihat Daftar Riwayat Tugas`
tidak menggantikan use case ini karena fokusnya adalah riwayat penugasan,
sedangkan `Melihat Log Laporan` berfokus pada riwayat laporan dan detail
statusnya.

**Prioritas:** Tinggi.

### 3.4 Melihat Daftar Riwayat Tugas

**Status: alur utama sesuai, alur abnormal belum ada.**

Activity sudah memuat akses menu, memilih riwayat tugas, mengambil data, dan
menampilkan daftar.

**Kekurangan:**

- Belum ada keputusan atau cabang `Data tersedia?`.
- Belum ada aktivitas `Menampilkan informasi bahwa data belum tersedia`.
- Pre-condition bahwa Petugas memiliki riwayat penugasan belum tampak.

**Prioritas:** Sedang.

### 3.5 Melihat Kuota Cuti

**Status: alur utama sebagian sesuai.**

Activity sudah memuat akses menu Cuti, menghitung sisa kuota, dan menampilkan
kuota.

**Kekurangan:**

1. Scenario meminta sistem menampilkan kuota yang **tersedia dan telah
   digunakan**, sedangkan activity hanya menuliskan `Menampilkan kuota cuti`.
2. Belum ada jalur ketika data kuota tidak tersedia.
3. Belum ada aktivitas yang membedakan kuota tahunan, kuota tersedia, dan kuota
   yang sudah digunakan.

**Prioritas:** Sedang.

### 3.6 Mengajukan Cuti

**Status: alur utama sesuai, detail input dan hasil belum lengkap.**

Activity sudah memuat akses menu, pengisian form, pengiriman, validasi,
keputusan valid, penyimpanan, notifikasi sukses, dan pesan kesalahan.

**Kekurangan:**

1. Scenario menyebutkan pengisian **periode dan alasan cuti**, tetapi activity
   belum memisahkan atau menyebut kedua data tersebut.
2. Scenario menyebutkan **unggah lampiran jika diperlukan**, tetapi activity
   belum memuat aktivitas tersebut.
3. Post-condition `status menunggu persetujuan` belum ditampilkan.
4. Pre-condition `kuota cuti masih tersedia` belum direpresentasikan sebagai
   keputusan atau validasi sebelum form dikirim.
5. Cabang invalid sebaiknya secara eksplisit menuju aktivitas pengisian ulang
   dan menunjukkan bahwa pengajuan tidak disimpan.

**Prioritas:** Tinggi.

### 3.7 Melihat Riwayat Cuti

**Status: alur utama sebagian sesuai.**

Activity sudah memuat akses menu, memilih riwayat, mengambil data, dan
menampilkan daftar.

**Kekurangan:**

- Scenario meminta riwayat ditampilkan **beserta status setiap pengajuan**,
  sedangkan activity hanya menampilkan `daftar riwayat cuti`.
- Belum ada cabang ketika data pengajuan tidak tersedia.
- Belum ada aktivitas yang menampilkan detail status seperti menunggu,
  disetujui, atau ditolak.

**Prioritas:** Sedang.

### 3.8 Melihat Daftar Penilaian

**Status: alur utama sebagian sesuai.**

Activity sudah memuat akses menu Penilaian, mengambil data, dan menampilkan
daftar.

**Kekurangan:**

- Scenario meminta daftar penilaian dan **total nilai**, tetapi activity belum
  memuat aktivitas menampilkan total nilai.
- Belum ada cabang ketika data penilaian tidak tersedia.
- Pre-condition bahwa Petugas telah memiliki penilaian kinerja belum
  direpresentasikan.

**Prioritas:** Sedang.

### 3.9 Mengajukan Banding

**Status: alur utama sesuai, hasil dan batasan proses belum lengkap.**

Activity sudah memuat memilih penilaian, mengisi alasan, mengirim banding,
validasi, keputusan valid, menyimpan, notifikasi sukses, dan pesan kesalahan.

**Kekurangan:**

1. Pre-condition bahwa Petugas menemukan ketidaksesuaian pada penilaian belum
   terlihat sebagai aktivitas atau keputusan.
2. Post-condition bahwa banding berstatus **menunggu tinjauan pihak berwenang**
   belum ditampilkan.
3. Cabang tidak valid belum menyebutkan secara eksplisit bahwa data tidak
   disimpan.
4. Aktivitas `Mengakses menu Penilaian` sebaiknya ditempatkan sebelum
   `Memilih penilaian` secara konsisten pada urutan visual.

**Prioritas:** Sedang.

## 4. Perbandingan Use Case Operator dan Kepala Seksi

### 4.1 Kelola Tugas

**Status: CRUD utama tersedia, validasi belum lengkap.**

Activity sudah memuat akses menu, daftar tugas, pilihan Tambah/Edit/Hapus,
form tambah, edit, konfirmasi hapus, hasil berhasil, dan refresh daftar.

**Kekurangan:**

- Use case scenario menyebutkan data tidak valid atau tidak lengkap harus
  menghasilkan pesan kesalahan dan tidak menyimpan perubahan.
- Belum ada aktivitas validasi input serta cabang gagal untuk Tambah dan Edit.
- Hasil akhir belum secara eksplisit menyatakan bahwa data tugas dapat dilihat
  Petugas yang ditugaskan.

**Prioritas:** Tinggi.

### 4.2 Kelola Petugas

**Status: CRUD utama tersedia, validasi belum lengkap.**

Activity sudah memuat daftar, tambah, edit, hapus, konfirmasi hapus, hasil
berhasil, dan daftar yang diperbarui.

**Kekurangan:**

- Belum ada `Validasi input`.
- Belum ada pesan kesalahan untuk data tidak valid/tidak lengkap.
- Belum ada jalur yang memperlihatkan perubahan dibatalkan dan data tidak
  disimpan ketika validasi gagal.

**Prioritas:** Sedang.

### 4.3 Kelola Akun

**Status: alur CRUD tersedia, terdapat ketidaksesuaian istilah.**

Activity sudah memuat tambah, edit, hapus, konfirmasi hapus, penyimpanan, dan
refresh daftar akun.

**Kekurangan:**

1. Use case scenario menjelaskan dampak perubahan akun terhadap autentikasi,
   tetapi activity belum menunjukkan akun baru dapat digunakan atau kredensial
   yang diperbarui dapat dipakai login.
2. Validasi input dan pesan kesalahan belum tersedia.
3. Scenario menggunakan istilah operasi akun, sedangkan alur activity masih
   mengikuti pola CRUD generik. Jika operasi akun sebenarnya berupa
   nonaktifkan/reset password, nama aktivitas perlu diselaraskan.

**Prioritas:** Sedang.

### 4.4 Kelola Penilaian

**Status: belum sesuai penuh.**

Activity sudah memuat tambah, edit, validasi input, keputusan valid, hasil
berhasil, refresh daftar, dan pemeriksaan data pengajuan banding.

**Kekurangan:**

1. Use case scenario menyebutkan operasi **Tambah, Edit, atau Hapus**, tetapi
   decision activity hanya `Tambah, Edit`; jalur Hapus belum ada.
2. Belum ada konfirmasi penghapusan.
3. Jalur invalid belum menuju pesan kesalahan atau pengisian ulang secara
   lengkap.
4. Pemeriksaan `Terdapat data pengajuan banding?` perlu dipastikan memang
   bagian dari proses Kelola Penilaian; jika merupakan use case terpisah,
   sebaiknya dipindahkan ke activity `Mengajukan Banding`.

**Prioritas:** Tinggi.

### 4.5 Kelola Cuti, Menyetujui Cuti, dan Menolak Cuti

**Status: belum lengkap dan belum konsisten dengan scenario.**

Activity `Kelola Cuti` sudah memuat:

- Akses menu Cuti.
- Memilih pengajuan dengan status menunggu persetujuan.
- Keputusan `Disetujui?`.
- Mengubah status menjadi Disetujui.
- Mengisi alasan penolakan.
- Mengubah status menjadi Ditolak.
- Menampilkan daftar cuti terbaru.

**Kekurangan:**

1. Use case scenario mendefinisikan `Menyetujui Cuti` dan `Menolak Cuti`
   sebagai use case terpisah, tetapi activity hanya menyediakan satu halaman
   gabungan tanpa penamaan atau pemisahan alur yang jelas.
2. Scenario menyebut aktor `Operator dan Kepala Seksi`, sedangkan swimlane
   activity hanya `Kepala Seksi`.
3. Alur persetujuan seharusnya memuat peninjauan data pengajuan, pemilihan
   Setujui, dan konfirmasi keputusan secara eksplisit.
4. Alur penolakan seharusnya memuat pemilihan Tolak, pengisian alasan jika
   diperlukan, dan konfirmasi keputusan secara eksplisit.
5. Belum ada cabang abnormal ketika status pengajuan tidak sesuai.
6. Post-condition persetujuan bahwa kuota cuti diperbarui belum ditampilkan.
7. Tidak ada halaman activity terpisah untuk `Menyetujui Cuti` dan
   `Menolak Cuti` apabila keduanya diwajibkan sebagai gambar/activity diagram
   tersendiri pada dokumen TA.

**Prioritas:** Tinggi.

## 5. Halaman yang Belum Ada atau Perlu Dipisahkan

| Halaman | Status | Tindakan |
|---|---|---|
| Melihat Log Laporan | Belum ada | Tambahkan halaman baru dengan daftar log, status, pilihan log, dan detail log. |
| Menyetujui Cuti | Belum terpisah | Tambahkan halaman terpisah atau beri frame/alur approval yang jelas. |
| Menolak Cuti | Belum terpisah | Tambahkan halaman terpisah atau beri frame/alur rejection yang jelas. |
| Mengunggah Bukti Laporan | Belum eksplisit | Tambahkan ke halaman Membuat Laporan Pengerjaan Tugas. |
| Geotagging dan Timestamp | Belum eksplisit | Tambahkan bila merupakan fitur final yang diwajibkan penelitian. |

## 6. Urutan Perbaikan yang Disarankan

1. Tambahkan halaman `Melihat Log Laporan`.
2. Lengkapi `Membuat Laporan Pengerjaan Tugas` dengan upload bukti,
   geotagging/timestamp bila berlaku, validasi tugas aktif, dan hasil laporan.
3. Lengkapi `Mengajukan Cuti` dengan periode, alasan, lampiran, validasi kuota,
   dan status `Menunggu Persetujuan`.
4. Tambahkan jalur data tidak tersedia pada riwayat tugas, kuota cuti, riwayat
   cuti, dan daftar penilaian.
5. Tambahkan total nilai pada `Melihat Daftar Penilaian` dan status setiap
   pengajuan pada `Melihat Riwayat Cuti`.
6. Tambahkan validasi gagal pada `Kelola Tugas`, `Kelola Petugas`, dan
   `Kelola Akun`.
7. Tambahkan jalur Hapus pada `Kelola Penilaian`, termasuk konfirmasi dan hasil
   proses.
8. Rekonstruksi alur approval dan rejection cuti agar aktor, konfirmasi,
   alasan penolakan, perubahan status, pembaruan kuota, dan alur abnormal
   konsisten dengan use case scenario.

## 7. Kesimpulan

Activity diagram saat ini telah mencakup kerangka alur utama untuk sebagian
besar use case. Namun, diagram masih berada pada tingkat ringkasan dan belum
sepenuhnya merepresentasikan detail yang tertulis pada use case scenario.
Kekurangan paling penting adalah belum adanya activity `Melihat Log Laporan`,
belum eksplisitnya upload bukti dan fitur validasi laporan, belum lengkapnya
detail pengajuan cuti, serta ketidaksesuaian CRUD dan approval cuti.

Perbaikan sebaiknya dilakukan berdasarkan prioritas pada bagian 6, kemudian
setiap halaman divalidasi kembali agar seluruh jalur normal dan abnormal
berakhir pada node akhir atau kembali ke langkah input yang sesuai.

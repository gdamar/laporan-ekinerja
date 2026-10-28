# Komparasi Use Case, Use Case Scenario, Activity Diagram, dan Sequence Diagram

Dokumen ini membandingkan artefak perancangan sistem E-Kinerja untuk menemukan bagian sequence diagram yang belum sesuai dan menentukan revisi yang diperlukan.

## Artefak yang dibandingkan

| Artefak | File | Cakupan |
|---|---|---|
| Use case | `diagram/usecase/use_case_updated.drawio.xml` | Tugas, petugas, akun, penilaian, cuti, login |
| Use case tambahan | `diagram/usecase/uc_operator-kasi_updated.drawio`, `diagram/usecase/uc_petugas.png` | Hak akses Operator, Kepala Seksi, dan Petugas |
| Use case scenario | `diagram/usecase-scenario.md` | Lifecycle tugas UC-TUGAS-001 sampai UC-TUGAS-011 |
| Activity diagram | `diagram/activity/activity.drawio.xml` | CRUD Tugas, Petugas, Akun, Penilaian, dan Cuti |
| Activity diagram detail | `diagram/activity/activity_rest_updated.drawio.xml` | Pembuatan laporan pengerjaan tugas oleh Petugas |
| Sequence diagram | `diagram/sequence_diagram/sequence_updated.drawio` | Login, tugas, penilaian, pengajuan cuti, approval cuti, dan alternatif approval |

## Ringkasan hasil

| Area | Status | Kesimpulan |
|---|---|---|
| Login | Sebagian sesuai | Sequence sudah memiliki login, validasi kredensial, dan error, tetapi belum menjadi pre-condition eksplisit pada sequence lain. |
| Kelola Tugas | Belum lengkap | Use case dan activity memiliki tambah, edit, hapus; sequence hanya memiliki alur umum `kelola_tugas` dan belum memetakan CRUD secara rinci. |
| Lifecycle laporan tugas | Belum sesuai penuh | Activity dan scenario menjelaskan Before, Ongoing, Finished, foto, GPS, deskripsi, validasi, dan perubahan status; sequence `submit_progress_tugas` masih terlalu umum. |
| Foto bukti | Belum sesuai | Scenario menyebut kompresi, validasi jumlah/format/ukuran, upload storage, dan URL; sequence belum memperlihatkan alur tersebut. |
| GPS | Belum sesuai | Scenario membutuhkan request lokasi, izin, koordinat, timeout, dan map preview; sequence hanya memuat `Mengirim lokasi` dan kondisi `[GPS Tersedia]`. |
| Status otomatis | Belum sesuai | Scenario memiliki trigger `trg_update_status_tugas` dan transisi status; sequence belum menunjukkan proses trigger setelah insert log. |
| Penilaian | Sebagian sesuai | Sequence `input_penilaian` ada, tetapi use case membedakan daftar, detail, input nilai, dan banding; seluruh variasi belum dimodelkan. |
| Cuti | Sebagian sesuai | Sequence pengajuan dan approval sudah ada, tetapi actor dan alur alternatif belum sepenuhnya konsisten dengan use case/activity. |
| Petugas dan Akun | Belum sesuai | Use case/activity memiliki CRUD Petugas dan Akun, tetapi belum ada sequence diagram khusus. |
| Verifikasi completion | Belum sesuai | UC-TUGAS-011 ada di scenario, tetapi belum ada sequence diagram untuk verifikasi foto, timeline, GPS, dan status verified. |

## Komparasi per fitur

### 1. Login

**Yang sudah sesuai**

- Use case Petugas memiliki akses ke sistem.
- Sequence `login` memiliki aktor Petugas, sistem, dan database.
- Sequence sudah memuat:
  - membuka halaman Login;
  - input kredensial;
  - validasi kredensial ke database;
  - autentikasi berhasil;
  - pesan kesalahan saat autentikasi gagal.

**Yang perlu direvisi**

- Login belum ditunjukkan sebagai pre-condition pada sequence `kelola_tugas`, `input_penilaian`, `pengajuan_cuti`, `approval_cuti`, dan `submit_progress_tugas`.
- Tambahkan catatan atau fragment `precondition: Actor telah login` pada sequence tersebut. Tidak perlu menggambar ulang seluruh proses login di setiap diagram.
- Samakan istilah aktor dan role: gunakan `Petugas`, `Operator`, dan `Kepala Seksi` secara konsisten.

### 2. Kelola Tugas

**Use case dan activity yang tersedia**

- Akses menu Tugas.
- Menampilkan daftar Tugas.
- Tambah tugas.
- Edit/perbarui tugas.
- Hapus tugas dengan konfirmasi.
- Menampilkan hasil berhasil.
- Refresh daftar tugas.

**Sequence saat ini**

Halaman `kelola_tugas` memuat actor Kepala Sesi, boundary Kelola Tugas, Sistem, dan Database. Pesannya masih berupa istilah umum seperti `Mengakses fitur`, `Meminta data`, `Memproses perubahan`, dan `Mengirim hasil berhasil`.

**Gap**

- Tidak ada percabangan eksplisit untuk `Tambah`, `Edit`, dan `Hapus`.
- Tidak ada form tambah/edit.
- Tidak ada konfirmasi penghapusan.
- Tidak ada pesan error ketika validasi atau operasi database gagal.
- Tidak ada detail pengelolaan penugasan petugas pada tugas.
- Istilah `Kepala Sesi` pada sequence berbeda dengan istilah `Kepala Seksi` pada sebagian use case/scenario.

**Revisi yang diperlukan**

Buat sequence CRUD yang jelas, minimal dalam satu halaman dengan fragment `alt`:

1. Tambah: buka form, isi data, pilih petugas, validasi, insert tugas, insert `tugas_petugas`, refresh/redirect.
2. Edit: buka detail, ubah data, validasi, update, refresh detail.
3. Hapus: pilih tugas, tampilkan konfirmasi, konfirmasi, delete, tampilkan notifikasi, refresh daftar.
4. Tambahkan alternatif error untuk field wajib kosong, petugas belum dipilih, dan kegagalan database.

### 3. Submit Progress Tugas

**Rujukan dari scenario dan activity**

Activity `Membuat Laporan Pengerjaan Tugas` memuat autentikasi Petugas, membuka daftar tugas, memilih tugas, mengisi laporan, validasi input, menyimpan laporan, dan kondisi data tidak sesuai.

Scenario membagi proses menjadi tiga use case:

- UC-TUGAS-005: Before — status `Menunggu` menjadi `Proses`.
- UC-TUGAS-006: Ongoing — status tetap `Proses`.
- UC-TUGAS-007: Finished — status `Proses` menjadi `Selesai`.

**Sequence saat ini**

Halaman `submit_progress_tugas` sudah memiliki Petugas, Sistem, Database, pesan umum untuk input, validasi, perubahan, GPS, dan error.

**Gap utama**

- Tahapan `Before`, `Ongoing`, dan `Finished` belum menjadi percabangan eksplisit.
- Belum ada pemeriksaan urutan tahapan:
  - Ongoing hanya setelah Before.
  - Finished hanya setelah Before dan Ongoing.
- Belum ada input deskripsi pekerjaan secara eksplisit.
- Belum ada detail upload foto dan penyimpanan URL.
- Belum ada detail GPS: request izin, timeout, GPS tidak tersedia, dan map preview.
- Belum ada insert eksplisit ke `tugas_log`.
- Belum ada perubahan status yang berbeda untuk setiap tahapan.
- Belum ada refresh detail setelah submit berhasil.
- Belum ada alternatif upload gagal dan trigger gagal.

**Revisi yang diperlukan**

Tambahkan fragment `alt` berdasarkan tahap:

```text
alt tahap = Before
    validasi tugas berstatus Menunggu
    insert tugas_log
    trigger status menjadi Proses
else tahap = Ongoing
    validasi log Before sudah ada
    insert tugas_log
    status tetap Proses
else tahap = Finished
    validasi log Before dan Ongoing sudah ada
    insert tugas_log
    trigger status menjadi Selesai
end
```

Di dalam setiap cabang, tampilkan proses foto dan GPS sebelum `insert tugas_log`.

### 4. Foto Bukti

**Scenario yang harus tercermin**

- Pilih 1–3 foto.
- Validasi format JPG/PNG/WebP.
- Validasi ukuran maksimal 5 MB.
- Kompres foto.
- Generate nama file unik.
- Upload ke bucket `tugas-foto`.
- Menerima public URL.
- Menampilkan preview.
- URL digunakan saat menyimpan log.

**Kondisi sequence saat ini**

Sequence hanya menggunakan pesan umum seperti `Mengirim input pengguna`, `Menyiapkan berkas`, dan `Memproses perubahan`.

**Revisi**

Tambahkan lifeline atau objek `Storage` dan pesan:

`Petugas -> Sistem: Pilih foto` → `Sistem: Validasi foto` → `Sistem: Kompres foto` → `Sistem -> Storage: Upload ke bucket tugas-foto` → `Storage --> Sistem: Public URL` → `Sistem: Tampilkan preview`.

Tambahkan cabang error untuk jumlah foto, format, ukuran, dan upload gagal.

### 5. GPS

**Scenario yang harus tercermin**

- Petugas mengaktifkan GPS.
- Sistem mengecek dukungan Geolocation API.
- Sistem meminta izin lokasi.
- Sistem memperoleh latitude dan longitude.
- Koordinat ditampilkan pada preview map.
- Koordinat disimpan sebagai bagian dari log.

**Kondisi sequence saat ini**

Sequence hanya memuat `Mengirim lokasi` dan kondisi `[GPS Tersedia]`.

**Revisi**

Tambahkan fragment `alt`:

- GPS tersedia dan izin diberikan: ambil posisi, tampilkan map, simpan koordinat.
- Izin ditolak: tampilkan `Izinkan akses lokasi`.
- GPS tidak tersedia: tampilkan `GPS tidak tersedia`.
- Timeout lebih dari 30 detik: tampilkan `Gagal mengambil lokasi`.

### 6. Status Otomatis

**Scenario yang harus tercermin**

Setelah insert `tugas_log`, trigger `trg_update_status_tugas` menjalankan fungsi `update_status_tugas_on_log()`:

| Tahapan | Status sebelum | Status sesudah |
|---|---|---|
| Before | Menunggu | Proses |
| Ongoing | Proses | Proses |
| Finished | Proses | Selesai |

**Gap**

Sequence belum menunjukkan trigger database sebagai proses setelah insert log. Pesan `Memproses perubahan` terlalu umum dan tidak memperlihatkan sumber perubahan status.

**Revisi**

Tambahkan lifeline `Trigger/Database` atau gunakan Database dengan fragment:

`Sistem -> Database: INSERT tugas_log` → `Database: trg_update_status_tugas` → `Database: Tentukan status berdasarkan tahapan` → `Database: UPDATE tugas_header` → `Database --> Sistem: Status diperbarui`.

Tambahkan catatan bahwa status tidak boleh mundur.

### 7. Penilaian

**Yang sudah tersedia**

- Use case mencakup melihat daftar penilaian, melihat detail penilaian, input nilai kinerja, dan mengajukan banding.
- Activity memiliki `Kelola Penilaian`, input penilaian, validasi, serta kondisi data pengajuan banding.
- Sequence `input_penilaian` sudah tersedia dan memiliki alur input, pemrosesan, validasi, hasil berhasil, dan error.

**Gap**

- Sequence belum membedakan `Melihat daftar penilaian`, `Melihat detail penilaian`, `Input nilai kinerja`, dan `Mengajukan banding`.
- Actor pada use case dapat Operator, sedangkan alur banding kemungkinan perlu actor yang melakukan pengajuan. Peran ini perlu diseragamkan dengan kebutuhan bisnis.
- Fragment `Terdapat data pengajuan banding?` dari activity belum tampak jelas pada sequence.

**Revisi**

- Tambahkan sequence terpisah untuk melihat daftar/detail penilaian atau fragment pada sequence utama.
- Tambahkan fragment `alt` untuk ada/tidaknya pengajuan banding.
- Jelaskan validasi nilai dan error penyimpanan.
- Tetapkan actor yang berwenang menginput nilai dan mengajukan banding.

### 8. Pengajuan dan Approval Cuti

**Yang sudah sesuai**

- Sequence tersedia untuk `pengajuan_cuti`.
- Sequence tersedia untuk `approval_cuti` dan tiga alternatif:
  - `approval_cuti_setujui`;
  - `approval_cuti_tolak`;
  - `approval_cuti_tangguhkan`.
- Alur alternatif sudah memuat konfirmasi tindakan, penyimpanan hasil, update daftar, dan notifikasi.

**Gap**

- Use case `Kelola Cuti` pada activity utama hanya menampilkan Kepala Seksi, sedangkan sequence approval menggunakan `Operator / Kepala Seksi`.
- Use case utama menampilkan menyetujui dan menolak pengajuan cuti, tetapi sequence menambahkan status `Ditangguhkan`. Status ini perlu ditambahkan atau dihapus dari use case agar konsisten.
- Sequence approval belum memperlihatkan validasi bahwa data berstatus `Menunggu Persetujuan`.
- Alur penolakan pada activity menyebut `Melampirkan alasan penolakan`, tetapi sequence `approval_cuti_tolak` belum memperlihatkan input dan validasi alasan.
- Sequence approval belum memperlihatkan kondisi error ketika update database gagal.
- Sequence `pengajuan_cuti` perlu dibandingkan kembali dengan activity untuk memastikan input tanggal, alasan, lampiran, kuota, dan validasi tanggal tercakup.

**Revisi**

1. Tetapkan actor approval: `Kepala Seksi`, `Operator`, atau keduanya.
2. Tambahkan `Memilih data cuti dengan status Menunggu Persetujuan`.
3. Pada cabang Tolak, tambahkan `Mengisi alasan penolakan` dan validasi alasan wajib.
4. Tambahkan cabang gagal update dan notifikasi error.
5. Samakan status bisnis antara use case, activity, scenario, dan sequence: `Disetujui`, `Ditolak`, dan jika dipakai `Ditangguhkan`.

### 9. Petugas dan Akun

**Use case/activity**

Artefak use case dan activity memiliki:

- Kelola Petugas: daftar, detail, tambah, ubah, dan hapus.
- Kelola Akun: daftar akun, membuat akun, menonaktifkan akun, dan reset password.

**Sequence**

Belum ada halaman sequence khusus untuk Petugas dan Akun.

**Revisi**

Buat minimal dua halaman sequence:

- `kelola_petugas`: daftar, tambah, edit, hapus, validasi, dan refresh.
- `kelola_akun`: daftar, tambah akun, nonaktifkan akun, reset password, konfirmasi, dan error.

Actor dan hak akses harus mengikuti use case: Operator dan/atau Kepala Seksi sesuai keputusan final.

### 10. Verifikasi Completion

**Scenario**

UC-TUGAS-011 mengharuskan Kepala Sesi/Operator:

- memfilter tugas berstatus `Selesai`;
- melihat detail;
- mereview foto Before, Ongoing, Finished;
- mereview timeline;
- mereview lokasi;
- memverifikasi kelengkapan;
- menandai verified bila diperlukan.

**Sequence**

Belum ada sequence diagram untuk verifikasi completion.

**Revisi**

Buat halaman `verifikasi_completion` dengan actor Kepala Sesi/Operator, Sistem, Database, dan bila diperlukan Storage/Map. Tambahkan validasi checklist seluruh foto, GPS, dan deskripsi sebelum status verified disimpan.

## Masalah konsistensi istilah dan actor

| Temuan | Dampak | Keputusan yang diperlukan |
|---|---|---|
| `Kepala Sesi` dan `Kepala Seksi` digunakan bergantian | Actor pada artefak dapat dianggap berbeda | Pilih satu istilah resmi dan gunakan di semua file. |
| `Operator / Kepala Seksi` dipakai pada approval sequence | Hak akses approval tidak tegas | Tetapkan apakah approval dapat dilakukan keduanya atau hanya Kepala Seksi. |
| `Kelola Cuti` memiliki `Ditangguhkan` di sequence, tetapi tidak jelas di use case utama | Status sistem tidak konsisten | Tambahkan status ke use case/scenario atau hapus dari sequence. |
| `Menunggu`, `Proses`, dan `Selesai` digunakan sebagai status tugas | Transisi harus identik di semua diagram | Gunakan tabel transisi yang sama pada scenario dan sequence. |
| `Kepala Sesi` pada scenario task lifecycle, `Kepala Seksi` pada use case | Traceability menjadi ambigu | Normalisasi nama actor sebelum finalisasi laporan. |

## Prioritas revisi sequence diagram

### Prioritas tinggi

1. Revisi `submit_progress_tugas` agar memuat Before/Ongoing/Finished.
2. Tambahkan proses foto, Storage, GPS, dan error handling.
3. Tampilkan trigger perubahan status setelah insert `tugas_log`.
4. Buat sequence verifikasi completion.
5. Selaraskan actor dan status pada approval cuti.

### Prioritas sedang

1. Pecah atau lengkapi `kelola_tugas` untuk tambah, edit, hapus, dan kelola penugasan.
2. Tambahkan sequence Kelola Petugas.
3. Tambahkan sequence Kelola Akun.
4. Lengkapi sequence Penilaian untuk daftar, detail, input, dan banding.

### Prioritas rendah

1. Ganti pesan generik seperti `Meminta data`, `Memproses perubahan`, dan `Mengirim hasil berhasil` dengan pesan yang menyebut operasi/data konkret.
2. Tambahkan catatan pre-condition login pada sequence selain login.
3. Samakan nama halaman, actor, status, dan istilah database pada seluruh artefak.

## Checklist final sebelum sequence dianggap sesuai

- [ ] Semua use case yang ada sudah memiliki sequence atau dinyatakan di luar scope.
- [ ] Semua sequence memiliki actor yang sama dengan use case.
- [ ] Setiap actor sudah memiliki pre-condition login bila relevan.
- [ ] Alur utama dan alternatif pada activity sudah muncul pada sequence.
- [ ] Before, Ongoing, dan Finished dimodelkan sebagai cabang yang berbeda.
- [ ] Upload foto dan penyimpanan URL dimodelkan.
- [ ] GPS, izin, timeout, dan error dimodelkan.
- [ ] Trigger perubahan status dimodelkan.
- [ ] CRUD dan konfirmasi hapus dimodelkan.
- [ ] Approval cuti memiliki alasan penolakan bila diwajibkan activity.
- [ ] Sequence verifikasi completion tersedia.
- [ ] Istilah `Kepala Sesi/Kepala Seksi`, status cuti, dan status tugas sudah konsisten.

## Kesimpulan

Sequence diagram saat ini sudah memiliki kerangka untuk login, tugas, penilaian, pengajuan cuti, dan approval cuti, tetapi masih berada pada tingkat abstraksi yang lebih umum dibandingkan activity diagram dan use case scenario. Revisi paling penting adalah memperjelas lifecycle laporan tugas, upload foto, GPS, trigger status otomatis, serta menyelaraskan actor dan status approval cuti. Setelah itu, sequence untuk Petugas, Akun, dan verifikasi completion perlu ditambahkan agar cakupan sequence sebanding dengan use case dan activity diagram.

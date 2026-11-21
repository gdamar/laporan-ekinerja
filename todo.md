# Todo

## Sequence Diagram

- Petugas
- [x] Untuk sequence diagram "melihat x", alternative frame dan isinya dimasukin sebelum response "menampilkan x"

- Operator dan Kepala Seksi
- [x] Revisi sequence diagram di semua halaman yang memiliki nama "Kelola" agar pesan dan alurnya jadi lebih spesifik

## Activity Diagram

- [x] Update flow activity diagram kelola penilaian sama cuti (Review ulang flow seharusnya kaya gimana)
- [-] Buat activity diagram untuk use case petugas
- [ ] Ubah aktor untuk cuti dan kelola tugas jadi **Kepala Seksi**

---

## Use Case Diagram

- [x] Masukkin use case diagram operator sama kasi di laporan
- [ ] Ubah akses kelola tugas dari operator jadi kepala seksi

---

## Use Case Scenario

- [x] Update tahapannya biar sama kaya activity diagram

Use case scenario petugas yang masih belum ada:

- [x] Login
      Use case scenario operator-kasi yang masih belum ada:
- [x] Login

> [!IMPORTANT]
> Alurnya harus sesuai kaya yang ada di activity diagram

## Penyelarasan Use case, Use case scenario, Activity diagram, Sequence diagram

### Prioritas 1 (Kritis - Harus Diperbaiki Segera)

1. **Rekonstruksi Alur Transaksi pada Halaman Petugas**:
   - [x] **Hal 13 (`Membuat Laporan Pengerjaan Tugas`)**:
     - [x] Tambahkan pesan Petugas memilih tugas.
     - [x] Tambahkan pesan Petugas menginput data laporan dan mengunggah foto bukti serta GPS.
     - [x] Tambahkan pesan pengiriman form (`Submit laporan`).
     - [x] Tambahkan validasi Sistem dan eksekusi query Database (`INSERT tugas_log` dan pembaruan status pengerjaan).
     - [x] Modelkan respon sukses dan pesan kesalahan validasi.
   - [x] **Hal 17 (`Mengajukan Cuti`)**:
     - [x] Tambahkan pesan Petugas mengisi form (periode tanggal & alasan cuti) serta mengunggah lampiran.
     - [x] Tambahkan pesan Petugas menekan `Kirim pengajuan cuti`.
     - [x] Tambahkan proses validasi kuota oleh Sistem dan query Database (`INSERT data pengajuan cuti`, status default: _Menunggu Persetujuan_).
     - [x] Perbaiki label alternatif: ubah dari `[Menampilkan alasan pengajuan ditolak]` menjadi `[Kuota cuti tidak mencukupi / Data tidak valid]`.
   - [x] **Hal 20 (`Mengajukan Banding`)**:
     - [x] Tambahkan pesan Petugas menginput alasan banding pada form.
     - [x] Tambahkan pesan submit dan query `INSERT/UPDATE data pengajuan banding` ke Database.
2. **Koreksi Aktor dan Ejaan**:
   - [x] Ganti seluruh teks `Kepala Sesi` menjadi **`Kepala Seksi`**.
   - [x] Ubah aktor pada **Hal 9 (`Kelola Petugas`)** dan **Hal 10 (`Kelola Akun`)** dari `Kepala Sesi` menjadi **`Operator`** agar sesuai dengan Tabel 4.1 dan Gambar 4.4 Draft TA.

### Prioritas 2 (Sedang - Penyelarasan Kualitas Skenario)

1. **Hal 14 (`Melihat Log Laporan`)**: Sisipkan pesan Petugas `Memilih laporan` sebelum detail log diambil dan ditampilkan.
2. **Hal 16 (`Melihat Kuota Cuti`)**: Tambahkan notasi proses/self-message pada Sistem untuk kalkulasi `Hitung sisa kuota (kuota tahunan - cuti terpakai)` sebelum menyajikan data.
3. **Hal 4 (`Kelola Penilaian / input_penilaian`)**: Tambahkan alur utama input penilaian harian oleh Operator sebelum percabangan penanganan banding, atau sediakan diagram terpisah untuk penilaian harian vs banding.
4. **Eliminasi Redundansi**: Putuskan untuk memusatkan sequence Petugas pada Halaman 12–20 (setelah diperbaiki alur transaksinya), sehingga Halaman 1, 3, dan 5 dapat dibersihkan atau digabungkan.

### Prioritas 3 (Penyempurnaan Naskah TA Bab 4)

1. Pastikan setiap gambar Sequence Diagram yang dimasukkan ke naskah Bab 4 memiliki penomoran dan narasi penjelasan yang runtut mengikuti tabel Use Case Scenario terkait.
2. Selaraskan terminologi sistem: gunakan istilah baku status tugas (`Menunggu`, `Proses`, `Selesai`), status cuti (`Menunggu Persetujuan`, `Disetujui`, `Ditolak`), dan status banding (`Menunggu Pemeriksaan`, `Disetujui`, `Ditolak`).

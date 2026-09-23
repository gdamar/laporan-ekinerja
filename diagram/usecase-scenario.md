# Use Case Scenario - Task Lifecycle Management

# Sistem E-Kinerja

Dokumentasi ini berisi Use Case Scenario dalam format tabel yang berasal dari Activity Diagram Task Lifecycle.

\--------------------------------------------------------------------------------

## Daftar Use Case Scenario

| No  | Use Case ID  | Use Case Name              | Actor       |
| --- | ------------ | -------------------------- | ----------- |
| 1   | UC-TUGAS-001 | Membuat Tugas Baru         | Kepala Sesi |
| 2   | UC-TUGAS-002 | Mengelola Penugasan        | Kepala Sesi |
| 3   | UC-TUGAS-003 | Melihat Daftar Tugas       | Semua Actor |
| 4   | UC-TUGAS-004 | Melihat Detail Tugas       | Semua Actor |
| 5   | UC-TUGAS-005 | Submit Progress (Before)   | Petugas     |
| 6   | UC-TUGAS-006 | Submit Progress (Ongoing)  | Petugas     |
| 7   | UC-TUGAS-007 | Submit Progress (Finished) | Petugas     |
| 8   | UC-TUGAS-008 | Mengunggah Foto Bukti      | Petugas     |
| 9   | UC-TUGAS-009 | Memilih Lokasi GPS         | Petugas     |
| 10  | UC-TUGAS-010 | Mengubah Status Tugas      | System      |
| 11  | UC-TUGAS-011 | Memverifikasi Completion   | Kepala Sesi |

\--------------------------------------------------------------------------------

## UC-TUGAS-001: Membuat Tugas Baru

| Field             | Detail                                                         |
| ----------------- | -------------------------------------------------------------- |
| **Use Case ID**   | UC-TUGAS-001                                                   |
| **Use Case Name** | Membuat Tugas Baru                                             |
| **Actor**         | Kepala Sesi                                                    |
| **Goal**          | Kepala Sesi dapat membuat tugas baru dan menugaskan ke petugas |
| **Trigger**       | Kepala Sesi mengakses halaman "/tugas/baru"                    |

### Pre-Condition

- Actor telah login ke sistem
- Actor memiliki role "Kepala Sesi"
- Data petugas yang akan ditugaskan tersedia di sistem

### Post-Condition (Success)

- Tugas baru berhasil dibuat dengan status "Menunggu"
- Junction table `tugas_petugas` terisi dengan benar
- Daftar tugas di-refresh

### Post-Condition (Failure)

- Form tidak bisa disubmit jika field wajib kosong
- Sistem menampilkan pesan error

### Flow of Events

| Step | Actor Action                                 | System Response                          |
| ---- | -------------------------------------------- | ---------------------------------------- |
| 1    | Akses halaman Tugas Baru (/tugas/baru)       | Tampilkan form tugas baru                |
| 2    | Isi field: judul_tugas                       | Validasi input                           |
| 3    | Isi field: alamat                            | Validasi input                           |
| 4    | Isi field: tanggal_tugas                     | Validasi format tanggal                  |
| 5    | Pilih petugas yang ditugaskan (multi-select) | Tampilkan dialog petugas                 |
| 6    | Submit form                                  | Proses data                              |
| 7    | \-                                           | Insert ke tabel tugas_header             |
| 8    | \-                                           | Insert ke tabel tugas_petugas (junction) |
| 9    | \-                                           | Invalidate query cache                   |
| 10   | \-                                           | Redirect ke detail tugas                 |

### Alternative Flow

| Step | Actor Action          | System Response                             |
| ---- | --------------------- | ------------------------------------------- |
| 5a   | Tidak memilih petugas | Tampilkan warning "Pilih minimal 1 petugas" |
| 6a   | Field wajib kosong    | Disable tombol submit                       |
| 8a   | Gagal insert          | Tampilkan error "Gagal membuat tugas"       |

### Business Rules

| Rule ID | Description                               |
| ------- | ----------------------------------------- |
| BR-001  | judul_tugas wajib diisi, max 255 karakter |
| BR-002  | tanggal_tugas default hari ini            |
| BR-003  | Minimal 1 petugas harus dipilih           |
| BR-004  | Status awal tugas adalah "Menunggu"       |

\--------------------------------------------------------------------------------

## UC-TUGAS-002: Mengelola Penugasan

| Field             | Detail                                                           |
| ----------------- | ---------------------------------------------------------------- |
| **Use Case ID**   | UC-TUGAS-002                                                     |
| **Use Case Name** | Mengelola Penugasan                                              |
| **Actor**         | Kepala Sesi                                                      |
| **Goal**          | Kepala Sesi dapat menambahkan atau mengurangi petugas pada tugas |
| **Trigger**       | Kepala Sesi mengakses detail tugas                               |

### Pre-Condition

- Actor telah login sebagai Kepala Sesi
- Tugas yang akan dikelola sudah ada

### Post-Condition (Success)

- Penugasan berhasil diperbarui
- Semua petugas terkait dapat melihat tugas

### Flow of Events

| Step | Actor Action                    | System Response               |
| ---- | ------------------------------- | ----------------------------- |
| 1    | Akses detail tugas              | Tampilkan detail + petugas    |
| 2    | Klik "Edit Petugas"             | Tampilkan dialog multi-select |
| 3    | Tambahkan/hapus centang petugas | Update selection              |
| 4    | Submit perubahan                | Proses update                 |
| 5    | \-                              | Update tabel tugas_petugas    |
| 6    | \-                              | Invalidate cache              |
| 7    | \-                              | Refresh detail tugas          |

### Business Rules

| Rule ID | Description                                                     |
| ------- | --------------------------------------------------------------- |
| BR-005  | Tidak bisa menghapus petugas utama (id_petugas di tugas_header) |
| BR-006  | Petugas yang di-unassign tetap bisa melihat history tugas       |

\--------------------------------------------------------------------------------

## UC-TUGAS-003: Melihat Daftar Tugas

| Field             | Detail                                            |
| ----------------- | ------------------------------------------------- |
| **Use Case ID**   | UC-TUGAS-003                                      |
| **Use Case Name** | Melihat Daftar Tugas                              |
| **Actor**         | Semua Actor (Petugas, Operator, Kepala Sesi)      |
| **Goal**          | Actor dapat melihat daftar tugas sesuai hak akses |
| **Trigger**       | Actor mengakses halaman "/tugas"                  |

### Pre-Condition

- Actor telah login ke sistem

### Post-Condition (Success)

- Daftar tugas ditampilkan sesuai role

### Flow of Events

| Step | Actor Action                 | System Response              |
| ---- | ---------------------------- | ---------------------------- |
| 1    | Akses halaman Tugas (/tugas) | Cek role actor               |
| 2    | \-                           | Query sesuai RLS policy      |
| 3    | \-                           | Return daftar tugas          |
| 4    | \-                           | Tampilkan list dengan filter |
| 5    | Filter tugas                 | Fetch data dengan filter     |
| 6    | Search tugas                 | Fetch data dengan keyword    |

### Role-Based Filter

| Role        | Tugas yang Ditampilkan              |
| ----------- | ----------------------------------- |
| Petugas     | Hanya tugas yang ditugaskan padanya |
| Operator    | Semua tugas                         |
| Kepala Sesi | Semua tugas                         |

\--------------------------------------------------------------------------------

## UC-TUGAS-004: Melihat Detail Tugas

| Field             | Detail                                         |
| ----------------- | ---------------------------------------------- |
| **Use Case ID**   | UC-TUGAS-004                                   |
| **Use Case Name** | Melihat Detail Tugas                           |
| **Actor**         | Semua Actor                                    |
| **Goal**          | Actor dapat melihat detail lengkap suatu tugas |
| **Trigger**       | Actor mengklik salah satu tugas di daftar      |

### Pre-Condition

- Actor telah login
- Actor memiliki akses ke tugas tersebut

### Post-Condition (Success)

- Detail tugas lengkap ditampilkan
- Semua log progress ditampilkan
- Peta lokasi ditampilkan

### Flow of Events

| Step | Actor Action       | System Response           |
| ---- | ------------------ | ------------------------- |
| 1    | Klik tugas di list | Navigate ke /tugas/:id    |
| 2    | \-                 | Fetch tugas_header        |
| 3    | \-                 | Fetch semua tugas_log     |
| 4    | \-                 | Fetch petugas terkait     |
| 5    | \-                 | Render detail page        |
| 6    | \-                 | Render peta dengan marker |
| 7    | \-                 | Render timeline progress  |

### Alternative Flow

| Step | Actor Action          | System Response           |
| ---- | --------------------- | ------------------------- |
| 3a   | Tidak ada akses (RLS) | Tampilkan "403 Forbidden" |
| 4a   | Tugas tidak ditemukan | Tampilkan "404 Not Found" |

\--------------------------------------------------------------------------------

## UC-TUGAS-005: Submit Progress (Before)

| Field             | Detail                                              |
| ----------------- | --------------------------------------------------- |
| **Use Case ID**   | UC-TUGAS-005                                        |
| **Use Case Name** | Submit Progress Tahapan Before                      |
| **Actor**         | Petugas                                             |
| **Goal**          | Petugas dapat submit laporan tahapan awal pekerjaan |
| **Trigger**       | Petugas mengklik "Isi Laporan" di detail tugas      |

### Pre-Condition

- Actor telah login sebagai Petugas
- Actor ditugaskan pada tugas tersebut
- Tugas berstatus "Menunggu"

### Post-Condition (Success)

- Log berhasil disimpan
- Status tugas berubah menjadi "Proses"
- Notifikasi sukses ditampilkan

### Post-Condition (Failure)

- Foto kurang dari 1
- Foto lebih dari 3
- GPS tidak tersedia
- Form tidak valid

### Flow of Events

| Step | Actor Action                | System Response                |
| ---- | --------------------------- | ------------------------------ |
| 1    | Klik "Isi Laporan"          | Tampilkan form log             |
| 2    | Pilih tahapan: "Before"     | \-                             |
| 3    | Ambil foto bukti (1-3 foto) | Kompres foto                   |
| 4    | Aktifkan GPS                | Request location               |
| 5    | Isi deskripsi pekerjaan     | \-                             |
| 6    | Submit form                 | Validasi data                  |
| 7    | \-                          | Upload foto ke storage         |
| 8    | \-                          | Insert ke tugas_log            |
| 9    | \-                          | Trigger update status "Proses" |
| 10   | \-                          | Invalidate cache               |
| 11   | \-                          | Tampilkan sukses               |
| 12   | \-                          | Refresh detail                 |

### Validasi Checklist

| Field     | Rule                   | Error Message                     |
| --------- | ---------------------- | --------------------------------- |
| foto      | 1 &lt;= jumlah &lt;= 3 | "Minimal 1 foto, maksimal 3 foto" |
| foto      | format JPG/PNG/WebP    | "Format foto tidak didukung"      |
| foto      | size &lt;= 5MB         | "Ukuran foto maksimal 5MB"        |
| gps       | required               | "Lokasi wajib diisi"              |
| deskripsi | max 1000 char          | "Deskripsi terlalu panjang"       |

### Alternative Flow

| Step | Actor Action       | System Response             |
| ---- | ------------------ | --------------------------- |
| 4a   | GPS tidak tersedia | Minta izin lokasi           |
| 4b   | Izin ditolak       | Tampilkan error, stop       |
| 7a   | Upload gagal       | Tampilkan error, stop       |
| 9a   | Trigger error      | Log error, tetap simpan log |

\--------------------------------------------------------------------------------

## UC-TUGAS-006: Submit Progress (Ongoing)

| Field             | Detail                                                    |
| ----------------- | --------------------------------------------------------- |
| **Use Case ID**   | UC-TUGAS-006                                              |
| **Use Case Name** | Submit Progress Tahapan Ongoing                           |
| **Actor**         | Petugas                                                   |
| **Goal**          | Petugas dapat submit laporan tahapan proses pekerjaan     |
| **Trigger**       | Petugas mengklik "Isi Laporan" saat tugas sedang "Proses" |

### Pre-Condition

- Actor telah login sebagai Petugas
- Actor ditugaskan pada tugas tersebut
- Tugas berstatus "Proses" (sudah ada log Before)

### Post-Condition (Success)

- Log berhasil disimpan
- Status tetap "Proses"

### Flow of Events

| Step | Actor Action                | System Response        |
| ---- | --------------------------- | ---------------------- |
| 1    | Klik "Isi Laporan"          | Tampilkan form log     |
| 2    | Pilih tahapan: "Ongoing"    | \-                     |
| 3    | Ambil foto bukti (1-3 foto) | Kompres foto           |
| 4    | Aktifkan GPS                | Request location       |
| 5    | Isi deskripsi pekerjaan     | \-                     |
| 6    | Submit form                 | Validasi data          |
| 7    | \-                          | Upload foto ke storage |
| 8    | \-                          | Insert ke tugas_log    |
| 9    | \-                          | Status tetap "Proses"  |
| 10   | \-                          | Invalidate cache       |
| 11   | \-                          | Tampilkan sukses       |

### Business Rules

| Rule ID | Description                                        |
| ------- | -------------------------------------------------- |
| BR-007  | Tahapan Ongoing hanya bisa disubmit setelah Before |
| BR-008  | Status tidak berubah saat submit Ongoing           |

\--------------------------------------------------------------------------------

## UC-TUGAS-007: Submit Progress (Finished)

| Field             | Detail                                                        |
| ----------------- | ------------------------------------------------------------- |
| **Use Case ID**   | UC-TUGAS-007                                                  |
| **Use Case Name** | Submit Progress Tahapan Finished                              |
| **Actor**         | Petugas                                                       |
| **Goal**          | Petugas dapat menyelesaikan tugas dengan submit laporan akhir |
| **Trigger**       | Petugas mengklik "Isi Laporan" untuk tahap akhir              |

### Pre-Condition

- Actor telah login sebagai Petugas
- Actor ditugaskan pada tugas tersebut
- Sudah ada log Before dan Ongoing

### Post-Condition (Success)

- Log berhasil disimpan
- Status tugas berubah menjadi "Selesai"

### Flow of Events

| Step | Actor Action                | System Response                 |
| ---- | --------------------------- | ------------------------------- |
| 1    | Klik "Isi Laporan"          | Tampilkan form log              |
| 2    | Pilih tahapan: "Finished"   | \-                              |
| 3    | Ambil foto bukti (1-3 foto) | Kompres foto                    |
| 4    | Aktifkan GPS                | Request location                |
| 5    | Isi deskripsi pekerjaan     | \-                              |
| 6    | Submit form                 | Validasi data                   |
| 7    | \-                          | Upload foto ke storage          |
| 8    | \-                          | Insert ke tugas_log             |
| 9    | \-                          | Trigger update status "Selesai" |
| 10   | \-                          | Invalidate cache                |
| 11   | \-                          | Tampilkan sukses                |

### Business Rules

| Rule ID | Description                                                 |
| ------- | ----------------------------------------------------------- |
| BR-009  | Tahapan Finished harus submit setelah Before dan Ongoing    |
| BR-010  | Status berubah menjadi "Selesai" saat log Finished inserted |
| BR-011  | Trigger: trg_update_status_tugas                            |

\--------------------------------------------------------------------------------

## UC-TUGAS-008: Mengunggah Foto Bukti

| Field             | Detail                                                |
| ----------------- | ----------------------------------------------------- |
| **Use Case ID**   | UC-TUGAS-008                                          |
| **Use Case Name** | Mengunggah Foto Bukti                                 |
| **Actor**         | Petugas (System sebagai supporting)                   |
| **Goal**          | Petugas dapat mengunggah foto sebagai bukti pekerjaan |
| **Trigger**       | Petugas memilih foto di form log                      |

### Pre-Condition

- Foto sudah dipilih dari galeri/kamera
- Format foto valid

### Post-Condition (Success)

- Foto ter-upload ke Supabase Storage
- URL foto tersimpan untuk insert ke database

### Flow of Events

| Step | Actor Action          | System Response               |
| ---- | --------------------- | ----------------------------- |
| 1    | Pilih file foto (1-3) | Validasi format               |
| 2    | \-                    | Kompres foto (max 5MB)        |
| 3    | \-                    | Generate unique filename      |
| 4    | \-                    | Upload ke bucket "tugas-foto" |
| 5    | \-                    | Return public URL             |
| 6    | \-                    | Display preview               |

### Validasi Foto

| Rule        | Value            |
| ----------- | ---------------- |
| Jumlah      | 1 - 3 foto       |
| Format      | JPG, PNG, WebP   |
| Ukuran      | Max 5MB per foto |
| Resolution  | Min 640x480      |
| Compression | Target max 500KB |

### Business Rules

| Rule ID | Description                           |
| ------- | ------------------------------------- |
| BR-012  | Foto disimpan di bucket "tugas-foto"  |
| BR-013  | URL foto adalah public URL            |
| BR-014  | Foto tidak dihapus saat tugas dihapus |

\--------------------------------------------------------------------------------

## UC-TUGAS-009: Memilih Lokasi GPS

| Field             | Detail                                       |
| ----------------- | -------------------------------------------- |
| **Use Case ID**   | UC-TUGAS-009                                 |
| **Use Case Name** | Memilih Lokasi GPS                           |
| **Actor**         | Petugas (System sebagai supporting)          |
| **Goal**          | Mendapatkan koordinat lokasi saat submit log |
| **Trigger**       | Petugas mengaktifkan GPS di form log         |

### Pre-Condition

- Browser mendukung Geolocation API
- Izin lokasi diberikan

### Post-Condition (Success)

- Koordinat latitude dan longitude diperoleh
- Koordinat siap disimpan ke database

### Post-Condition (Failure)

- GPS tidak tersedia
- Izin lokasi ditolak
- Timeout saat mengambil lokasi

### Flow of Events

| Step | Actor Action        | System Response          |
| ---- | ------------------- | ------------------------ |
| 1    | Klik "Aktifkan GPS" | Cek dukungan browser     |
| 2    | \-                  | Request Geolocation API  |
| 3    | \-                  | Cek izin lokasi          |
| 4    | Berikan izin        | Get current position     |
| 5    | \-                  | Return {lat, lng}        |
| 6    | \-                  | Tampilkan di map preview |
| 7    | \-                  | Set hidden input         |

### Alternative Flow

| Step | Actor Action       | System Response                          |
| ---- | ------------------ | ---------------------------------------- |
| 4a   | Tolak izin         | Tampilkan error "Izinkan akses lokasi"   |
| 5a   | GPS tidak tersedia | Tampilkan error "GPS tidak tersedia"     |
| 5b   | Timeout (&gt;30s)  | Tampilkan error "Gagal mengambil lokasi" |

### Data Format

| Field     | Type          | Precision        |
| --------- | ------------- | ---------------- |
| latitude  | DECIMAL(10,8) | 8 decimal places |
| longitude | DECIMAL(11,8) | 8 decimal places |

\--------------------------------------------------------------------------------

## UC-TUGAS-010: Mengubah Status Tugas

| Field             | Detail                                           |
| ----------------- | ------------------------------------------------ |
| **Use Case ID**   | UC-TUGAS-010                                     |
| **Use Case Name** | Mengubah Status Tugas (Auto)                     |
| **Actor**         | System                                           |
| **Goal**          | Otomatis mengubah status berdasarkan tahapan log |
| **Trigger**       | Insert new tugas_log                             |

### Pre-Condition

- Ada insert baru di tabel tugas_log
- Trigger trg_update_status_tugas aktif

### Post-Condition (Success)

- Status_tugas di tugas_header ter-update

### Status Transition Logic

| Tahapan Log | Status Sebelum | Status Sesudah |
| ----------- | -------------- | -------------- |
| Before      | Menunggu       | Proses         |
| Ongoing     | Proses         | Proses         |
| Finished    | Proses         | Selesai        |

### Flow of Events (System/Trigger)

| Step | System Action                           |
| ---- | --------------------------------------- |
| 1    | Trigger fires AFTER INSERT on tugas_log |
| 2    | Get tahapan from new log                |
| 3    | Check current status_tugas              |
| 4    | Determine new status based on logic     |
| 5    | UPDATE tugas_header SET status_tugas    |
| 6    | Log trigger execution                   |

### Business Rules

| Rule ID | Description                             |
| ------- | --------------------------------------- |
| BR-015  | Trigger: trg_update_status_tugas        |
| BR-016  | Function: update_status_tugas_on_log()  |
| BR-017  | Status only changes forward (no revert) |

\--------------------------------------------------------------------------------

## UC-TUGAS-011: Memverifikasi Completion

| Field             | Detail                                                 |
| ----------------- | ------------------------------------------------------ |
| **Use Case ID**   | UC-TUGAS-011                                           |
| **Use Case Name** | Memverifikasi Completion Tugas                         |
| **Actor**         | Kepala Sesi, Operator                                  |
| **Goal**          | Memverifikasi bahwa tugas telah selesai sesuai standar |
| **Trigger**       | Kepala Sesi mengakses tugas berstatus "Selesai"        |

### Pre-Condition

- Actor adalah Kepala Sesi atau Operator
- Tugas berstatus "Selesai"

### Post-Condition (Success)

- Completion terverifikasi
- Data siap untuk laporan

### Flow of Events

| Step | Actor Action                         | System Response           |
| ---- | ------------------------------------ | ------------------------- |
| 1    | Filter tugas dengan status "Selesai" | Fetch data                |
| 2    | Pilih tugas                          | Tampilkan detail          |
| 3    | Review foto bukti                    | Display gallery           |
| 4    | Review timeline progress             | Display log history       |
| 5    | Review lokasi                        | Display map dengan marker |
| 6    | Verifikasi kelengkapan               | Check all stages          |
| 7    | Tandai verified (opsional)           | Update field              |

### Verification Checklist

| Item          | Description                  |
| ------------- | ---------------------------- |
| Foto Before   | Minimal 1 foto tahap awal    |
| Foto Ongoing  | Minimal 1 foto tahap proses  |
| Foto Finished | Minimal 1 foto tahap selesai |
| GPS Before    | Koordinat tersedia           |
| GPS Ongoing   | Koordinat tersedia           |
| GPS Finished  | Koordinat tersedia           |
| Deskripsi     | Semua log memiliki deskripsi |

\--------------------------------------------------------------------------------

## Summary Table

| UC ID        | UC Name                    | Actor                 | Pre-Conditions                     | Post-Conditions (Success)      |
| ------------ | -------------------------- | --------------------- | ---------------------------------- | ------------------------------ |
| UC-TUGAS-001 | Membuat Tugas Baru         | Kepala Sesi           | Login, Role=Kepala Sesi            | Tugas created, status=Menunggu |
| UC-TUGAS-002 | Mengelola Penugasan        | Kepala Sesi           | Login, Role=Kepala Sesi            | Penugasan updated              |
| UC-TUGAS-003 | Melihat Daftar Tugas       | All                   | Login                              | List tugas sesuai role         |
| UC-TUGAS-004 | Melihat Detail Tugas       | All                   | Login, Akses allowed               | Detail lengkap ditampilkan     |
| UC-TUGAS-005 | Submit Progress (Before)   | Petugas               | Login, Ditugaskan, Status=Menunggu | Log saved, status=Proses       |
| UC-TUGAS-006 | Submit Progress (Ongoing)  | Petugas               | Login, Ditugaskan, Status=Proses   | Log saved, status=Proses       |
| UC-TUGAS-007 | Submit Progress (Finished) | Petugas               | Login, Ditugaskan, Ada log prev    | Log saved, status=Selesai      |
| UC-TUGAS-008 | Mengunggah Foto Bukti      | Petugas               | Foto selected                      | URL tersimpan                  |
| UC-TUGAS-009 | Memilih Lokasi GPS         | Petugas               | GPS available, Izin given          | Koordinat obtained             |
| UC-TUGAS-010 | Mengubah Status Tugas      | System                | Insert tugas_log                   | Status updated                 |
| UC-TUGAS-011 | Verifikasi Completion      | Kepala Sesi, Operator | Login, Status=Selesai              | Completion verified            |

\--------------------------------------------------------------------------------

## Trigger Reference

```
-- Trigger: trg_update_status_tugas
-- Table: tugas_log
-- Event: AFTER INSERT
-- Function: update_status_tugas_on_log()

CREATE OR REPLACE FUNCTION update_status_tugas_on_log()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.tahapan IN ('Before', 'Ongoing') THEN
        UPDATE tugas_header
        SET status_tugas = 'Proses', updated_at = NOW()
        WHERE id = NEW.id_tugas;
    ELSIF NEW.tahapan = 'Finished' THEN
        UPDATE tugas_header
        SET status_tugas = 'Selesai', updated_at = NOW()
        WHERE id = NEW.id_tugas;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

```

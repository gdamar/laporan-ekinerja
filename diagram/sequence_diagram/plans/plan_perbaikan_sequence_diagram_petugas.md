# Rencana Perbaikan Sequence Diagram Petugas (E-Kinerja)

Dokumen ini memuat analisis permasalahan, strategi perbaikan tata letak geometri, rancangan detail alur proses tiap halaman diagram, serta rencana verifikasi untuk berkas [`diagram/sequence_diagram/sequence_rad_revised_petugas_updated.drawio`](file:///C:/Users/openl/gdamar/laporan-ekinerja/diagram/sequence_diagram/sequence_rad_revised_petugas_updated.drawio).

---

## 1. Goal Description

Berdasarkan hasil telaah terhadap berkas [`sequence_rad_revised_petugas_updated.drawio`](file:///C:/Users/openl/gdamar/laporan-ekinerja/diagram/sequence_diagram/sequence_rad_revised_petugas_updated.drawio) dan berkas referensi pada folder [`diagram/sequence_diagram/images`](file:///C:/Users/openl/gdamar/laporan-ekinerja/diagram/sequence_diagram/images) (`activation_box.png`, `crud_example.png`, dan `read_example.png`), ditemukan dua masalah utama:

1. **Penempatan panah pesan (request dan response) tidak simetris / tidak horizontal dan meleset dari activation box:**
   - Koordinat Y sumber (`sourcePoint`) dan Y target (`targetPoint`) pada pesan request/response tidak sama (misalnya $y=285 \rightarrow y=290$, $y=336.08 \rightarrow y=360$, $y=425 \rightarrow y=406$, dsb.), sehingga garis panah miring / tidak tegak lurus (diagonal).
   - Titik X panah diarahkan ke garis sumbu lifeline ($x=100, 320, 540, 760$) dan bukan ke tepi batas luar activation box ($x=108, 312, 328, 532, 548, 752$). Hal ini menyebabkan panah menusuk ke dalam activation box atau menggantung di luar activation box.
   - Durasi/tinggi activation box tidak sinkron dengan kedatangan dan balikan pesan, serta terdapat beberapa activation box melayang tanpa pemicu pesan yang jelas.

2. **Alternative frame terlalu ke bawah dan kurang merepresentasikan detail alur:**
   - Seluruh alternative frame pada diagram Petugas diposisikan secara mekanis jauh di bawah ($y=700$ atau $y=600$), terpisah dari alur pesan utama ($y=220 \dots 565$).
   - Isi di dalam alternative frame sangat minim (hanya 1-2 pesan dummy seperti *"Menampilkan pesan kesalahan"* di $y=850$ dan self-arrow *"Memperbaiki/Memuat ulang"* di $y=960$).
   - Alur bisnis inti yang sebenarnya (misalnya aktor menginput form, mengunggah bukti/GPS, sistem melakukan validasi, lalu menyimpan ke database jika valid, atau menampilkan pesan kesalahan jika tidak valid sebagaimana dicontohkan pada `read_example.png` dan `crud_example.png`) belum tergambar di dalam diagram.

Rencana ini bertujuan merekonstruksi ke-9 diagram sequence Petugas (serta membersihkan halaman duplikat usang) agar presisi secara geometris, konsisten dengan aturan notasi UML proyek, dan mencerminkan alur bisnis use case serta activity diagram secara utuh.

---

## 2. User Review Required

> [!IMPORTANT]
> **Keputusan Struktur Halaman (Berdasarkan Arahan User):**
> - **Perubahan HANYA dilakukan pada diagram halaman 13 s.d. 21.**
> - **Di bawah halaman 13 (Halaman 1 s.d. 12) TIDAK DILAKUKAN PERUBAHAN SAMA SEKALI.**
> - Ke-9 halaman Petugas (Halaman 13-21) akan direkonstruksi secara penuh dengan geometri horizontal presisi, hooking activation box sempurna, serta alur detail di dalam alternative frame.

> [!WARNING]
> **Penulisan Istilah:** Sesuai aturan direktif Iterasi #4, istilah *"progress laporan"* telah diselaraskan menjadi *"status pengerjaan"*, dan pesan pada sequence diagram disederhanakan menggunakan kata kerja tindakan umum (misalnya: *Akses ...*, *Minta ...*, *Kirim ...*, *Validasi ...*, *Simpan ...*, *Kembalikan ...*, *Tampilkan ...*).

---

## 3. Standar Geometri & Notasi (Mengacu pada Gambar Referensi)

Berdasarkan telaah mendalam terhadap `activation_box.png`, `crud_example.png`, dan `read_example.png`:

```
Lifeline 0 (Actor)      Lifeline 1 (Boundary)    Lifeline 2 (Control)     Lifeline 3 (Entity)
Center: X=100           Center: X=320            Center: X=540            Center: X=760
Act: [92..108]          Act: [312..328]          Act: [532..548]          Act: [752..768]
     |                        |                        |                        |
     |--- Akses menu -------->|                        |                        |  (Y=220) [108 -> 312]
     |                        |--- Minta data -------->|                        |  (Y=280) [328 -> 532]
     |                        |                        |--- Query DB ---------->|  (Y=340) [548 -> 752]
     |                        |                        |<-- Return data --------|  (Y=400) [752 -> 548, dashed]
     |                        |<-- Kirim data ---------|                        |  (Y=460) [532 -> 328, dashed]
     |<-- Tampilkan data -----|                        |                        |  (Y=520) [312 -> 108, dashed]
```

### Aturan Geometri Panah & Activation Box:
1. **Panah Horizontal Mutlak**: Setiap panah memiliki $y_{\text{source}} == y_{\text{target}}$. Tidak boleh ada kemiringan vertikal ($|\Delta y| = 0$).
2. **Hooking Tepat pada Sisi Activation Box**:
   - Actor $\rightarrow$ Boundary: $x_1 = 108, x_2 = 312$ (panjang = 204px).
   - Boundary $\rightarrow$ Actor: $x_1 = 312, x_2 = 108$.
   - Boundary $\rightarrow$ Sistem: $x_1 = 328, x_2 = 532$ (panjang = 204px).
   - Sistem $\rightarrow$ Boundary: $x_1 = 532, x_2 = 328$.
   - Sistem $\rightarrow$ Database: $x_1 = 548, x_2 = 752$ (panjang = 204px).
   - Database $\rightarrow$ Sistem: $x_1 = 752, x_2 = 548$.
   - Self-call Sistem (Validasi): Titik awal di $x=548, y$, melengkung ke $x=575$, kembali ke $x=548, y+25$.
3. **Activation Box Tersegmentasi**:
   - Lebar activation box adalah $16\text{px}$, berpusat pada lifeline.
   - Database hanya aktif saat menerima kueri dari Sistem hingga mengirimkan balikan data (idle di luar itu).
   - Sistem hanya aktif selama menerima request, memproses, memvalidasi, dan meneruskan hasil.
   - Boundary aktif saat menerima interaksi pengguna hingga merespons kembali ke aktor.
4. **Alternative Frame Proporsional**:
   - Frame `alt` diletakkan tepat pada titik terjadinya percabangan (setelah tahap validasi / pengecekan data).
   - Header frame murni teks `"alt"` dengan shape `umlFrame` ($w=780, h=\dots$), dan label kasus di sampingnya bertuliskan `[Nama Kasus]` sebagai child label independen.
   - Pembatas antar kondisi menggunakan garis putus-putus (`dashed=1;endArrow=none;`) dengan label `else` di bawah garis pembatas.

---

## 4. Proposed Changes: Rincian Alur 9 Diagram Petugas

Berikut adalah rancangan alur proses dan pembagian alternatif untuk masing-masing dari 9 sequence diagram Petugas:

---

### Page 13: Login Petugas
- **Actor**: `Petugas`
- **Boundary**: `Halaman Login`
- **Control**: `Sistem`
- **Entity**: `Database`

```mermaid
sequenceDiagram
    autonumber
    actor P as Petugas
    participant B as Halaman Login
    participant S as Sistem
    participant D as Database

    P->>B: Membuka halaman login
    B-->>P: Menampilkan form login
    P->>B: Memasukkan username dan password & klik login
    B->>S: Kirim kredensial login
    S->>D: Periksa data akun (username & password)
    D-->>S: Mengembalikan data akun
    S->>S: Validasi kecocokan kredensial
    
    alt [Kredensial valid]
        S-->>B: Autentikasi berhasil & buat sesi
        B-->>P: Redirect ke halaman Dashboard
    else [Kredensial tidak valid]
        S-->>B: Mengembalikan pesan login gagal
        B-->>P: Menampilkan pesan kesalahan kredensial
    end
```

---

### Page 14: Membuat Laporan Pengerjaan Tugas
- **Actor**: `Petugas`
- **Boundary**: `Form Laporan Tugas`
- **Control**: `Sistem`
- **Entity**: `Database`

```mermaid
sequenceDiagram
    autonumber
    actor P as Petugas
    participant B as Form Laporan Tugas
    participant S as Sistem
    participant D as Database

    P->>B: Pilih tugas & klik isi laporan
    B->>S: Minta form laporan & detail tugas
    S->>D: Ambil data penugasan
    D-->>S: Mengembalikan data penugasan
    S-->>B: Menampilkan form laporan tugas
    P->>B: Input deskripsi, unggah foto bukti & lokasi GPS
    B->>S: Kirim data laporan pengerjaan
    S->>S: Validasi kelengkapan data & format bukti
    
    alt [Data laporan valid]
        S->>D: Simpan data laporan & update status pengerjaan
        D-->>S: Data laporan berhasil disimpan
        S-->>B: Mengembalikan konfirmasi sukses
        B-->>P: Menampilkan notifikasi laporan berhasil disimpan
    else [Data laporan tidak valid]
        S-->>B: Mengembalikan pesan kesalahan validasi
        B-->>P: Menampilkan pesan error & form laporan
    end
```

---

### Page 15: Melihat Log Laporan
- **Actor**: `Petugas`
- **Boundary**: `Halaman Log Laporan`
- **Control**: `Sistem`
- **Entity**: `Database`

```mermaid
sequenceDiagram
    autonumber
    actor P as Petugas
    participant B as Halaman Log Laporan
    participant S as Sistem
    participant D as Database

    P->>B: Mengakses menu Log Laporan
    B->>S: Minta daftar log pengerjaan tugas
    S->>D: Ambil riwayat log laporan petugas
    D-->>S: Mengembalikan data log laporan
    S->>S: Periksa ketersediaan data log
    
    alt [Data log tersedia]
        S-->>B: Mengirimkan daftar log laporan
        B-->>P: Menampilkan tabel log pengerjaan beserta status
        opt Pilih detail log
            P->>B: Klik lihat detail log
            B-->>P: Menampilkan foto bukti, GPS, dan rincian log
        end
    else [Data log tidak tersedia]
        S-->>B: Mengembalikan status log kosong
        B-->>P: Menampilkan pesan data log belum tersedia
    end
```

---

### Page 16: Melihat Daftar Riwayat Tugas
- **Actor**: `Petugas`
- **Boundary**: `Halaman Riwayat Tugas`
- **Control**: `Sistem`
- **Entity**: `Database`

```mermaid
sequenceDiagram
    autonumber
    actor P as Petugas
    participant B as Halaman Riwayat Tugas
    participant S as Sistem
    participant D as Database

    P->>B: Mengakses menu Tugas & pilih riwayat tugas
    B->>S: Minta daftar riwayat tugas petugas
    S->>D: Ambil riwayat tugas dari database
    D-->>S: Mengembalikan data riwayat tugas
    S->>S: Periksa ketersediaan riwayat
    
    alt [Data riwayat tersedia]
        S-->>B: Mengirimkan daftar riwayat tugas
        B-->>P: Menampilkan tabel riwayat tugas selesai
    else [Data riwayat tidak tersedia]
        S-->>B: Mengembalikan status data kosong
        B-->>P: Menampilkan pesan riwayat tugas belum ada
    end
```

---

### Page 17: Melihat Kuota Cuti
- **Actor**: `Petugas`
- **Boundary**: `Halaman Kuota Cuti`
- **Control**: `Sistem`
- **Entity**: `Database`

```mermaid
sequenceDiagram
    autonumber
    actor P as Petugas
    participant B as Halaman Kuota Cuti
    participant S as Sistem
    participant D as Database

    P->>B: Mengakses informasi kuota cuti
    B->>S: Minta data kuota cuti petugas
    S->>D: Ambil kuota tahunan dan cuti terpakai
    D-->>S: Mengembalikan data cuti
    S->>S: Hitung sisa kuota cuti aktif
    
    alt [Data kuota tersedia]
        S-->>B: Mengirimkan informasi total & sisa kuota
        B-->>P: Menampilkan kartu rincian sisa kuota cuti
    else [Data kuota tidak tersedia]
        S-->>B: Mengembalikan status data kuota tidak ditemukan
        B-->>P: Menampilkan pesan informasi kuota tidak tersedia
    end
```

---

### Page 18: Mengajukan Cuti
- **Actor**: `Petugas`
- **Boundary**: `Form Pengajuan Cuti`
- **Control**: `Sistem`
- **Entity**: `Database`

```mermaid
sequenceDiagram
    autonumber
    actor P as Petugas
    participant B as Form Pengajuan Cuti
    participant S as Sistem
    participant D as Database

    P->>B: Membuka form pengajuan cuti
    B->>S: Minta form & data sisa kuota cuti
    S->>D: Ambil sisa kuota cuti petugas
    D-->>S: Mengembalikan sisa kuota cuti
    S-->>B: Menampilkan form cuti & sisa kuota
    P->>B: Mengisi periode, alasan cuti & lampiran
    B->>S: Kirim data pengajuan cuti
    S->>S: Validasi kecukupan kuota & kelengkapan data
    
    alt [Pengajuan valid]
        S->>D: Simpan pengajuan cuti (status Menunggu)
        D-->>S: Pengajuan berhasil disimpan
        S-->>B: Mengembalikan konfirmasi pengajuan berhasil
        B-->>P: Menampilkan notifikasi pengajuan berhasil diajukan
    else [Kuota tidak mencukupi / Data tidak valid]
        S-->>B: Mengembalikan pesan penolakan validasi
        B-->>P: Menampilkan pesan kesalahan pengajuan
    end
```

---

### Page 19: Melihat Riwayat Cuti
- **Actor**: `Petugas`
- **Boundary**: `Halaman Riwayat Cuti`
- **Control**: `Sistem`
- **Entity**: `Database`

```mermaid
sequenceDiagram
    autonumber
    actor P as Petugas
    participant B as Halaman Riwayat Cuti
    participant S as Sistem
    participant D as Database

    P->>B: Mengakses menu Riwayat Cuti
    B->>S: Minta daftar pengajuan cuti petugas
    S->>D: Ambil data pengajuan & status cuti
    D-->>S: Mengembalikan data pengajuan cuti
    S->>S: Periksa ketersediaan riwayat
    
    alt [Terdapat riwayat cuti]
        S-->>B: Mengirimkan daftar riwayat cuti
        B-->>P: Menampilkan riwayat cuti beserta status persetujuan
    else [Belum ada pengajuan]
        S-->>B: Mengembalikan status riwayat kosong
        B-->>P: Menampilkan pesan belum ada pengajuan cuti
    end
```

---

### Page 20: Melihat Daftar Penilaian
- **Actor**: `Petugas`
- **Boundary**: `Halaman Penilaian Petugas`
- **Control**: `Sistem`
- **Entity**: `Database`

```mermaid
sequenceDiagram
    autonumber
    actor P as Petugas
    participant B as Halaman Penilaian Petugas
    participant S as Sistem
    participant D as Database

    P->>B: Mengakses halaman daftar penilaian
    B->>S: Minta data penilaian kinerja petugas
    S->>D: Ambil data nilai dan akumulasi skor
    D-->>S: Mengembalikan data penilaian
    S->>S: Periksa status publikasi nilai
    
    alt [Data penilaian tersedia]
        S-->>B: Mengirimkan data penilaian & total skor
        B-->>P: Menampilkan daftar nilai dan total capaian
    else [Data penilaian belum tersedia]
        S-->>B: Mengembalikan status penilaian belum ada
        B-->>P: Menampilkan pesan data penilaian belum tersedia
    end
```

---

### Page 21: Mengajukan Banding
- **Actor**: `Petugas`
- **Boundary**: `Form Pengajuan Banding`
- **Control**: `Sistem`
- **Entity**: `Database`

```mermaid
sequenceDiagram
    autonumber
    actor P as Petugas
    participant B as Form Pengajuan Banding
    participant S as Sistem
    participant D as Database

    P->>B: Pilih penilaian yang ingin dibanding
    B->>S: Minta form banding & rincian nilai
    S->>D: Ambil data penilaian yang dipilih
    D-->>S: Mengembalikan data penilaian
    S-->>B: Menampilkan form pengajuan banding
    P->>B: Mengisi alasan banding & dokumen pendukung
    B->>S: Kirim pengajuan banding
    S->>S: Validasi alasan & kelengkapan berkas banding
    
    alt [Data banding valid]
        S->>D: Simpan data banding (status Menunggu Pemeriksaan)
        D-->>S: Data banding berhasil disimpan
        S-->>B: Mengembalikan konfirmasi berhasil
        B-->>P: Menampilkan notifikasi banding berhasil diajukan
    else [Data banding tidak valid]
        S-->>B: Mengembalikan pesan kesalahan validasi
        B-->>P: Menampilkan pesan error & form banding
    end
```

---

## 5. Rencana Modifikasi Berkas

### A. Diagram Draw.io (`diagram/sequence_diagram/sequence_rad_revised_petugas_updated.drawio`)
1. **Halaman 1 s.d. 12 Dipertahankan Utuh**: Tidak ada modifikasi atau penghapusan pada halaman 1 sampai dengan 12.
2. **Rekonstruksi Halaman Petugas (Halaman 13 s.d. 21)**:
   - Menghitung ulang seluruh koordinat elemen pada ke-9 diagram Petugas.
   - Mengatur posisi Y pesan secara strictly monotonic ($y_i < y_{i+1}$).
   - Memastikan $y_{\text{source}} == y_{\text{target}}$ pada semua pesan horizontal.
   - Menghubungkan titik panah secara presisi ke tepi activation box ($x=108, 312, 328, 532, 548, 752$).
   - Menyusun frame `alt` di posisi yang proporsional mengelilingi cabang validasi/hasil, lengkap dengan divider garis putus-putus dan label `else`.
   - Mengatur activation box agar hanya aktif pada fase eksekusi terkait dan tidak monolitik.

### B. Dokumentasi Review (`diagram/sequence_diagram/sequence_rad_revised-review.md`)
- Menambahkan bab **Sequence Diagram Review - Iterasi Petugas (Revisi Geometri & Alur Detail)**.
- Mendokumentasikan perbaikan koordinat panah, penataan frame alternatif, segmentasi activation box, dan penghapusan halaman duplikat.

---

## 6. Verification Plan

### Automated Tests
1. **Validasi Sintaks XML**:
   Memeriksa bahwa berkas XML dapat di-parse dengan sempurna oleh `xml.etree.ElementTree` tanpa error parsing dan encoding terjaga.
2. **Pemeriksaan Geometri & Hooking Panah**:
   Menjalankan skrip Python untuk memverifikasi:
   - Nilai kemiringan panah horizontal: $\forall \text{message}, |y_{\text{src}} - y_{\text{tgt}}| == 0$.
   - Endpoint panah: $x_{\text{src}}$ dan $x_{\text{tgt}}$ berada tepat di tepi activation box terkait dan tidak ada panah melayang (*dangling*).
   - Seluruh pesan dalam frame berada dalam rentang koordinat vertikal frame ($y_{\text{frame}} \le y_{\text{msg}} \le y_{\text{frame}} + h_{\text{frame}}$).
   - Tidak ada activation box monolitik (tinggi $> 900\text{px}$).

### Manual Verification
1. Membuka diagram di visualisasi Draw.io / extension VS Code untuk memastikan seluruh teks terbaca jelas di atas panah.
2. Memastikan tidak ada garis panah yang bertumpuk atau overlap dengan kotak aktivasi.
3. Memastikan frame `alt` membungkus kedua cabang alur secara proporsional dan tidak terpotong di tepi canvas.

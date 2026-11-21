# Walkthrough: Perbaikan Sequence Diagram Petugas

Dokumen ini merangkum hasil implementasi perbaikan terhadap ke-9 diagram sequence aktor Petugas pada berkas [`diagram/sequence_diagram/sequence_rad_revised_petugas_updated.drawio`](file:///C:/Users/openl/gdamar/laporan-ekinerja/diagram/sequence_diagram/sequence_rad_revised_petugas_updated.drawio) serta pembaruan dokumentasi review di [`diagram/sequence_diagram/sequence_rad_revised-review.md`](file:///C:/Users/openl/gdamar/laporan-ekinerja/diagram/sequence_diagram/sequence_rad_revised-review.md).

---

## 1. Ringkasan Perubahan

Sesuai instruksi dan konfirmasi pengguna:
- **Halaman 1 s.d. 12 dipertahankan 100% utuh tanpa modifikasi apa pun.**
- **Perubahan difokuskan secara eksklusif pada Halaman 13 s.d. 21 (Use Case Petugas):**

| No | Halaman Diagram | ID Halaman | Perubahan Utama |
|---|---|---|---|
| 13 | `Login Petugas` | `login_petugas` | Memperbaiki perataan panah ($y_{\text{src}} == y_{\text{tgt}}$), menambahkan alur tampil form awal, submit kredensial, cek DB, validasi sesi, frame `alt` proporsional untuk kredensial valid (redirect) vs tidak valid (pesan error). |
| 14 | `Membuat Laporan Pengerjaan Tugas` | `membuat_laporan_petugas` | Melengkapi alur load detail tugas, input laporan + unggah bukti foto & GPS, validasi format/kelengkapan, dan frame `alt` simpan DB + update status pengerjaan vs validasi gagal. |
| 15 | `Melihat Log Laporan` | `melihat_log_laporan` | Melengkapi pengambilan log dari DB, frame `alt` untuk cabang data tersedia (tabel log, status, opsi modal detail bukti foto/GPS) vs data kosong (tabel pesan belum tersedia). |
| 16 | `Melihat Daftar Riwayat Tugas` | `riwayat_tugas_petugas` | Merapikan kueri riwayat tugas ke DB, perataan panah horizontal sempurna, frame `alt` daftar tugas selesai vs data belum ada. |
| 17 | `Melihat Kuota Cuti` | `kuota_cuti_petugas` | Memuat kueri kuota tahunan dan terpakai, kalkulasi sisa kuota, frame `alt` kartu rincian kuota vs data belum terkonfigurasi. |
| 18 | `Mengajukan Cuti` | `mengajukan_cuti_petugas` | Melengkapi load form cuti & sisa kuota, input periode & alasan, validasi kelayakan/kuota, dan frame `alt` simpan pengajuan (status Menunggu) vs kuota tidak cukup. |
| 19 | `Melihat Riwayat Cuti` | `riwayat_cuti_petugas` | Memuat kueri riwayat pengajuan & status approval, frame `alt` daftar pengajuan cuti vs belum ada riwayat. |
| 20 | `Melihat Daftar Penilaian` | `penilaian_petugas` | Memuat kueri penilaian kinerja & akumulasi nilai, frame `alt` rekapitulasi nilai capaian vs nilai belum dipublikasikan. |
| 21 | `Mengajukan Banding` | `banding_petugas` | Melengkapi pemilihan nilai, load form banding, input alasan & bukti sanggahan, validasi data, frame `alt` simpan pengajuan banding (status Menunggu Pemeriksaan) vs validasi gagal. |

---

## 2. Poin Perbaikan Kunci (Addressing User Concerns)

### A. Penempatan Arrow Request & Response Serta Hooking Activation Box
- **Eliminasi Kemiringan Vertikal**: Seluruh panah pesan request dan response memiliki koordinat horizontal mutlak:
  $$\forall \text{message}, \quad y_{\text{source}} == y_{\text{target}}$$
- **Presisi Titik Hooking**:
  - Panah dari Petugas ke Boundary berawal di $x=108$ dan berakhir di $x=312$.
  - Panah dari Boundary ke Sistem berawal di $x=328$ dan berakhir di $x=532$.
  - Panah dari Sistem ke Database berawal di $x=548$ dan berakhir di $x=752$.
  - Seluruh balikan respon (*dashed arrow*) terhubung dari tepi sebaliknya ($752 \to 548$, $532 \to 328$, $312 \to 108$).
  - Self-call validasi internal pada Sistem digambar melengkung rapi dari $x=548, y$ ke $x=548, y+25$ melalui waypoints di $x=575$.
- **Segmentasi Durasi**: Kotak aktivasi Database tidak lagi statis/panjang, melainkan aktif hanya pada fase transaksi kueri ($50\dots 55\text{px}$).

### B. Posisi dan Detail Proses pada Alternative Frame
- **Posisi Proporsional**: Alternative frame tidak lagi diletakkan di $y=700$ yang terisolasi di bawah, melainkan diposisikan tepat pada titik terjadinya percabangan (segera setelah tahap validasi data atau balikan kueri DB).
- **Proses Nyata & Komprehensif**: Menggantikan pesan dummy sebelumnya dengan alur interaksi bisnis yang sesuai use case scenario dan activity diagram:
  - Cabang positif: eksekusi simpan/update DB, respon data berhasil, dan notifikasi ke boundary/petugas.
  - Cabang alternatif (`else`): respon penolakan validasi/ketiadaan data dan umpan balik error form ke antarmuka.
- **Standar Label Notasi**: Frame berlabel murni `alt`, dengan label kasus `[Nama Kasus]` independen di samping label `alt`, serta pembatas garis putus-putus dengan label `else`.

---

## 3. Hasil Pengujian & Verifikasi

Skrip verifikasi otomatis `verify_petugas_diagrams.py` telah dijalankan dengan hasil:
1. **XML Parsing**: Berkas [`sequence_rad_revised_petugas_updated.drawio`](file:///C:/Users/openl/gdamar/laporan-ekinerja/diagram/sequence_diagram/sequence_rad_revised_petugas_updated.drawio) valid secara sintaks dan struktur pohon Draw.io.
2. **Pemeriksaan Kemiringan Panah**:
   - Total pesan yang diuji pada 9 halaman: **113 pesan**.
   - Jumlah pesan dengan $|\Delta y| > 0$: **0** (seluruh pesan 100% horizontal).
3. **Pemeriksaan Hooking Activation Box**:
   - Seluruh endpoint $x$ sesuai dengan pasangan batas activation box: $(108, 312)$, $(312, 108)$, $(328, 532)$, $(532, 328)$, $(548, 752)$, $(752, 548)$.
   - Tidak ada panah yang melayang (*dangling*) atau menusuk ke garis tengah lifeline.
4. **Pemeriksaan Integritas Halaman 1-12**:
   - Seluruh jumlah cell pada halaman 1 sampai 12 identik dengan kondisi awal sebelum modifikasi (tidak ada yang tersentuh).
5. **Dokumentasi Review**:
   - Bab review iterasi perbaikan telah ditambahkan ke [`sequence_rad_revised-review.md`](file:///C:/Users/openl/gdamar/laporan-ekinerja/diagram/sequence_diagram/sequence_rad_revised-review.md).

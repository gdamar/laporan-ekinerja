# Plan Eksekusi Revisi Sequence Diagram

Dokumen ini mencatat rencana revisi `sequence_rad_revised.drawio` berdasarkan `sequence_rad_revised-review.md`.

## Scope

- Hanya mengubah `sequence_rad_revised.drawio`.
- Target halaman: `login`, `kelola_tugas`, `submit_progress_tugas`, `pengajuan_cuti`, `kelola_petugas`, dan `kelola_akun`.
- PlantUML, dokumentasi Markdown lain, dan ekspor PNG menjadi referensi saja.

## Langkah

1. Audit struktur keenam halaman dan elemen message, activation, serta frame.
2. Terapkan aturan maksimal empat objek: aktor, boundary fitur, Sistem, dan Database.
3. Rapikan panjang/posisi message terhadap activation box dan teks terhadap arrow.
4. Gunakan label alternative dalam format `[Nama Case]`.
5. Pisahkan operasi CRUD menjadi frame `alt` yang terpisah pada Kelola Tugas, Kelola Petugas, dan Kelola Akun.
6. Tambahkan alternative kredensial tidak valid pada Login.
7. Ubah alur tahap Submit Progress menjadi `loop` dan hilangkan Storage sebagai objek.
8. Pertahankan hanya validasi kuota sebagai alternative pada Pengajuan Cuti.
9. Validasi XML, halaman target, jumlah objek, dan konsistensi frame/message.

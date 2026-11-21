# Plan Pembuatan Use Case Diagram Petugas

## Tujuan

Membuat use case diagram baru khusus aktor **Petugas** berdasarkan activity
diagram Petugas dan use case scenario pada dokumen thesis, tanpa menimpa
diagram use case gabungan yang sudah ada.

## Referensi utama

- Activity diagram: `diagram/activity/activity_rest_updated.drawio.xml`
- Use case scenario: `draft_TA_20104057_Gregorius Damar(3).docx`
- Referensi visual dan penamaan: `diagram/usecase/use_case_updated.drawio.xml`

## File keluaran

- Diagram: `diagram/usecase/use_case_petugas_updated.drawio.xml`
- Dokumen plan: `diagram/usecase/plan_use_case_petugas.md`

## Cakupan use case

Diagram memuat aktor `Petugas` dan sembilan use case berikut:

1. `Login`
2. `Membuat laporan pengerjaan tugas`
3. `Melihat log laporan`
4. `Melihat daftar riwayat tugas`
5. `Melihat kuota cuti`
6. `Mengajukan cuti`
7. `Melihat riwayat cuti`
8. `Melihat daftar penilaian`
9. `Mengajukan banding`

Use case dikelompokkan ke dalam:

- `Tugas`: laporan pengerjaan, log laporan, dan riwayat tugas.
- `Cuti`: kuota cuti, pengajuan cuti, dan riwayat cuti.
- `Penilaian`: daftar penilaian dan pengajuan banding.

## Keputusan pemodelan

- `Petugas` menjadi satu-satunya aktor utama dan ditempatkan di luar system
  boundary.
- `Login` menjadi use case mandiri yang terhubung langsung ke Petugas.
  Diagram tidak mengulang relasi login ke setiap fitur.
- `Melihat log laporan` ditempatkan di kelompok `Tugas`.
- Detail langkah seperti upload bukti, pengisian periode cuti, validasi, dan
  status hasil tetap dijelaskan oleh activity diagram atau use case scenario,
  bukan dipecah menjadi oval tambahan.
- Aktor pemeriksa banding atau approver cuti tidak dimasukkan karena diagram
  dibatasi pada use case yang dilakukan Petugas.
- Relasi `<<include>>` atau `<<extend>>` hanya digunakan bila fungsi yang
  dimodelkan benar-benar merupakan use case mandiri; diagram ini berfokus pada
  asosiasi Petugas dengan fungsi utamanya.

## Tata letak dan konvensi

- XML Draw.io dibuat uncompressed agar mudah dibaca dan diedit.
- Aktor menggunakan style UML actor yang sama dengan artefak existing.
- Use case menggunakan ellipse.
- System boundary dan kelompok fitur menggunakan rectangle berlabel.
- Petugas ditempatkan di sisi kiri; Login di bagian atas; kelompok Tugas,
  Cuti, dan Penilaian disusun di dalam boundary.
- Asosiasi aktor-use case menggunakan garis solid tanpa label.
- Istilah dan kapitalisasi mengikuti activity diagram serta use case scenario.

## Validasi

- XML dapat diparse sebagai dokumen yang well-formed.
- System boundary dan kelompok fitur ada.
- Aktor Petugas berada di luar boundary.
- Seluruh sembilan use case berada di dalam boundary dan kelompok yang sesuai.
- Setiap edge memiliki source dan target yang valid.
- Diagram existing tidak diubah.

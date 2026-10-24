# Plan Pemisahan Alternative Case Diagram Approval Cuti

## Tujuan

Memisahkan alur alternatif pada proses approval cuti menjadi diagram sequence yang berdiri sendiri agar setiap aksi approval mudah dibaca, direview, dan dirujuk.

## Hasil yang Dibuat

1. `puml/approval_cuti_overview.puml`
   - Menampilkan konteks proses approval dan tiga cabang aksi.
2. `puml/approval_cuti_setujui.puml`
   - Alur persetujuan cuti.
   - Memproses pengurangan kuota apabila jenis cuti adalah Tahunan.
3. `puml/approval_cuti_tolak.puml`
   - Alur penolakan cuti.
   - Tidak mengubah kuota.
4. `puml/approval_cuti_tangguhkan.puml`
   - Alur penangguhan cuti.
   - Tidak mengubah kuota.

## Aturan Konsistensi

- Setiap diagram detail harus dapat dibaca secara mandiri.
- Aktor yang berwenang adalah Operator dan Kepala Seksi.
- Semua alur dimulai dari daftar pengajuan dengan status `Menunggu`.
- Setiap perubahan menyimpan `approved_by` dan `updated_at`.
- Setelah berhasil, cache daftar/detail di-invalidasi dan daftar diperbarui.
- File `approval_cuti.puml` dipertahankan sebagai diagram gabungan/orisinal.

## Dokumentasi

`sequence_diagram/sequence-leave-approval.md` diperbarui dengan daftar diagram terpisah, ringkasan alur, dan aturan status approval.

## Validasi

- Periksa seluruh file PlantUML memiliki `@startuml` dan `@enduml`.
- Periksa setiap diagram detail memuat aktor, trigger, proses update, hasil, dan aturan khususnya.
- Pastikan perubahan tidak menimpa perubahan kerja yang sudah ada.

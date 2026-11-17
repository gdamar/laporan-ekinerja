# Plan: Konversi Schema Visualizer ke ERD Draw.io (Revisi 3: Format Transparan/Hitam & Atribut Akun Disesuaikan)

## Goal Description
Memperbarui rancangan ERD di Draw.io (`diagram/erd/erd.drawio`) berdasarkan masukan penyesuaian:
1. **Format Pewarnaan Transparan & Garis Hitam**:
   - Seluruh tabel, header, cell, dan garis relasi menggunakan format monokrom/akademik: `fillColor=none` (*transparent*) dan `strokeColor=#000000` (*black*).
   - Teks menggunakan warna hitam murni (`fontColor=#000000`) dengan tipografi yang tegas dan bersih, standar dokumen laporan Tugas Akhir.
2. **Format Tabel 2 Kolom**:
   - Kolom 1 ($36\text{px}$): Simbol `PK` / `FK`.
   - Kolom 2 ($214\text{px}$): `nama_field : tipe_data`.
   - Tanpa kolom constraint.
3. **Penyelarasan Atribut Entitas `akun`**:
   - Menghapus field `raw_app_meta_data` dan `raw_user_meta_data`.
   - Me-rename `encrypted_password` menjadi `password`.
   - Atribut final `akun`: `id`, `email`, `password`, `email_confirmed_at`, `last_sign_in_at`, `created_at`, `updated_at`.
4. **Topologi Simetris 8 Entitas Anti-Tumpuk**:
   - Arsitektur 4-tier dengan `master_petugas` di pusat simetri.

---

## User Review Required

> [!IMPORTANT]
> **Skema Warna Transparan & Garis Hitam**:
> Seluruh elemen diagram kini sepenuhnya monokrom/akademis:
> - Container tabel: `fillColor=none;strokeColor=#000000;fontColor=#000000;`
> - Header baris judul: `fillColor=none;strokeColor=#000000;fontColor=#000000;fontStyle=1;`
> - Pembatas baris: `strokeColor=#000000;`
> - Garis relasi & panah Crow's Foot: `strokeColor=#000000;fontColor=#000000;`

---

## 1. Topologi Simetris 8 Entitas

Diagram ditata secara proporsional pada kanvas $1400 \times 1400\text{px}$:

```
     [ SAYAP KIRI ]                 [ SUMBU TENGAH ]                 [ SAYAP KANAN ]

                           +--------------+  +--------------+
                           |     akun     |  |    roles     | (Tier 1: Parent Auth & RBAC)
                           +--------------+  +--------------+
                                  \                /
                                   \              /
  +--------------+                  v            v                  +--------------+
  |     cuti     | <=============== +--------------+ =============> |  penilaian   | (Tier 2: Core & Admin)
  +--------------+  (2 garis lurus) |master_petugas| (2 garis lurus)+--------------+
                                    +--------------+
                                      /          \
                                     /            \
                          +--------------+    +--------------+
                          | tugas_header |<-->|tugas_petugas | (Tier 3: Penugasan)
                          +--------------+    +--------------+
                                 |
                                 v
                          +--------------+
                          |  tugas_log   | (Tier 4: Timeline Pengerjaan)
                          +--------------+
```

### Koordinat & Dimensi Tabel ($W = 250\text{px}$, Baris $= 26\text{px}$):

| Tier / Sektor | Entitas | Posisi $(X, Y)$ | Dimensi $(W \times H)$ | Keterangan Relasi |
|---|---|---|---|---|
| **Tier 1 (Atas Kiri)** | `akun` | `(430, 80)` | $250 \times 212$ | `1 : 0..1` ke `master_petugas.supabase_auth_id` |
| **Tier 1 (Atas Kanan)** | `roles` | `(720, 80)` | $250 \times 108$ | `1 : N` ke `master_petugas.role_id` |
| **Tier 2 (Sentral)** | `master_petugas` | `(575, 380)` | $250 \times 394$ | **Central Hub Entity** |
| **Tier 2 (Sayap Kiri)** | `cuti` | `(120, 420)` | $250 \times 316$ | `1 : N (requests)` & `1 : N (approves)` |
| **Tier 2 (Sayap Kanan)** | `penilaian` | `(1030, 420)` | $250 \times 316$ | `1 : N (is evaluated)` & `1 : N (evaluates)` |
| **Tier 3 (Bawah Kiri)** | `tugas_header` | `(375, 840)` | $250 \times 238$ | `1 : N (creates)` dari `master_petugas` |
| **Tier 3 (Bawah Kanan)** | `tugas_petugas` | `(775, 840)` | $250 \times 134$ | `1 : N (assigned)` & jembatan penugasan |
| **Tier 4 (Bawah)** | `tugas_log` | `(375, 1140)` | $250 \times 264$ | `1 : N (has)` dari `tugas_header` |

---

## 2. Struktur Kolom & Atribut 8 Entitas

Setiap baris atribut terdiri dari:
- **Kolom 1 ($36\text{px}$)**: `PK` / `FK` (font tebal hitam).
- **Kolom 2 ($214\text{px}$)**: `nama_field : tipe_data` (rata kiri).

### 1. `akun` (7 baris, $H=212$)
- `PK` | `id : uuid`
- &nbsp;&nbsp;&nbsp;&nbsp; | `email : varchar`
- &nbsp;&nbsp;&nbsp;&nbsp; | `password : varchar`
- &nbsp;&nbsp;&nbsp;&nbsp; | `email_confirmed_at : timestamptz`
- &nbsp;&nbsp;&nbsp;&nbsp; | `last_sign_in_at : timestamptz`
- &nbsp;&nbsp;&nbsp;&nbsp; | `created_at : timestamptz`
- &nbsp;&nbsp;&nbsp;&nbsp; | `updated_at : timestamptz`

### 2. `roles` (3 baris, $H=108$)
- `PK` | `id : int4`
- &nbsp;&nbsp;&nbsp;&nbsp; | `nama_role : varchar`
- &nbsp;&nbsp;&nbsp;&nbsp; | `created_at : timestamptz`

### 3. `master_petugas` (14 baris, $H=394$)
- `PK` | `id : uuid`
- &nbsp;&nbsp;&nbsp;&nbsp; | `id_phl : varchar`
- &nbsp;&nbsp;&nbsp;&nbsp; | `nama_phl : varchar`
- &nbsp;&nbsp;&nbsp;&nbsp; | `jenis_kelamin : jenis_kelamin`
- &nbsp;&nbsp;&nbsp;&nbsp; | `nik : varchar`
- &nbsp;&nbsp;&nbsp;&nbsp; | `alamat : text`
- &nbsp;&nbsp;&nbsp;&nbsp; | `no_telp : varchar`
- &nbsp;&nbsp;&nbsp;&nbsp; | `email : varchar`
- &nbsp;&nbsp;&nbsp;&nbsp; | `password_hash : varchar`
- `FK` | `role_id : int4`
- &nbsp;&nbsp;&nbsp;&nbsp; | `status_aktif : bool`
- `FK` | `supabase_auth_id : uuid`
- &nbsp;&nbsp;&nbsp;&nbsp; | `created_at : timestamptz`
- &nbsp;&nbsp;&nbsp;&nbsp; | `updated_at : timestamptz`

### 4. `cuti` (11 baris, $H=316$)
- `PK` | `id : uuid`
- `FK` | `id_petugas : uuid`
- &nbsp;&nbsp;&nbsp;&nbsp; | `jenis_cuti : jenis_cuti`
- &nbsp;&nbsp;&nbsp;&nbsp; | `tgl_mulai : date`
- &nbsp;&nbsp;&nbsp;&nbsp; | `tgl_selesai : date`
- &nbsp;&nbsp;&nbsp;&nbsp; | `alasan : text`
- &nbsp;&nbsp;&nbsp;&nbsp; | `lampiran_url : varchar`
- &nbsp;&nbsp;&nbsp;&nbsp; | `status_approval : status_approval`
- `FK` | `approved_by : uuid`
- &nbsp;&nbsp;&nbsp;&nbsp; | `created_at : timestamptz`
- &nbsp;&nbsp;&nbsp;&nbsp; | `updated_at : timestamptz`

### 5. `penilaian` (11 baris, $H=316$)
- `PK` | `id : uuid`
- `FK` | `id_petugas : uuid`
- `FK` | `id_operator : uuid`
- &nbsp;&nbsp;&nbsp;&nbsp; | `periode_bulan : int4`
- &nbsp;&nbsp;&nbsp;&nbsp; | `periode_tahun : int4`
- &nbsp;&nbsp;&nbsp;&nbsp; | `skor_displin_kehadiran : numeric`
- &nbsp;&nbsp;&nbsp;&nbsp; | `skor_tanggung_jawab : numeric`
- &nbsp;&nbsp;&nbsp;&nbsp; | `skor_kepatuhan : numeric`
- &nbsp;&nbsp;&nbsp;&nbsp; | `total_nilai : numeric`
- &nbsp;&nbsp;&nbsp;&nbsp; | `catatan : text`
- &nbsp;&nbsp;&nbsp;&nbsp; | `created_at : timestamptz`

### 6. `tugas_header` (8 baris, $H=238$)
- `PK` | `id : uuid`
- `FK` | `id_petugas : uuid`
- &nbsp;&nbsp;&nbsp;&nbsp; | `judul_tugas : varchar`
- &nbsp;&nbsp;&nbsp;&nbsp; | `alamat : varchar`
- &nbsp;&nbsp;&nbsp;&nbsp; | `tanggal_tugas : date`
- &nbsp;&nbsp;&nbsp;&nbsp; | `status_tugas : status_tugas`
- &nbsp;&nbsp;&nbsp;&nbsp; | `created_at : timestamptz`
- &nbsp;&nbsp;&nbsp;&nbsp; | `updated_at : timestamptz`

### 7. `tugas_petugas` (4 baris, $H=134$)
- `PK` | `id : uuid`
- `FK` | `id_tugas : uuid`
- `FK` | `id_petugas : uuid`
- &nbsp;&nbsp;&nbsp;&nbsp; | `created_at : timestamptz`

### 8. `tugas_log` (9 baris, $H=264$)
- `PK` | `id : uuid`
- `FK` | `id_tugas : uuid`
- `FK` | `id_petugas : uuid`
- &nbsp;&nbsp;&nbsp;&nbsp; | `tahapan : tahapan_tugas`
- &nbsp;&nbsp;&nbsp;&nbsp; | `latitude : numeric`
- &nbsp;&nbsp;&nbsp;&nbsp; | `longitude : numeric`
- &nbsp;&nbsp;&nbsp;&nbsp; | `deskripsi : text`
- &nbsp;&nbsp;&nbsp;&nbsp; | `url_foto : jsonb`
- &nbsp;&nbsp;&nbsp;&nbsp; | `created_at : timestamptz`

---

## 3. Jalur Relasi & Kardinalitas (Garis Hitam Monokrom)

Setiap garis menggunakan `strokeColor=#000000;strokeWidth=1.5;fontColor=#000000;labelBackgroundColor=#ffffff;`:
1. **`akun` $\rightarrow$ `master_petugas` (`"authenticates"`)**:
   - Jalur orthogonal dari $(555, 292)$ ke $(635, 380)$.
   - `startArrow=ERmandOne;endArrow=ERzeroToOne;`
2. **`roles` $\rightarrow$ `master_petugas` (`"has"`)**:
   - Jalur orthogonal dari $(845, 188)$ ke $(765, 380)$.
   - `startArrow=ERmandOne;endArrow=ERmany;`
3. **`master_petugas` $\rightarrow$ `cuti` (`"requests"`)**:
   - Garis horizontal lurus $(575, 489) \rightarrow (370, 489)$.
   - `startArrow=ERmandOne;endArrow=ERmany;`
4. **`master_petugas` $\rightarrow$ `cuti` (`"approves"`)**:
   - Garis horizontal lurus $(575, 671) \rightarrow (370, 671)$.
   - Terpisah **$182\text{px}$** di bawah jalur `requests` (zero overlap).
   - `startArrow=ERzeroToOne;endArrow=ERzeroToMany;`
5. **`master_petugas` $\rightarrow$ `penilaian` (`"is evaluated"`)**:
   - Garis horizontal lurus $(825, 489) \rightarrow (1030, 489)$.
   - `startArrow=ERmandOne;endArrow=ERmany;`
6. **`master_petugas` $\rightarrow$ `penilaian` (`"evaluates"`)**:
   - Jalur orthogonal keluar dari $(825, 630)$, belok di koridor netral $(X=950)$, masuk ke $(1030, 515)$.
   - Terpisah **$141\text{px}$** di bawah jalur `is evaluated` (zero collision).
   - `startArrow=ERmandOne;endArrow=ERmany;`
7. **`master_petugas` $\rightarrow$ `tugas_header` (`"creates"`)**:
   - Jalur orthogonal belok simetris ke kiri di $Y=790$ masuk ke $(500, 840)$.
8. **`master_petugas` $\rightarrow$ `tugas_petugas` (`"is assigned"`)**:
   - Jalur orthogonal belok simetris ke kanan di $Y=790$ masuk ke $(900, 840)$.
9. **`tugas_header` $\rightarrow$ `tugas_petugas` (`"assigned to"`)**:
   - Garis horizontal bersih $(625, 896) \rightarrow (775, 896)$.
10. **`tugas_header` $\rightarrow$ `tugas_log` (`"has"`)**:
    - Garis vertikal lurus langsung $(500, 1078) \rightarrow (500, 1140)$.

---

## 4. Verification Plan

1. **Automated Verification**:
   - Parsing XML valid.
   - 0 overlap antar bounding box 8 entitas.
   - Seluruh segmen garis 100% orthogonal (tanpa diagonal).
   - Seluruh style menggunakan `fillColor=none` dan `strokeColor=#000000`.
   - Tabel `akun` memiliki tepat 7 baris tanpa metadata ganda.
2. **Visual Inspection**:
   - Tampilan bersih hitam-putih/transparan siap cetak laporan akademik.
   - Kesimetrisan sayap kiri-kanan dan kelonggaran pembacaan label.

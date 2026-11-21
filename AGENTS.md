# E-Kinerja Project Guidelines

## Scope and Current Focus

This repository contains the system-design documentation and thesis report (Bab IV) for the E-Kinerja application. Diagram work is primarily under `diagram/`:

- `diagram/usecase/`: use-case diagrams and source XML.
- `diagram/activity/`: CRUD activity diagrams, Draw.io XML, and exported PNGs.
- `diagram/sequence_diagram/`: sequence-diagram Draw.io files, PlantUML sources, images, and supporting documentation.
- `diagram/usecase-scenario.md`: use-case scenarios and links to activity-diagram exports.
- `diagram/diagram.md`: RAD research-flow and sequence-diagram notation rules.

Keep related source, documentation, and rendered output consistent when changing a diagram.

## Progress Pengerjaan (Bab IV Dokumen Laporan)

- **Requirements Planning**:
  - Penambahan narasi deskripsi hasil pengumpulan kebutuhan (Hasil Wawancara, Hasil Observasi, dan Studi Literatur) pada subbab Requirements Planning. Narasi telah disusun dan diintegrasikan manual ke dokumen master `draft_TA_20104057_Gregorius Damar(3).docx`.
- **Deskripsi Diagram Bab IV (Activity Diagram, Sequence Diagram, & ERD)**:
  - Telah dibuat 33 paragraf penjelasan naratif yang diletakkan tepat di bawah caption gambar diagram (14 Activity Diagram, 18 Sequence Diagram, dan 1 ERD).
  - Reposisi urutan diagram: Bagian Entity Relationship Diagram (ERD) telah dipindahkan posisinya agar berada setelah Sequence Diagram (mengikuti alur Activity Diagram → Sequence Diagram → ERD).
  - Pembersihan duplikasi teks judul/caption pada Gambar 4.4 (*Activity Diagram Kelola Petugas*) dan Gambar 4.5 (*Activity Diagram Kelola Penilaian*).
  - *Catatan teknis integrasi XML*: Sedang disiapkan perbaikan penanganan XML namespace pada `draft_TA_20104057_Gregorius Damar(3)_updated.docx` agar gambar/drawing compatibility markup (`mc:AlternateContent`, `xmlns:wpg`) tetap ter-render sempurna di Word.

## Diagram Conventions

### Use-case diagrams

- Use action-oriented names, especially `Kelola [Entity]` rather than a bare entity name.
- Include common system use cases such as `Login` where applicable.
- Preserve the actor roles used by the project, including Petugas, Operator, dan Kepala Sesi.

### Activity diagrams

Standard `Kelola` flows should use actor/system swimlanes and normally include:

- Add, edit, and delete decision paths.
- Forms for adding and editing data.
- Delete confirmation dialogs.
- Success notifications and refreshed lists.

Use the existing activity diagrams and reference images as the layout and naming reference. Use `diagram/activity/export_activity_diagrams.py` when regenerating the standard exported PNGs.

### Sequence diagrams

Follow the notation rules in `diagram/diagram.md`:

- Use UML stereotypes: `actor`, `boundary`, `control`, and `entity`.
- Gunakan `shape=umlLifeline` dengan properti `participant` yang sesuai (`umlActor`, `umlBoundary`, `umlControl`, `umlEntity`) untuk semua objek. Jangan gunakan shape `umlActor` standalone — aktor dan lifelinenya dibangun sebagai satu cell `shape=umlLifeline;participant=umlActor;...`.
- Label nama objek diletakkan sebagai cell teks terpisah di atas lifeline (y≈65, `fontStyle=1`, rata tengah), **bukan** teks yang tertanam di dalam cell lifeline.
- Use solid arrows for primary messages and dashed/open arrows for responses.
- Use `alt` frames for alternatives; do not represent alternatives with flowchart diamonds.
- Format penulisan nama alternative frame: shape frame bernilai murni `alt` (atau `loop`), dan label nama kasus dibungkus tanda kurung siku (misal `[Tambah]`, `[Ubah]`, `[Hapus]`, `[Pengajuan sesuai kriteria?]`) diletakkan di sebelah label `alt` sebagai elemen teks independen (child text element).
- Label `else` pada frame `alt` juga merupakan cell teks independen, diletakkan di margin kiri frame pada Y garis pembatas. Garis pembatas `else` adalah edge dengan style `endArrow=none;dashed=1` dari x=40 ke x=820.
- Diagram yang memiliki dua validasi berbeda (ketersediaan data + validasi aksi/status) menggunakan **dua frame `alt` terpisah secara vertikal** (bukan nested). Frame pertama mengecek ketersediaan data; frame kedua mengecek validasi kondisi bisnis/aksi.
- Activation boxes tidak boleh dibuat memanjang tunggal (monolitik), melainkan harus disegmentasi per fase aktif: (1) load data, (2) aksi pengguna/form, (3) transaksi Database (hanya aktif selama kueri berlangsung hingga hasil dikembalikan), (4) notifikasi/respon. Jeda antar fase menampilkan garis lifeline putus-putus (idle).
- Setiap panah pesan harus menggunakan koordinat absolut `sourcePoint` dan `targetPoint` dengan nilai Y yang **identik** (`y_source == y_target`). Panah diagonal atau miring (y berbeda) tidak diperbolehkan.
- Validasi internal Sistem menggunakan `edgeStyle=orthogonalEdgeStyle` dengan target berupa sub-cell `perimeter=orthogonalPerimeter` (w=10, h≈40) di dalam lifeline Sistem, membentuk loopback persegi tanpa diagonal.
- Pastikan panjang panah pesan presisi dan terhubung (*hooked*) langsung dari sisi activation box pengirim ke activation box penerima tanpa melayang (*dangling*). Teks pesan diposisikan tepat di atas garis panah.
- Keep each diagram to a maximum of four objects: actor, boundary, control, and entity.
- Gunakan sistem koordinat standar untuk diagram 4 objek: Aktor x=90 (center 100), Boundary x=295 (center 320), Sistem x=520 (center 540), Database x=740 (center 760). Lebar activation box standar 16px; sisi tepi untuk koneksi panah: 108↔312 (Aktor–Boundary), 328↔532 (Boundary–Sistem), 548↔752 (Sistem–Database). Frame `alt` menggunakan x=40, lebar w=780.
- Use general, readable message descriptions rather than implementation-specific wording.
- Use `Sistem` for the control object and `Database` for the entity object unless the existing diagram requires otherwise.
- Tinjau dan perbarui dokumen review di `diagram/sequence_diagram/sequence_rad_revised-review.md` setiap kali menyelesaikan iterasi perbaikan sequence diagram.

PlantUML sources belong in `diagram/sequence_diagram/puml/`; keep corresponding documentation and rendered diagrams synchronized.

## Aturan Penulisan Deskripsi Gambar & Diagram

### 1. Pola Kalimat & Gaya Bahasa
- **Struktur Pembuka Kalimat**: Selalu awali dengan referensi eksplisit ke gambar terkait, misalnya:
  - *Activity Diagram*: `Gambar 4.X memaparkan alur aktivitas [nama proses] yang dilakukan oleh [nama aktor]...`
  - *Sequence Diagram*: `Gambar 4.X memaparkan interaksi pesan dalam proses [nama proses] yang melibatkan aktor [nama aktor], boundary [antarmuka], kontrol Sistem, dan entitas Database...`
  - *ERD*: Paparkan relasi struktural antar entitas/tabel data beserta derajat kardinalitas atau fungsinya.
- **Tone & Diksi**:
  - Gunakan bahasa baku akademis namun dengan diksi natural mahasiswa (bukan bahasa terjemahan kaku atau bergaya AI generatif).
  - Jelaskan alur secara logis dan mengalir: pemicu aksi (aktor) → pemrosesan/validasi sistem → penyimpanan/kueri basis data → hasil/tanggapan antarmuka.
- **Tipografi Istilah Asing**:
  - Semua istilah teknis berbahasa asing wajib dicetak miring (*italic*), seperti: *login*, *dashboard*, *role*, *email*, *password*, *database*, *geotagging*, *timestamp*, *form*, *input*, *update*, *delete*, *dropdown*, *validasi*, dsb.
- **Format Paragraf Word**:
  - Font: Times New Roman, ukuran 12pt.
  - Spasi: 1.5 line spacing (`w:line="360"`, `w:lineRule="auto"`).
  - Alignment: Rata kanan-kiri (*Justify*, `w:jc w:val="both"`).
  - Posisi: Diletakkan tepat di bawah paragraf caption gambar terkait (`w:pStyle w:val="1580"` atau style caption lainnya).

### 2. Referensi yang Digunakan
Setiap penyusunan deskripsi diagram wajib mengacu dan menyelaraskan terminologi dengan dokumen referensi berikut:
- **Use Case Scenario**: `diagram/usecase-scenario.md` dan tabel skenario use case pada dokumen laporan (`draft_TA_...docx`), sebagai standar konsistensi nama aktor, aksi utama, dan alur alternatif.
- **Activity Diagram Source**: `diagram/activity/` (file XML `.drawio` dan PNG) untuk memastikan setiap cabang keputusan (*decision path*: Tambah/Ubah/Hapus/Filter) dan alur swimlane aktor-sistem terdeskripsikan secara akurat.
- **Sequence Diagram Specification**: `diagram/sequence_diagram/sequence_rad_revised-review.md` dan `diagram/sequence_diagram/puml/` untuk mencocokkan interaksi pesan antar 4 objek (*Actor*, *Boundary*, *Control/Sistem*, *Entity/Database*).
- **Skema Basis Data & ERD**: Struktur entitas serta relasi tabel sistem E-Kinerja pada subbab perancangan basis data.

## Editing and Validation

- Prefer creating or updating an `_updated` copy of Draw.io XML instead of overwriting an original, unless explicitly requested.
- Preserve existing user changes and avoid unrelated cleanup.
- Use ASCII by default and match the existing file format and naming style.
- After changing a diagram, validate the XML/PlantUML source and regenerate affected exports when practical.
- Update `diagram/usecase-scenario.md` when adding or renaming documented use cases or activity exports.
- Treat backup files (`.$*.bkp`) and generated images as artifacts; do not edit them directly.

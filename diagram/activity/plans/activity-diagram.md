# Activity Diagram Sistem E-Kinerja

Setiap item use case pada diagram Petugas dan Operator/Kepala Seksi diuraikan sebagai diagram aktivitas PlantUML mandiri. Swimlane dan warna mengikuti gambar referensi. Kepala Seksi mewarisi aktivitas Operator; keputusan cuti merupakan aktivitas Kepala Seksi. Use case "Membuat laporan pengerjaan tugas" yang tampil dua kali pada gambar Petugas didokumentasikan satu kali karena labelnya sama.

## Petugas

### Membuat laporan pengerjaan tugas

Use case ini menyertakan aktivitas melihat log laporan.

```plantuml
@startuml
title Activity Diagram - Membuat Laporan Pengerjaan Tugas
skinparam backgroundColor white
skinparam activity { BackgroundColor #F8E8C8 BorderColor #8A6D3B FontColor #333333 DiamondBackgroundColor #F8E8C8 DiamondBorderColor #8A6D3B }
skinparam activityArrowColor #C00000
skinparam activityStartColor #C00000
skinparam activityEndColor #C00000
skinparam swimlane { BorderColor #777777 TitleBackgroundColor #F4E3C5 TitleFontColor #333333 }
|Petugas|
start
:Membuat laporan pengerjaan tugas;
|Sistem|
:Menyimpan laporan;
|Petugas|
:Melihat log laporan;
|Sistem|
:Menampilkan log laporan;
stop
@enduml
```

### Melihat daftar riwayat tugas

```plantuml
@startuml
title Activity Diagram - Melihat Daftar Riwayat Tugas (Petugas)
skinparam backgroundColor white
skinparam activity { BackgroundColor #F8E8C8 BorderColor #8A6D3B FontColor #333333 DiamondBackgroundColor #F8E8C8 DiamondBorderColor #8A6D3B }
skinparam activityArrowColor #C00000
skinparam activityStartColor #C00000
skinparam activityEndColor #C00000
skinparam swimlane { BorderColor #777777 TitleBackgroundColor #F4E3C5 TitleFontColor #333333 }
|Petugas|
start
:Memilih daftar riwayat tugas;
|Sistem|
:Menampilkan daftar riwayat tugas;
stop
@enduml
```

### Melihat kuota cuti

```plantuml
@startuml
title Activity Diagram - Melihat Kuota Cuti
skinparam backgroundColor white
skinparam activity { BackgroundColor #F8E8C8 BorderColor #8A6D3B FontColor #333333 DiamondBackgroundColor #F8E8C8 DiamondBorderColor #8A6D3B }
skinparam activityArrowColor #C00000
skinparam activityStartColor #C00000
skinparam activityEndColor #C00000
skinparam swimlane { BorderColor #777777 TitleBackgroundColor #F4E3C5 TitleFontColor #333333 }
|Petugas|
start
:Memilih menu kuota cuti;
|Sistem|
:Menampilkan kuota cuti;
stop
@enduml
```

### Mengajukan cuti

Use case ini menyertakan aktivitas melihat kuota cuti.

```plantuml
@startuml
title Activity Diagram - Mengajukan Cuti
skinparam backgroundColor white
skinparam activity { BackgroundColor #F8E8C8 BorderColor #8A6D3B FontColor #333333 DiamondBackgroundColor #F8E8C8 DiamondBorderColor #8A6D3B }
skinparam activityArrowColor #C00000
skinparam activityStartColor #C00000
skinparam activityEndColor #C00000
skinparam swimlane { BorderColor #777777 TitleBackgroundColor #F4E3C5 TitleFontColor #333333 }
|Petugas|
start
:Memilih ajukan cuti;
:Melihat kuota cuti;
|Sistem|
:Menampilkan kuota cuti;
|Petugas|
:Mengisi dan mengirim pengajuan cuti;
|Sistem|
:Menerima pengajuan cuti;
stop
@enduml
```

### Melihat riwayat cuti

```plantuml
@startuml
title Activity Diagram - Melihat Riwayat Cuti (Petugas)
skinparam backgroundColor white
skinparam activity { BackgroundColor #F8E8C8 BorderColor #8A6D3B FontColor #333333 DiamondBackgroundColor #F8E8C8 DiamondBorderColor #8A6D3B }
skinparam activityArrowColor #C00000
skinparam activityStartColor #C00000
skinparam activityEndColor #C00000
skinparam swimlane { BorderColor #777777 TitleBackgroundColor #F4E3C5 TitleFontColor #333333 }
|Petugas|
start
:Memilih riwayat cuti;
|Sistem|
:Menampilkan riwayat cuti;
stop
@enduml
```

### Melihat daftar penilaian

```plantuml
@startuml
title Activity Diagram - Melihat Daftar Penilaian (Petugas)
skinparam backgroundColor white
skinparam activity { BackgroundColor #F8E8C8 BorderColor #8A6D3B FontColor #333333 DiamondBackgroundColor #F8E8C8 DiamondBorderColor #8A6D3B }
skinparam activityArrowColor #C00000
skinparam activityStartColor #C00000
skinparam activityEndColor #C00000
skinparam swimlane { BorderColor #777777 TitleBackgroundColor #F4E3C5 TitleFontColor #333333 }
|Petugas|
start
:Memilih daftar penilaian;
|Sistem|
:Menampilkan daftar penilaian;
stop
@enduml
```

### Mengajukan banding

Use case ini menyertakan aktivitas melihat daftar penilaian.

```plantuml
@startuml
title Activity Diagram - Mengajukan Banding
skinparam backgroundColor white
skinparam activity { BackgroundColor #F8E8C8 BorderColor #8A6D3B FontColor #333333 DiamondBackgroundColor #F8E8C8 DiamondBorderColor #8A6D3B }
skinparam activityArrowColor #C00000
skinparam activityStartColor #C00000
skinparam activityEndColor #C00000
skinparam swimlane { BorderColor #777777 TitleBackgroundColor #F4E3C5 TitleFontColor #333333 }
|Petugas|
start
:Memilih ajukan banding;
:Melihat daftar penilaian;
|Sistem|
:Menampilkan daftar penilaian;
|Petugas|
:Mengisi dan mengirim banding;
|Sistem|
:Menerima pengajuan banding;
stop
@enduml
```

## Operator dan Kepala Seksi

### Membuat tugas

Use case ini menyertakan aktivitas melihat log laporan.

```plantuml
@startuml
title Activity Diagram - Membuat Tugas
skinparam backgroundColor white
skinparam activity { BackgroundColor #F8E8C8 BorderColor #8A6D3B FontColor #333333 DiamondBackgroundColor #F8E8C8 DiamondBorderColor #8A6D3B }
skinparam activityArrowColor #C00000
skinparam activityStartColor #C00000
skinparam activityEndColor #C00000
skinparam swimlane { BorderColor #777777 TitleBackgroundColor #F4E3C5 TitleFontColor #333333 }
|Operator / Kepala Seksi|
start
:Memasukkan data tugas;
|Sistem|
:Menyimpan tugas;
|Operator / Kepala Seksi|
:Melihat log laporan;
|Sistem|
:Menampilkan log laporan;
stop
@enduml
```

### Melakukan perubahan data tugas

```plantuml
@startuml
title Activity Diagram - Mengubah Data Tugas
skinparam backgroundColor white
skinparam activity { BackgroundColor #F8E8C8 BorderColor #8A6D3B FontColor #333333 DiamondBackgroundColor #F8E8C8 DiamondBorderColor #8A6D3B }
skinparam activityArrowColor #C00000
skinparam activityStartColor #C00000
skinparam activityEndColor #C00000
skinparam swimlane { BorderColor #777777 TitleBackgroundColor #F4E3C5 TitleFontColor #333333 }
|Operator / Kepala Seksi|
start
:Memilih tugas dan mengubah datanya;
|Sistem|
:Menyimpan perubahan data tugas;
stop
@enduml
```

### Menghapus tugas

```plantuml
@startuml
title Activity Diagram - Menghapus Tugas
skinparam backgroundColor white
skinparam activity { BackgroundColor #F8E8C8 BorderColor #8A6D3B FontColor #333333 DiamondBackgroundColor #F8E8C8 DiamondBorderColor #8A6D3B }
skinparam activityArrowColor #C00000
skinparam activityStartColor #C00000
skinparam activityEndColor #C00000
skinparam swimlane { BorderColor #777777 TitleBackgroundColor #F4E3C5 TitleFontColor #333333 }
|Operator / Kepala Seksi|
start
:Memilih tugas untuk dihapus;
|Sistem|
:Menghapus tugas;
stop
@enduml
```

### Melihat daftar riwayat tugas

```plantuml
@startuml
title Activity Diagram - Melihat Daftar Riwayat Tugas (Operator)
skinparam backgroundColor white
skinparam activity { BackgroundColor #F8E8C8 BorderColor #8A6D3B FontColor #333333 DiamondBackgroundColor #F8E8C8 DiamondBorderColor #8A6D3B }
skinparam activityArrowColor #C00000
skinparam activityStartColor #C00000
skinparam activityEndColor #C00000
skinparam swimlane { BorderColor #777777 TitleBackgroundColor #F4E3C5 TitleFontColor #333333 }
|Operator / Kepala Seksi|
start
:Memilih daftar riwayat tugas;
|Sistem|
:Menampilkan daftar riwayat tugas;
stop
@enduml
```

### Melihat daftar petugas

```plantuml
@startuml
title Activity Diagram - Melihat Daftar Petugas
skinparam backgroundColor white
skinparam activity { BackgroundColor #F8E8C8 BorderColor #8A6D3B FontColor #333333 DiamondBackgroundColor #F8E8C8 DiamondBorderColor #8A6D3B }
skinparam activityArrowColor #C00000
skinparam activityStartColor #C00000
skinparam activityEndColor #C00000
skinparam swimlane { BorderColor #777777 TitleBackgroundColor #F4E3C5 TitleFontColor #333333 }
|Operator / Kepala Seksi|
start
:Memilih daftar petugas;
|Sistem|
:Menampilkan daftar petugas;
stop
@enduml
```

### Melakukan perubahan data petugas

```plantuml
@startuml
title Activity Diagram - Mengubah Data Petugas
skinparam backgroundColor white
skinparam activity { BackgroundColor #F8E8C8 BorderColor #8A6D3B FontColor #333333 DiamondBackgroundColor #F8E8C8 DiamondBorderColor #8A6D3B }
skinparam activityArrowColor #C00000
skinparam activityStartColor #C00000
skinparam activityEndColor #C00000
skinparam swimlane { BorderColor #777777 TitleBackgroundColor #F4E3C5 TitleFontColor #333333 }
|Operator / Kepala Seksi|
start
:Memilih petugas dan mengubah datanya;
|Sistem|
:Menyimpan perubahan data petugas;
stop
@enduml
```

### Melihat detail petugas

```plantuml
@startuml
title Activity Diagram - Melihat Detail Petugas
skinparam backgroundColor white
skinparam activity { BackgroundColor #F8E8C8 BorderColor #8A6D3B FontColor #333333 DiamondBackgroundColor #F8E8C8 DiamondBorderColor #8A6D3B }
skinparam activityArrowColor #C00000
skinparam activityStartColor #C00000
skinparam activityEndColor #C00000
skinparam swimlane { BorderColor #777777 TitleBackgroundColor #F4E3C5 TitleFontColor #333333 }
|Operator / Kepala Seksi|
start
:Memilih petugas;
|Sistem|
:Menampilkan detail petugas;
stop
@enduml
```

### Menambah petugas

```plantuml
@startuml
title Activity Diagram - Menambah Petugas
skinparam backgroundColor white
skinparam activity { BackgroundColor #F8E8C8 BorderColor #8A6D3B FontColor #333333 DiamondBackgroundColor #F8E8C8 DiamondBorderColor #8A6D3B }
skinparam activityArrowColor #C00000
skinparam activityStartColor #C00000
skinparam activityEndColor #C00000
skinparam swimlane { BorderColor #777777 TitleBackgroundColor #F4E3C5 TitleFontColor #333333 }
|Operator / Kepala Seksi|
start
:Mengisi data petugas;
|Sistem|
:Menyimpan data petugas;
stop
@enduml
```

### Menonaktifkan akun

```plantuml
@startuml
title Activity Diagram - Menonaktifkan Akun
skinparam backgroundColor white
skinparam activity { BackgroundColor #F8E8C8 BorderColor #8A6D3B FontColor #333333 DiamondBackgroundColor #F8E8C8 DiamondBorderColor #8A6D3B }
skinparam activityArrowColor #C00000
skinparam activityStartColor #C00000
skinparam activityEndColor #C00000
skinparam swimlane { BorderColor #777777 TitleBackgroundColor #F4E3C5 TitleFontColor #333333 }
|Operator / Kepala Seksi|
start
:Memilih akun untuk dinonaktifkan;
|Sistem|
:Menonaktifkan akun;
stop
@enduml
```

### Membuat akun

```plantuml
@startuml
title Activity Diagram - Membuat Akun
skinparam backgroundColor white
skinparam activity { BackgroundColor #F8E8C8 BorderColor #8A6D3B FontColor #333333 DiamondBackgroundColor #F8E8C8 DiamondBorderColor #8A6D3B }
skinparam activityArrowColor #C00000
skinparam activityStartColor #C00000
skinparam activityEndColor #C00000
skinparam swimlane { BorderColor #777777 TitleBackgroundColor #F4E3C5 TitleFontColor #333333 }
|Operator / Kepala Seksi|
start
:Mengisi data akun;
|Sistem|
:Menyimpan akun;
stop
@enduml
```

### Melihat daftar akun

```plantuml
@startuml
title Activity Diagram - Melihat Daftar Akun
skinparam backgroundColor white
skinparam activity { BackgroundColor #F8E8C8 BorderColor #8A6D3B FontColor #333333 DiamondBackgroundColor #F8E8C8 DiamondBorderColor #8A6D3B }
skinparam activityArrowColor #C00000
skinparam activityStartColor #C00000
skinparam activityEndColor #C00000
skinparam swimlane { BorderColor #777777 TitleBackgroundColor #F4E3C5 TitleFontColor #333333 }
|Operator / Kepala Seksi|
start
:Memilih daftar akun;
|Sistem|
:Menampilkan daftar akun;
stop
@enduml
```

### Mereset password

```plantuml
@startuml
title Activity Diagram - Mereset Password
skinparam backgroundColor white
skinparam activity { BackgroundColor #F8E8C8 BorderColor #8A6D3B FontColor #333333 DiamondBackgroundColor #F8E8C8 DiamondBorderColor #8A6D3B }
skinparam activityArrowColor #C00000
skinparam activityStartColor #C00000
skinparam activityEndColor #C00000
skinparam swimlane { BorderColor #777777 TitleBackgroundColor #F4E3C5 TitleFontColor #333333 }
|Operator / Kepala Seksi|
start
:Memilih akun dan meminta reset password;
|Sistem|
:Mereset password akun;
stop
@enduml
```

### Melihat daftar penilaian

```plantuml
@startuml
title Activity Diagram - Melihat Daftar Penilaian (Operator)
skinparam backgroundColor white
skinparam activity { BackgroundColor #F8E8C8 BorderColor #8A6D3B FontColor #333333 DiamondBackgroundColor #F8E8C8 DiamondBorderColor #8A6D3B }
skinparam activityArrowColor #C00000
skinparam activityStartColor #C00000
skinparam activityEndColor #C00000
skinparam swimlane { BorderColor #777777 TitleBackgroundColor #F4E3C5 TitleFontColor #333333 }
|Operator / Kepala Seksi|
start
:Memilih daftar penilaian;
|Sistem|
:Menampilkan daftar penilaian;
stop
@enduml
```

### Melihat detail penilaian

```plantuml
@startuml
title Activity Diagram - Melihat Detail Penilaian
skinparam backgroundColor white
skinparam activity { BackgroundColor #F8E8C8 BorderColor #8A6D3B FontColor #333333 DiamondBackgroundColor #F8E8C8 DiamondBorderColor #8A6D3B }
skinparam activityArrowColor #C00000
skinparam activityStartColor #C00000
skinparam activityEndColor #C00000
skinparam swimlane { BorderColor #777777 TitleBackgroundColor #F4E3C5 TitleFontColor #333333 }
|Operator / Kepala Seksi|
start
:Memilih penilaian;
|Sistem|
:Menampilkan detail penilaian;
stop
@enduml
```

### Input nilai kinerja

```plantuml
@startuml
title Activity Diagram - Input Nilai Kinerja
skinparam backgroundColor white
skinparam activity { BackgroundColor #F8E8C8 BorderColor #8A6D3B FontColor #333333 DiamondBackgroundColor #F8E8C8 DiamondBorderColor #8A6D3B }
skinparam activityArrowColor #C00000
skinparam activityStartColor #C00000
skinparam activityEndColor #C00000
skinparam swimlane { BorderColor #777777 TitleBackgroundColor #F4E3C5 TitleFontColor #333333 }
|Operator / Kepala Seksi|
start
:Memasukkan nilai kinerja;
|Sistem|
:Menyimpan nilai kinerja;
stop
@enduml
```

### Melihat riwayat cuti

```plantuml
@startuml
title Activity Diagram - Melihat Riwayat Cuti (Kepala Seksi)
skinparam backgroundColor white
skinparam activity { BackgroundColor #F8E8C8 BorderColor #8A6D3B FontColor #333333 DiamondBackgroundColor #F8E8C8 DiamondBorderColor #8A6D3B }
skinparam activityArrowColor #C00000
skinparam activityStartColor #C00000
skinparam activityEndColor #C00000
skinparam swimlane { BorderColor #777777 TitleBackgroundColor #F4E3C5 TitleFontColor #333333 }
|Kepala Seksi|
start
:Memilih riwayat cuti;
|Sistem|
:Menampilkan riwayat cuti;
stop
@enduml
```

### Menyetujui cuti

```plantuml
@startuml
title Activity Diagram - Menyetujui Cuti
skinparam backgroundColor white
skinparam activity { BackgroundColor #F8E8C8 BorderColor #8A6D3B FontColor #333333 DiamondBackgroundColor #F8E8C8 DiamondBorderColor #8A6D3B }
skinparam activityArrowColor #C00000
skinparam activityStartColor #C00000
skinparam activityEndColor #C00000
skinparam swimlane { BorderColor #777777 TitleBackgroundColor #F4E3C5 TitleFontColor #333333 }
|Kepala Seksi|
start
:Memilih pengajuan cuti;
:Menyetujui cuti;
|Sistem|
:Menyimpan keputusan persetujuan;
stop
@enduml
```

### Menolak cuti

```plantuml
@startuml
title Activity Diagram - Menolak Cuti
skinparam backgroundColor white
skinparam activity { BackgroundColor #F8E8C8 BorderColor #8A6D3B FontColor #333333 DiamondBackgroundColor #F8E8C8 DiamondBorderColor #8A6D3B }
skinparam activityArrowColor #C00000
skinparam activityStartColor #C00000
skinparam activityEndColor #C00000
skinparam swimlane { BorderColor #777777 TitleBackgroundColor #F4E3C5 TitleFontColor #333333 }
|Kepala Seksi|
start
:Memilih pengajuan cuti;
:Menolak cuti;
|Sistem|
:Menyimpan keputusan penolakan;
stop
@enduml
```

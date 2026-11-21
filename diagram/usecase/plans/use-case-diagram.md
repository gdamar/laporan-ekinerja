# Use Case Diagram
# Sistem E-Kinerja

```plantuml
@startuml
left to right direction
!theme plain
skinparam shadowing false
skinparam roundcorner 8
skinparam defaultFontName sans-serif
skinparam defaultFontColor #0F172A
skinparam backgroundColor #F8FAFC
skinparam ArrowColor #475569

skinparam usecase {
    BackgroundColor #E2E8F0
    BorderColor #64748B
}
skinparam actor {
    BackgroundColor #FFFFFF
    BorderColor #64748B
}

' ============= SYSTEM BOUNDARY =============
rectangle "Sistem E-Kinerja" {
    ' ============= AUTHENTICATION =============
    package "Authentication" {
        (Login)
        (Logout)
        (Reset Password)
    }

    ' ============= TUGAS (TASK) =============
    package "Tugas" {
        (Melihat Daftar Tugas)
        (Melihat Detail Tugas)
        (Membuat Tugas) <<extend>>
        (Mengedit Tugas) <<extend>>
        (Menghapus Tugas) <<extend>>
        (Mengirim Log Progres)
        (Upload Foto) <<include>>
        (Pilih Lokasi GPS) <<include>>
        (Melihat Peta Tugas)
    }

    ' ============= CUTI (LEAVE) =============
    package "Cuti" {
        (Mengajukan Cuti)
        (Melihat Riwayat Cuti)
        (Menyetujui Cuti) <<extend>>
        (Menolak Cuti) <<extend>>
        (Melihat Kuota Cuti) <<include>>
    }

    ' ============= PENILAIAN (EVALUATION) =============
    package "Penilaian" {
        (Melihat Penilaian)
        (Input Nilai Kinerja)
        (Melihat Detail Penilaian)
    }

    ' ============= PETUGAS =============
    package "Manajemen Petugas" {
        (Melihat Daftar Petugas)
        (Menambah Petugas) <<extend>>
        (Mengedit Petugas) <<extend>>
        (Melihat Detail Petugas) <<extend>>
    }

    ' ============= AKUN =============
    package "Manajemen Akun" {
        (Melihat Daftar Akun)
        (Membuat Akun) <<extend>>
        (Mereset Password) <<extend>>
        (Menonaktifkan Akun) <<extend>>
    }

    ' ============= LAPORAN =============
    package "Laporan" {
        (Melihat Laporan)
        (Filter Laporan)
        (Export Data CSV)
        (Melihat Peta Laporan)
    }

    ' ============= DASHBOARD =============
    (Melihat Dashboard)
    (Melihat Statistik)
    (Melihat Profil)
    (Mengedit Profil)
}

' ============= ACTORS =============

actor "Petugas" as PETUGAS #64748B
actor "Operator" as OPERATOR #64748B
actor "Kepala Sesi" as KEPALA_SESI #64748B

' ============= ACTOR-USE CASE ASSOCIATIONS =============

' Petugas - Authentication
PETUGAS --> Login
PETUGAS --> Logout

' Petugas - Dashboard & Profile
PETUGAS --> (Melihat Dashboard)
PETUGAS --> (Melihat Profil)
PETUGAS --> (Mengedit Profil)

' Petugas - Tugas
PETUGAS --> (Melihat Daftar Tugas)
PETUGAS --> (Melihat Detail Tugas)
PETUGAS --> (Mengirim Log Progres)
PETUGAS --> (Melihat Peta Tugas)

' Include relationships for Log Progres
(Mengirim Log Progres) .> (Upload Foto) : <<include>>
(Mengirim Log Progres) .> (Pilih Lokasi GPS) : <<include>>

' Petugas - Cuti
PETUGAS --> (Mengajukan Cuti)
PETUGAS --> (Melihat Riwayat Cuti)
PETUGAS --> (Melihat Kuota Cuti) .> (Mengajukan Cuti) : <<include>>

' Petugas - Penilaian
PETUGAS --> (Melihat Penilaian)
PETUGAS --> (Melihat Detail Penilaian)

' Petugas - Laporan
PETUGAS --> (Melihat Laporan)
PETUGAS --> (Filter Laporan)
PETUGAS --> (Melihat Peta Laporan)

' Operator - Authentication
OPERATOR --> Login
OPERATOR --> Logout

' Operator - Dashboard & Profile
OPERATOR --> (Melihat Dashboard)
OPERATOR --> (Melihat Statistik)
OPERATOR --> (Melihat Profil)
OPERATOR --> (Mengedit Profil)

' Operator - Tugas (View All)
OPERATOR --> (Melihat Daftar Tugas)
OPERATOR --> (Melihat Detail Tugas)
OPERATOR --> (Melihat Peta Tugas)
OPERATOR --> (Melihat Laporan)

' Operator - Cuti Approval
OPERATOR --> (Melihat Riwayat Cuti)
OPERATOR --> (Menyetujui Cuti)
OPERATOR --> (Menolak Cuti)

' Extend relationships for Cuti
(Menyetujui Cuti) .> (Melihat Riwayat Cuti) : <<extend>>
(Menolak Cuti) .> (Melihat Riwayat Cuti) : <<extend>>

' Operator - Penilaian
OPERATOR --> (Input Nilai Kinerja)
OPERATOR --> (Melihat Penilaian)
OPERATOR --> (Melihat Detail Penilaian)

' Operator - Petugas Management
OPERATOR --> (Melihat Daftar Petugas)
OPERATOR --> (Menambah Petugas)
OPERATOR --> (Mengedit Petugas)
OPERATOR --> (Melihat Detail Petugas)

' Extend relationships for Petugas
(Menambah Petugas) .> (Melihat Daftar Petugas) : <<extend>>
(Mengedit Petugas) .> (Melihat Daftar Petugas) : <<extend>>
(Melihat Detail Petugas) .> (Melihat Daftar Petugas) : <<extend>>

' Operator - Akun Management
OPERATOR --> (Melihat Daftar Akun)
OPERATOR --> (Membuat Akun)
OPERATOR --> (Mereset Password)
OPERATOR --> (Menonaktifkan Akun)

' Extend relationships for Akun
(Membuat Akun) .> (Melihat Daftar Akun) : <<extend>>
(Mereset Password) .> (Melihat Daftar Akun) : <<extend>>
(Menonaktifkan Akun) .> (Melihat Daftar Akun) : <<extend>>

' Operator - Laporan
OPERATOR --> (Filter Laporan)
OPERATOR --> (Export Data CSV)
OPERATOR --> (Melihat Peta Laporan)

' Kepala Sesi - All Operator capabilities
KEPALA_SESI -[#64748B,dashed]- OPERATOR : "inherits all"

' Kepala Sesi - Full Task Management
KEPALA_SESI --> (Membuat Tugas)
KEPALA_SESI --> (Mengedit Tugas)
KEPALA_SESI --> (Menghapus Tugas)

' Extend relationships for Tugas
(Membuat Tugas) .> (Melihat Daftar Tugas) : <<extend>>
(Mengedit Tugas) .> (Melihat Detail Tugas) : <<extend>>
(Menghapus Tugas) .> (Melihat Detail Tugas) : <<extend>>

' Kepala Sesi - Akun Management
KEPALA_SESI --> (Melihat Daftar Akun)
KEPALA_SESI --> (Membuat Akun)
KEPALA_SESI --> (Mereset Password)

' Reset Password for Kepala Sesi
(Reset Password) .> (Melihat Daftar Akun) : <<extend>>

@enduml
```

## Legenda

| Simbol | Arti |
|--------|------|
| `rectangle` | System Boundary |
| `actor` | Actor (Pengguna/Sistem) |
| `(usecase)` | Use Case |
| `<<include>>` | Required sub-flow |
| `<<extend>>` | Optional extension |
| `-->` | Association |
| `-[#color,dashed]-` | Inheritance |

## Actors dan Akses

| Actor | Akses |
|-------|-------|
| **Petugas** | View own tasks, submit progress, request leave, view own scores |
| **Operator** | All petugas + approve leave, input scores, manage petugas & accounts |
| **Kepala Sesi** | All operator + create/edit/delete tasks |

## Use Case Modules

1. **Authentication** - Login, Logout, Reset Password
2. **Tugas** - Task lifecycle management
3. **Cuti** - Leave request and approval
4. **Penilaian** - Performance evaluation
5. **Petugas** - Petugas data management
6. **Akun** - Account management
7. **Laporan** - Reporting and export
8. **Dashboard** - Overview and statistics

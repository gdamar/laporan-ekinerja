# Sequence Diagram - Sistem E-Kinerja

Dokumentasi ini berisi sequence diagram untuk alur-alur kritis dalam sistem E-Kinerja, disajikan dalam format **PlantUML** dan **Mermaid.js**.

---

## Daftar Sequence Diagram

| No  | Alur                  | File                         |
| -----| -----------------------| ------------------------------|
| 1   | Login                 | `sequence-login.md`          |
| 2   | Membuat Tugas         | `sequence-task-creation.md`  |
| 3   | Submit Progress Tugas | `sequence-task-progress.md`  |
| 4   | Pengajuan Cuti        | `sequence-leave-request.md`  |
| 5   | Approval Cuti         | `sequence-leave-approval.md` |
| 6   | Input Penilaian       | `sequence-evaluation.md`     |

---

## 1. Sequence Diagram - Login

### PlantUML

```plantuml
@startuml
!theme plain
skinparam shadowing false
skinparam roundcorner 8
skinparam defaultFontName sans-serif
skinparam defaultFontColor #0F172A
skinparam backgroundColor #F8FAFC
skinparam ArrowColor #475569
skinparam ActorBorderColor #64748B
skinparam ActorBackgroundColor #FFFFFF

skinparam sequence {
    ArrowColor #475569
    ActorBorderColor #64748B
    ActorBackgroundColor #F1F5F9
    BoxBackgroundColor #FFFFFF
    BoxBorderColor #64748B
    DividerBackgroundColor #F1F5F9
    LifeLineBorderColor #64748B
    LifeLineBackgroundColor #F1F5F9
    MessageArrowColor #475569
    MessageTextColor #0F172A

    NoteBackgroundColor #FEF9C3
    NoteBorderColor #CA8A04
}

title Sequence Diagram - Login

actor ":Petugas" as PETUGAS
actor ":Operator" as OPERATOR
actor ":Kepala Sesi" as KEPSES

participant ":LoginPage" as LOGIN
participant ":AuthContext" as AUTH
participant ":SupabaseAuth" as SUPA_AUTH
participant ":SupabaseDB" as SUPA_DB
participant ":AuthContext" as AUTH_CTX

== Halaman Login ==

PETUGAS -> LOGIN : Mengakses /login
activate PETUGAS
activate LOGIN
LOGIN -> AUTH : signIn(email, password)
deactivate LOGIN

== Autentikasi ==

AUTH -> SUPA_AUTH : signIn(email, password)
activate SUPA_AUTH
SUPA_AUTH -> SUPA_AUTH : Validasi kredensial

alt Autentikasi Berhasil
    SUPA_AUTH --> AUTH : session
    deactivate SUPA_AUTH

    AUTH -> SUPA_DB : fetchProfile(email)
    activate SUPA_DB
    SUPA_DB --> AUTH : master_petugas record
    deactivate SUPA_DB

    AUTH -> AUTH_CTX : setSession(session)
    AUTH -> AUTH_CTX : setProfile(profile)
    AUTH --> PETUGAS : Login berhasil, redirect /dashboard
    deactivate AUTH

else Autentikasi Gagal
    SUPA_AUTH --> AUTH : error
    deactivate SUPA_AUTH
    AUTH --> PETUGAS : Tampilkan error "Email atau password salah"
    deactivate AUTH
end

deactivate PETUGAS

@enduml
```

### Mermaid.js

```mermaid
sequenceDiagram
    autonumber
    title Sequence Diagram - Login

    actor PETUGAS as :Petugas
    participant LOGIN as :LoginPage
    participant AUTH as :AuthContext
    participant SUPA_AUTH as :SupabaseAuth
    participant SUPA_DB as :SupabaseDB
    participant AUTH_CTX as :AuthContext

    PETUGAS->>+LOGIN : Mengakses /login
    LOGIN->>+AUTH : signIn(email, password)

    rect rgb(240, 253, 244)
        Note over AUTH,SUPA_AUTH : Autentikasi
        AUTH->>+SUPA_AUTH : signIn(email, password)
        SUPA_AUTH-->>-AUTH : session / error
    end

    alt Autentikasi Berhasil
        AUTH->>+SUPA_DB : fetchProfile(email)
        SUPA_DB-->>-AUTH : master_petugas record
        AUTH->>AUTH_CTX : setSession(session)
        AUTH->>AUTH_CTX : setProfile(profile)
        AUTH-->>-PETUGAS : Login berhasil, redirect /dashboard
    else Autentikasi Gagal
        AUTH-->>-PETUGAS : Tampilkan error
    end

    deactivate PETUGAS
```

---

## 2. Sequence Diagram - Membuat Tugas

### PlantUML

```plantuml
@startuml
!theme plain
skinparam shadowing false
skinparam roundcorner 8
skinparam defaultFontName sans-serif
skinparam defaultFontColor #0F172A
skinparam backgroundColor #F8FAFC
skinparam ArrowColor #475569

skinparam sequence {
    ArrowColor #475569
    ActorBorderColor #64748B
    ActorBackgroundColor #F1F5F9
    BoxBackgroundColor #FFFFFF
    BoxBorderColor #64748B
    DividerBackgroundColor #F1F5F9
    LifeLineBorderColor #64748B
    LifeLineBackgroundColor #F1F5F9
    MessageArrowColor #475569
    MessageTextColor #0F172A
    NoteBackgroundColor #FEF9C3
    NoteBorderColor #CA8A04
}

title Sequence Diagram - Membuat Tugas

actor ":Kepala Sesi" as KEPSES
participant ":TugasNewPage" as NEW_PAGE
participant ":useCreateTugas" as CREATE_HOOK
participant ":SupabaseDB" as DB

KEPSES -> NEW_PAGE : Mengakses /tugas/baru
activate KEPSES
activate NEW_PAGE

NEW_PAGE -> KEPSES : Tampilkan form tugas baru

KEPSES -> NEW_PAGE : Isi form:
note right
    - judul_tugas
    - alamat
    - tanggal_tugas
end note
NEW_PAGE -> NEW_PAGE : Pilih petugas (multi-select)

KEPSES -> NEW_PAGE : Submit form

NEW_PAGE -> CREATE_HOOK : mutate(tugasData)
deactivate NEW_PAGE

== Insert tugas_header ==

CREATE_HOOK -> DB : INSERT tugas_header
activate DB
DB -> DB : Generate UUID untuk id_tugas
DB --> CREATE_HOOK : tugas_header.id
deactivate DB

== Insert junction (multi-petugas) ==

opt Petugas kedua dan seterusnya
    CREATE_HOOK -> DB : INSERT tugas_petugas (junction)
    activate DB
    loop Untuk setiap petugas yang dipilih
        DB -> DB : Insert junction record
    end
    DB --> CREATE_HOOK : success
    deactivate DB
end

CREATE_HOOK -> CREATE_HOOK : Invalidate queries:
note right
    - tugasList
    - tugasDetail
end note

CREATE_HOOK --> KEPSES : Success, redirect /tugas/:id
deactivate CREATE_HOOK

deactivate KEPSES

@enduml
```

### Mermaid.js

```mermaid
sequenceDiagram
    autonumber
    title Sequence Diagram - Membuat Tugas

    actor KEPSES as :Kepala Sesi
    participant NEW_PAGE as :TugasNewPage
    participant CREATE_HOOK as :useCreateTugas
    participant DB as :SupabaseDB

    KEPSES->>+NEW_PAGE : Mengakses /tugas/baru
    NEW_PAGE-->>-KEPSES : Tampilkan form tugas baru

    KEPSES->>+NEW_PAGE : Isi form (judul, alamat, tanggal, petugas)
    NEW_PAGE-->>-KEPSES : Form terisi

    KEPSES->>+NEW_PAGE : Submit form
    NEW_PAGE->>+CREATE_HOOK : mutate(tugasData)

    rect rgb(240, 248, 255)
        Note over CREATE_HOOK,DB : Insert tugas_header
        CREATE_HOOK->>+DB : INSERT tugas_header
        DB->>DB : Generate UUID
        DB-->>-CREATE_HOOK : tugas_header.id
    end

    rect rgb(255, 250, 240)
        Note over CREATE_HOOK,DB : Insert Junction (Multi-Petugas)
        opt Petugas > 1
            loop Untuk setiap petugas
                CREATE_HOOK->>+DB : INSERT tugas_petugas
                DB-->>-CREATE_HOOK : success
            end
        end
    end

    CREATE_HOOK->>CREATE_HOOK : Invalidate queries
    CREATE_HOOK-->>-KEPSES : Success, redirect /tugas/:id

    deactivate KEPSES
```

---

## 3. Sequence Diagram - Submit Progress Tugas

### PlantUML

```plantuml
@startuml
!theme plain
skinparam shadowing false
skinparam roundcorner 8
skinparam defaultFontName sans-serif
skinparam defaultFontColor #0F172A
skinparam backgroundColor #F8FAFC
skinparam ArrowColor #475569

skinparam sequence {
    ArrowColor #475569
    ActorBorderColor #64748B
    ActorBackgroundColor #F1F5F9
    BoxBackgroundColor #FFFFFF
    BoxBorderColor #64748B
    DividerBackgroundColor #F1F5F9
    LifeLineBorderColor #64748B
    LifeLineBackgroundColor #F1F5F9
    MessageArrowColor #475569
    MessageTextColor #0F172A
    NoteBackgroundColor #FEF9C3
    NoteBorderColor #CA8A04
}

title Sequence Diagram - Submit Progress Tugas

actor ":Petugas" as PETUGAS
participant ":TugasDetailPage" as DETAIL
participant ":TugasLogForm" as LOG_FORM
participant ":ImageUploader" as UPLOADER
participant ":browser-image-compression" as COMPRESS
participant ":SupabaseStorage" as STORAGE
participant ":useSubmitTugasLog" as LOG_HOOK
participant ":SupabaseDB" as DB

PETUGAS -> DETAIL : Akses detail tugas
activate PETUGAS
activate DETAIL
DETAIL --> PETUGAS : Tampilkan detail + tombol "Isi Laporan"
deactivate DETAIL

PETUGAS -> LOG_FORM : Klik "Isi Laporan"
activate LOG_FORM

== Upload Foto ==

PETUGAS -> UPLOADER : Pilih file foto (1-3)
activate UPLOADER

loop Untuk setiap file
    UPLOADER -> COMPRESS : compressImage(file)
    activate COMPRESS
    COMPRESS --> UPLOADER : compressedFile (max 5MB)
    deactivate COMPRESS

    UPLOADER -> STORAGE : Upload ke bucket "tugas-foto"
    activate STORAGE
    STORAGE --> UPLOADER : url_foto
    deactivate STORAGE
end

UPLOADER --> LOG_FORM : Array<url_foto>
deactivate UPLOADER

== Pilih GPS ==

PETUGAS -> LOG_FORM : Aktifkan GPS
LOG_FORM -> LOG_FORM : getCurrentPosition()

alt GPS Tersedia
    LOG_FORM --> LOG_FORM : {latitude, longitude}
else GPS Tidak Tersedia
    LOG_FORM --> PETUGAS : Error: "Izinkan akses lokasi"
end

== Submit Log ==

PETUGAS -> LOG_FORM : Pilih tahapan:
note right
    - Before
    - Ongoing
    - Finished
end note

PETUGAS -> LOG_FORM : Isi deskripsi
PETUGAS -> LOG_FORM : Submit

LOG_FORM -> LOG_HOOK : mutate(logData)
deactivate LOG_FORM

LOG_HOOK -> DB : INSERT tugas_log
activate DB

== Auto-Trigger: Update Status ==

alt Tahapan = Before/Ongoing
    DB -> DB : Trigger: trg_update_status_tugas
    DB -> DB : UPDATE status_tugas = 'Proses'
    note right
        Trigger: trg_update_status_tugas
        Function: update_status_tugas_on_log()
    end note
else Tahapan = Finished
    DB -> DB : Trigger: trg_update_status_tugas
    DB -> DB : UPDATE status_tugas = 'Selesai'
end

DB --> LOG_HOOK : success
deactivate DB

LOG_HOOK -> LOG_HOOK : Invalidate queries
LOG_HOOK --> PETUGAS : Success, refresh data
deactivate LOG_HOOK

deactivate PETUGAS

@enduml
```

### Mermaid.js

```mermaid
sequenceDiagram
    autonumber
    title Sequence Diagram - Submit Progress Tugas

    actor PETUGAS as :Petugas
    participant DETAIL as :TugasDetailPage
    participant LOG_FORM as :TugasLogForm
    participant UPLOADER as :ImageUploader
    participant COMPRESS as :browser-image-compression
    participant STORAGE as :SupabaseStorage
    participant LOG_HOOK as :useSubmitTugasLog
    participant DB as :SupabaseDB

    PETUGAS->>+DETAIL : Akses detail tugas
    DETAIL-->>-PETUGAS : Tampilkan detail + tombol

    PETUGAS->>+LOG_FORM : Klik "Isi Laporan"

    rect rgb(255, 249, 240)
        Note over PETUGAS,STORAGE : Upload Foto
        loop Untuk setiap file (1-3)
            PETUGAS->>+UPLOADER : Pilih file foto
            UPLOADER->>+COMPRESS : compressImage(file)
            COMPRESS-->>-UPLOADER : compressedFile
            UPLOADER->>+STORAGE : Upload ke bucket
            STORAGE-->>-UPLOADER : url_foto
            deactivate UPLOADER
        end
    end

    rect rgb(240, 249, 255)
        Note over PETUGAS,LOG_FORM : GPS Location
        PETUGAS->>+LOG_FORM : Aktifkan GPS
        LOG_FORM->>LOG_FORM : getCurrentPosition()
        alt GPS Tersedia
            LOG_FORM-->>LOG_FORM : {lat, lng}
        else GPS Tidak Tersedia
            LOG_FORM-->>-PETUGAS : Error
        end
    end

    PETUGAS->>+LOG_FORM : Pilih tahapan + deskripsi + Submit

    LOG_FORM->>+LOG_HOOK : mutate(logData)

    rect rgb(255, 240, 245)
        Note over LOG_HOOK,DB : Auto-Trigger: Update Status
        LOG_HOOK->>+DB : INSERT tugas_log

        alt Tahapan = Before/Ongoing
            DB->>DB : Trigger: UPDATE status = 'Proses'
        else Tahapan = Finished
            DB->>DB : Trigger: UPDATE status = 'Selesai'
        end
        DB-->>-LOG_HOOK : success
    end

    LOG_HOOK-->>-PETUGAS : Success, refresh

    deactivate PETUGAS
```

---

## 4. Sequence Diagram - Pengajuan Cuti

### PlantUML

```plantuml
@startuml
!theme plain
skinparam shadowing false
skinparam roundcorner 8
skinparam defaultFontName sans-serif
skinparam defaultFontColor #0F172A
skinparam backgroundColor #F8FAFC
skinparam ArrowColor #475569

skinparam sequence {
    ArrowColor #475569
    ActorBorderColor #64748B
    ActorBackgroundColor #F1F5F9
    BoxBackgroundColor #FFFFFF
    BoxBorderColor #64748B
    DividerBackgroundColor #F1F5F9
    LifeLineBorderColor #64748B
    LifeLineBackgroundColor #F1F5F9
    MessageArrowColor #475569
    MessageTextColor #0F172A
    NoteBackgroundColor #FEF9C3
    NoteBorderColor #CA8A04
}

title Sequence Diagram - Pengajuan Cuti

actor ":Petugas" as PETUGAS
participant ":CutiAjuanPage" as AJUAN
participant ":KuotaIndicator" as KUOTA
participant ":useKuotaCuti" as KUOTA_HOOK
participant ":useCreateCuti" as CREATE_HOOK
participant ":SupabaseStorage" as STORAGE
participant ":SupabaseDB" as DB

PETUGAS -> AJUAN : Mengakses /cuti/ajuan
activate PETUGAS
activate AJUAN

== Cek Kuota ==

AJUAN -> KUOTA_HOOK : fetchKuotaCuti()
activate KUOTA_HOOK
KUOTA_HOOK -> DB : hitung_sisa_kuota_cuti(petugas_id, tahun)
activate DB
DB --> KUOTA_HOOK : sisa_kuota (integer)
deactivate DB
KUOTA_HOOK --> KUOTA : {sisa: number, terpakai: number}
deactivate KUOTA_HOOK

KUOTA --> AJUAN : Tampilkan sisa kuota
AJUAN --> PETUGAS : Tampilkan form pengajuan

== Form Pengajuan ==

PETUGAS -> AJUAN : Pilih jenis cuti:
note right
    - Tahunan
    - Sakit
    - Alasan Penting
end note

alt Jenis = Tahunan
    AJUAN -> KUOTA : Validasi kuota
    KUOTA -> KUOTA : cek sisa_kuota >= hari_diminta

    alt Kuota Tidak Cukup
        KUOTA --> AJUAN : Error: "Kuota tidak cukup"
        AJUAN --> PETUGAS : Tampilkan error
        stop
    end
end

PETUGAS -> AJUAN : Isi tanggal mulai & selesai
PETUGAS -> AJUAN : Isi alasan

alt Upload Lampiran
    PETUGAS -> AJUAN : Upload file (PDF/image)
    AJUAN -> STORAGE : Upload ke bucket "cuti-lampiran"
    activate STORAGE
    STORAGE --> AJUAN : lampiran_url
    deactivate STORAGE
end

PETUGAS -> AJUAN : Submit pengajuan

== Insert Cuti ==

AJUAN -> CREATE_HOOK : mutate(cutiData)
deactivate AJUAN

CREATE_HOOK -> DB : INSERT cuti
activate DB

alt Jenis = Tahunan
    DB -> DB : Trigger: trg_validate_kuota_cuti
    note right
        Validasi: sisa_kuota >= hari_cuti
        Constraint: tgl_selesai >= tgl_mulai
    end note
end

DB -> DB : SET status_approval = 'Menunggu'
DB --> CREATE_HOOK : cuti.id
deactivate DB

CREATE_HOOK -> CREATE_HOOK : Invalidate queries
CREATE_HOOK --> PETUGAS : Success, redirect /cuti
deactivate CREATE_HOOK

deactivate PETUGAS

@enduml
```

### Mermaid.js

```mermaid
sequenceDiagram
    autonumber
    title Sequence Diagram - Pengajuan Cuti

    actor PETUGAS as :Petugas
    participant AJUAN as :CutiAjuanPage
    participant KUOTA as :KuotaIndicator
    participant KUOTA_HOOK as :useKuotaCuti
    participant CREATE_HOOK as :useCreateCuti
    participant STORAGE as :SupabaseStorage
    participant DB as :SupabaseDB

    PETUGAS->>+AJUAN : Mengakses /cuti/ajuan

    rect rgb(240, 248, 255)
        Note over AJUAN,DB : Cek Kuota
        AJUAN->>+KUOTA_HOOK : fetchKuotaCuti()
        KUOTA_HOOK->>+DB : hitung_sisa_kuota_cuti()
        DB-->>-KUOTA_HOOK : sisa_kuota
        KUOTA_HOOK-->>-AJUAN : {sisa, terpakai}
    end

    AJUAN-->>-PETUGAS : Tampilkan form + sisa kuota

    rect rgb(255, 240, 245)
        Note over PETUGAS,STORAGE : Validasi & Upload
        PETUGAS->>+AJUAN : Pilih jenis cuti
        alt Jenis = Tahunan
            AJUAN->>KUOTA : Validasi kuota
            alt Kuota Tidak Cukup
                KUOTA-->>-PETUGAS : Error
            end
        end
        PETUGAS->>+AJUAN : Isi form + upload lampiran (opsional)
        AJUAN->>+STORAGE : Upload ke bucket
        STORAGE-->>-AJUAN : lampiran_url
    end

    PETUGAS->>+AJUAN : Submit pengajuan

    rect rgb(240, 255, 240)
        Note over CREATE_HOOK,DB : Insert Cuti
        AJUAN->>+CREATE_HOOK : mutate(cutiData)
        CREATE_HOOK->>+DB : INSERT cuti

        alt Jenis = Tahunan
            DB->>DB : Trigger: trg_validate_kuota_cuti
        end

        DB-->>-CREATE_HOOK : cuti.id
    end

    CREATE_HOOK-->>-PETUGAS : Success, redirect /cuti

    deactivate PETUGAS
```

---

## 5. Sequence Diagram - Approval Cuti

### PlantUML

```plantuml
@startuml
!theme plain
skinparam shadowing false
skinparam roundcorner 8
skinparam defaultFontName sans-serif
skinparam defaultFontColor #0F172A
skinparam backgroundColor #F8FAFC
skinparam ArrowColor #475569

skinparam sequence {
    ArrowColor #475569
    ActorBorderColor #64748B
    ActorBackgroundColor #F1F5F9
    BoxBackgroundColor #FFFFFF
    BoxBorderColor #64748B
    DividerBackgroundColor #F1F5F9
    LifeLineBorderColor #64748B
    LifeLineBackgroundColor #F1F5F9
    MessageArrowColor #475569
    MessageTextColor #0F172A
    NoteBackgroundColor #FEF9C3
    NoteBorderColor #CA8A04
}

title Sequence Diagram - Approval Cuti

actor ":Operator" as OPERATOR
actor ":Kepala Sesi" as KEPSES
participant ":CutiApprovalPage" as APPROVAL
participant ":useApproveCuti" as APPROVE_HOOK
participant ":useCutiList" as LIST_HOOK
participant ":SupabaseDB" as DB

OPERATOR -> APPROVAL : Mengakses /cuti/approval
activate OPERATOR
activate APPROVAL

APPROVAL -> LIST_HOOK : fetchCutiList(status='Menunggu')
activate LIST_HOOK
LIST_HOOK -> DB : SELECT cuti WHERE status='Menunggu'
activate DB
DB --> LIST_HOOK : Array<cuti pending>
deactivate DB
LIST_HOOK --> APPROVAL : Tampilkan daftar pengajuan
deactivate LIST_HOOK

loop Setiap pengajuan
    APPROVAL --> OPERATOR : Tampilkan CutiCard
    note right
        - Nama petugas
        - Jenis cuti
        - Tanggal
        - Alasan
        - Tombol: Setuju / Tolak
    end note

    == Decision ==

    OPERATOR -> APPROVAL : Klik action button

    alt Setujui
        APPROVAL -> APPROVE_HOOK : mutate({id, status: 'Disetujui'})
    else Tolak
        APPROVAL -> APPROVE_HOOK : mutate({id, status: 'Tidak Disetujui'})
    else Tangguhkan
        APPROVAL -> APPROVE_HOOK : mutate({id, status: 'Ditangguhkan'})
    end

    APPROVAL --> OPERATOR : Konfirmasi dialog

    OPERATOR -> APPROVAL : Konfirmasi

    deactivate APPROVAL

    == Update Status ==

    APPROVE_HOOK -> DB : UPDATE cuti SET status_approval, approved_by
    activate DB

    alt Jenis = Tahunan AND status = Disetujui
        DB -> DB : UPDATE quota tracking
        note right
            Kurangi sisa_kuota
            berdasarkan jumlah hari cuti
        end note
    end

    DB --> APPROVE_HOOK : success
    deactivate DB

    APPROVE_HOOK -> LIST_HOOK : Invalidate queries
    APPROVE_HOOK --> OPERATOR : Success notification
    deactivate APPROVE_HOOK

    APPROVAL --> OPERATOR : Refresh daftar
    activate APPROVAL
end

deactivate OPERATOR

@enduml
```

### Mermaid.js

```mermaid
sequenceDiagram
    autonumber
    title Sequence Diagram - Approval Cuti

    actor OPERATOR as :Operator
    actor KEPSES as :Kepala Sesi
    participant APPROVAL as :CutiApprovalPage
    participant LIST_HOOK as :useCutiList
    participant APPROVE_HOOK as :useApproveCuti
    participant DB as :SupabaseDB

    OPERATOR->>+APPROVAL : Mengakses /cuti/approval

    rect rgb(240, 248, 255)
        Note over APPROVAL,DB : Fetch Pending
        APPROVAL->>+LIST_HOOK : fetchCutiList(status='Menunggu')
        LIST_HOOK->>+DB : SELECT cuti WHERE status='Menunggu'
        DB-->>-LIST_HOOK : Array<cuti pending>
        LIST_HOOK-->>-APPROVAL : Tampilkan daftar
    end

    loop Setiap pengajuan
        APPROVAL-->>-OPERATOR : Tampilkan CutiCard

        OPERATOR->>+APPROVAL : Pilih action

        rect rgb(255, 250, 240)
            Note over APPROVAL,DB : Update Status
            alt Setujui
                APPROVAL->>+APPROVE_HOOK : mutate({status: 'Disetujui'})
            else Tolak
                APPROVAL->>+APPROVE_HOOK : mutate({status: 'Tidak Disetujui'})
            else Tangguhkan
                APPROVAL->>+APPROVE_HOOK : mutate({status: 'Ditangguhkan'})
            end

            OPERATOR->>APPROVAL : Konfirmasi

            APPROVAL->>+DB : UPDATE cuti
            DB->>DB : Update quota jika Disetujui & Tahunan
            DB-->>-APPROVAL : success
            deactivate APPROVAL
        end

        APPROVE_HOOK-->>-OPERATOR : Success notification
    end

    deactivate OPERATOR
```

---

## 6. Sequence Diagram - Input Penilaian

### PlantUML

```plantuml
@startuml
!theme plain
skinparam shadowing false
skinparam roundcorner 8
skinparam defaultFontName sans-serif
skinparam defaultFontColor #0F172A
skinparam backgroundColor #F8FAFC
skinparam ArrowColor #475569

skinparam sequence {
    ArrowColor #475569
    ActorBorderColor #64748B
    ActorBackgroundColor #F1F5F9
    BoxBackgroundColor #FFFFFF
    BoxBorderColor #64748B
    DividerBackgroundColor #F1F5F9
    LifeLineBorderColor #64748B
    LifeLineBackgroundColor #F1F5F9
    MessageArrowColor #475569
    MessageTextColor #0F172A
    NoteBackgroundColor #FEF9C3
    NoteBorderColor #CA8A04
}

title Sequence Diagram - Input Penilaian

actor ":Operator" as OPERATOR
participant ":PenilaianFormPage" as FORM
participant ":useCreatePenilaian" as CREATE_HOOK
participant ":usePetugasList" as PETUGAS_HOOK
participant ":SupabaseDB" as DB

OPERATOR -> FORM : Mengakses /penilaian/baru
activate OPERATOR
activate FORM

== Load Data ==

FORM -> PETUGAS_HOOK : fetchPetugasList()
activate PETUGAS_HOOK
PETUGAS_HOOK -> DB : SELECT master_petugas
activate DB
DB --> PETUGAS_HOOK : Array<petugas aktif>
deactivate DB
PETUGAS_HOOK --> FORM : daftar petugas
deactivate PETUGAS_HOOK

FORM --> OPERATOR : Tampilkan form penilaian

== Form Input ==

OPERATOR -> FORM : Pilih petugas
OPERATOR -> FORM : Pilih periode (bulan, tahun)

loop 3 Kriteria
    OPERATOR -> FORM : Input skor (0-100)
    note right
        - Disiplin & Kehadiran
        - Tanggung Jawab
        - Kepatuhan
    end note

    FORM -> FORM : Validasi: skor 0-100
    FORM -> FORM : Update total_nilai preview
end

OPERATOR -> FORM : Tambah catatan (opsional)
OPERATOR -> FORM : Submit

== Insert Penilaian ==

FORM -> CREATE_HOOK : mutate(penilaianData)
deactivate FORM

CREATE_HOOK -> DB : INSERT penilaian
activate DB

note right
    Data inserted:
    - id_petugas
    - id_operator (current user)
    - periode_bulan, periode_tahun
    - skor_displin_kehadiran
    - skor_tanggung_jawab
    - skor_kepatuhan
    - catatan
end note

== Auto-Calculate Total ==

DB -> DB : COMPUTE total_nilai
note right
    total_nilai = AVG(
        skor_displin,
        skor_tanggung,
        skor_kepatuhan
    )
    Generated column di database
end note

DB --> CREATE_HOOK : penilaian.id
deactivate DB

CREATE_HOOK -> CREATE_HOOK : Invalidate queries

alt Sukses
    CREATE_HOOK --> OPERATOR : Success, redirect /penilaian
else Duplicate Entry
    CREATE_HOOK --> OPERATOR : Error: "Penilaian sudah ada"
    note right
        UNIQUE constraint:
        (id_petugas, id_operator,
        periode_bulan, periode_tahun)
    end note
end
deactivate CREATE_HOOK

deactivate OPERATOR

@enduml
```

### Mermaid.js

```mermaid
sequenceDiagram
    autonumber
    title Sequence Diagram - Input Penilaian

    actor OPERATOR as :Operator
    participant FORM as :PenilaianFormPage
    participant PETUGAS_HOOK as :usePetugasList
    participant CREATE_HOOK as :useCreatePenilaian
    participant DB as :SupabaseDB

    OPERATOR->>+FORM : Mengakses /penilaian/baru

    rect rgb(240, 248, 255)
        Note over FORM,DB : Load Data
        FORM->>+PETUGAS_HOOK : fetchPetugasList()
        PETUGAS_HOOK->>+DB : SELECT master_petugas
        DB-->>-PETUGAS_HOOK : Array<petugas aktif>
        PETUGAS_HOOK-->>-FORM : daftar petugas
    end

    FORM-->>-OPERATOR : Tampilkan form

    rect rgb(255, 250, 240)
        Note over OPERATOR,DB : Input & Calculate
        loop 3 Kriteria Penilaian
            OPERATOR->>+FORM : Input skor (0-100)
            FORM->>FORM : Validasi + Preview
        end
    end

    OPERATOR->>+FORM : Submit

    rect rgb(240, 255, 240)
        Note over CREATE_HOOK,DB : Insert & Calculate
        FORM->>+CREATE_HOOK : mutate(penilaianData)
        CREATE_HOOK->>+DB : INSERT penilaian
        DB->>DB : COMPUTE total_nilai = AVG(skor_1, skor_2, skor_3)
        DB-->>-CREATE_HOOK : penilaian.id
    end

    alt Sukses
        CREATE_HOOK-->>-OPERATOR : Success, redirect
    else Duplicate
        CREATE_HOOK-->>-OPERATOR : Error: sudah ada
    end

    deactivate OPERATOR
```

---

## Legenda Simbol

### PlantUML

| Simbol | Arti |
|--------|------|
| `actor` | Pengguna atau sistem eksternal |
| `participant` | Komponen dalam sistem |
| `->` | Pesan sinkron |
| `-->` | Pesan return |
| `->>` | Asynchronous message |
| `activate/deactivate` | Aktivasi lifecycle |
| `alt/else/opt` | Fragmen bersyarat |
| `loop` | Fragmen berulang |
| `note` | Catatan |

### Mermaid.js

| Simbol | Arti |
|--------|------|
| `actor` | Pengguna |
| `participant` | Komponen |
| `->>` | Arrow dengan arrowhead |
| `-->>` | Dashed arrow |
| `loop` | Loop fragment |
| `alt/else` | Alternative fragment |
| `opt` | Optional fragment |
| `rect rgb()` | Background color |
| `Note over` | Catatan spanning |
| `autonumber` | Nomor otomatis |

---

## Alur Bisnis Summary

| No | Alur | Actor Utama | Modul |
|----|------|-------------|-------|
| 1 | Login | Petugas/Operator/Kepala Sesi | Auth |
| 2 | Membuat Tugas | Kepala Sesi | Tugas |
| 3 | Submit Progress | Petugas | Tugas |
| 4 | Pengajuan Cuti | Petugas | Cuti |
| 5 | Approval Cuti | Operator/Kepala Sesi | Cuti |
| 6 | Input Penilaian | Operator | Penilaian |

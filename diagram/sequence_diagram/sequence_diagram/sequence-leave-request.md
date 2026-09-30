# Sequence Diagram - Pengajuan Cuti
# Sistem E-Kinerja

## PlantUML

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

== Cek Kuota Cuti ==

AJUAN -> KUOTA_HOOK : query: useKuotaCuti()
activate KUOTA_HOOK
KUOTA_HOOK -> DB : SELECT hitung_sisa_kuota_cuti(petugas_id, tahun)
activate DB
DB --> KUOTA_HOOK : {sisa: number, terpakai: number}
deactivate DB
KUOTA_HOOK --> KUOTA : Display kuota info
deactivate KUOTA_HOOK

KUOTA --> AJUAN : Render kuota indicator
AJUAN --> PETUGAS : Tampilkan form + kuota

== Pilih Jenis Cuti ==

PETUGAS -> AJUAN : Pilih jenis cuti:
note right
    - Tahunan (kuota 12 hari)
    - Sakit (tanpa kuota)
    - Alasan Penting (tanpa kuota)
end note

alt Jenis = 'Tahunan'
    AJUAN -> KUOTA : Validasi sisa_kuota >= hari_diminta

    alt Kuota Tidak Cukup
        KUOTA --> AJUAN : Show validation error
        AJUAN --> PETUGAS : Error: "Kuota tidak cukup"
        stop
    end
end

== Isi Form ==

PETUGAS -> AJUAN : Isi tanggal mulai & selesai
AJUAN -> AJUAN : Validate: tgl_selesai >= tgl_mulai
alt Validasi Gagal
    AJUAN --> PETUGAS : Error: "Tanggal tidak valid"
end

PETUGAS -> AJUAN : Isi alasan (text)
PETUGAS -> AJUAN : Upload lampiran (opsional)
activate AJUAN

alt Ada Lampiran
    PETUGAS -> AJUAN : Pilih file (PDF/image, max 10MB)
    AJUAN -> STORAGE : Upload ke 'cuti-lampiran' bucket
    activate STORAGE
    STORAGE --> AJUAN : lampiran_url
    deactivate STORAGE
end
deactivate AJUAN

== Submit Pengajuan ==

PETUGAS -> AJUAN : Submit
activate AJUAN
AJUAN -> CREATE_HOOK : mutate(cutiData)
deactivate AJUAN

CREATE_HOOK -> DB : INSERT INTO cuti
activate DB

note right
    Fields:
    - id_petugas = current_user.id
    - jenis_cuti
    - tgl_mulai
    - tgl_selesai
    - alasan
    - lampiran_url
    - status_approval = 'Menunggu'
end note

alt jenis_cuti = 'Tahunan'
    DB -> DB : Trigger: trg_validate_kuota_cuti
    note right
        Function: validate_kuota_cuti()
        Check: sisa_kuota >= hari_cuti
    end note
end

DB --> CREATE_HOOK : {id: uuid, status_approval: 'Menunggu'}
deactivate DB

CREATE_HOOK -> CREATE_HOOK : Invalidate queries
note right
    Invalidated:
    - ['cuti', 'list']
    - ['kuotaCuti']
end note

CREATE_HOOK --> PETUGAS : Success, navigate /cuti
deactivate CREATE_HOOK

deactivate PETUGAS

@enduml
```

## Mermaid.js

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
        AJUAN->>+KUOTA_HOOK : useKuotaCuti()
        KUOTA_HOOK->>+DB : hitung_sisa_kuota_cuti()
        DB-->>-KUOTA_HOOK : {sisa, terpakai}
        KUOTA_HOOK-->>-AJUAN : Display kuota
    end

    AJUAN-->>-PETUGAS : Tampilkan form

    PETUGAS->>+AJUAN : Pilih jenis cuti

    alt Jenis = 'Tahunan'
        rect rgb(255, 240, 240)
            Note over AJUAN,DB : Validasi Kuota
            AJUAN->>KUOTA : Validasi sisa >= hari
            alt Kuota Tidak Cukup
                KUOTA-->>-PETUGAS : Error
            end
        end
    end

    PETUGAS->>+AJUAN : Isi form + upload lampiran (opsional)

    alt Ada Lampiran
        AJUAN->>+STORAGE : Upload ke bucket
        STORAGE-->>-AJUAN : lampiran_url
    end

    PETUGAS->>+AJUAN : Submit

    rect rgb(240, 255, 240)
        Note over CREATE_HOOK,DB : Insert Cuti
        AJUAN->>+CREATE_HOOK : mutate(cutiData)
        CREATE_HOOK->>+DB : INSERT INTO cuti

        alt jenis = 'Tahunan'
            DB->>DB : Trigger: validate_kuota_cuti
        end

        DB-->>-CREATE_HOOK : {id, status: 'Menunggu'}
    end

    CREATE_HOOK-->>-PETUGAS : Success, navigate /cuti

    deactivate PETUGAS
```

## Deskripsi Alur

| Step | Aksi | Komponen |
|------|------|----------|
| 1 | Akses halaman ajuan cuti | CutiAjuanPage |
| 2 | Cek sisa kuota cuti tahunan | useKuotaCuti, hitung_sisa_kuota_cuti() |
| 3 | Pilih jenis cuti | Form |
| 4 | Validasi kuota (jika tahunan) | KuotaIndicator |
| 5 | Isi tanggal & alasan | Form |
| 6 | Upload lampiran (opsional) | SupabaseStorage |
| 7 | Submit pengajuan | useCreateCuti |
| 8 | Insert ke database | SupabaseDB |
| 9 | Trigger validasi kuota | trg_validate_kuota_cuti |
| 10 | Invalidate cache + redirect | TanStack Query |

## Jenis Cuti

| Jenis | Kuota | Validasi |
|-------|-------|----------|
| Tahunan | 12 hari/tahun | Wajib cek sisa kuota |
| Sakit | Tidak terbatas | Tanpa validasi kuota |
| Alasan Penting | Tidak terbatas | Tanpa validasi kuota |

## Validasi Checklist

| Field | Rule |
|-------|------|
| tgl_mulai | Required, date |
| tgl_selesai | Required, >= tgl_mulai |
| alasan | Required, text |
| lampiran | Optional, PDF/image, max 10MB |
| jenis_cuti = 'Tahunan' | sisa_kuota >= hari_cuti |

## Business Rules

1. **Kuota Cuti Tahunan**: 12 hari per tahun
2. **Perhitungan Hari**: inklusif (tgl_mulai s/d tgl_selesai)
3. **Trigger Validation**: Before INSERT untuk jenis 'Tahunan'
4. **Status Awal**: Semua pengajuan berstatus 'Menunggu'

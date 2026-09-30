# Sequence Diagram - Input Penilaian
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

title Sequence Diagram - Input Penilaian

actor ":Operator" as OPERATOR
participant ":PenilaianFormPage" as FORM
participant ":usePetugasList" as PETUGAS_HOOK
participant ":useCreatePenilaian" as CREATE_HOOK
participant ":SupabaseDB" as DB

== Akses Halaman ==

OPERATOR -> FORM : Mengakses /penilaian/baru
activate OPERATOR
activate FORM

FORM -> PETUGAS_HOOK : query: usePetugasList()
activate PETUGAS_HOOK
PETUGAS_HOOK -> DB : SELECT master_petugas WHERE status_aktif = true
activate DB
DB --> PETUGAS_HOOK : Array<petugas aktif>
deactivate DB
PETUGAS_HOOK --> FORM : daftar petugas
deactivate PETUGAS_HOOK

FORM --> OPERATOR : Tampilkan form penilaian
deactivate FORM

== Input Data ==

OPERATOR -> FORM : Pilih petugas
activate FORM
note right
    Dropdown dari daftar petugas aktif
end note

OPERATOR -> FORM : Pilih periode (bulan, tahun)

loop Input 3 Kriteria Skor

    OPERATOR -> FORM : Input skor_displin_kehadiran
    FORM -> FORM : Validate: skor >= 0 AND skor <= 100
    FORM -> FORM : Update preview total_nilai

    OPERATOR -> FORM : Input skor_tanggung_jawab
    FORM -> FORM : Validate + update preview

    OPERATOR -> FORM : Input skor_kepatuhan
    FORM -> FORM : Validate + update preview

end

OPERATOR -> FORM : Tambah catatan (opsional)

OPERATOR -> FORM : Submit

== Insert Penilaian ==

FORM -> CREATE_HOOK : mutate(penilaianData)
deactivate FORM

CREATE_HOOK -> DB : INSERT INTO penilaian
activate DB

note right
    Fields:
    - id_petugas
    - id_operator (current_user.id)
    - periode_bulan
    - periode_tahun
    - skor_displin_kehadiran
    - skor_tanggung_jawab
    - skor_kepatuhan
    - catatan
end note

== Auto-Calculate Total ==

DB -> DB : COMPUTE total_nilai = AVG(skor_1, skor_2, skor_3)
note right
    Generated column di PostgreSQL:
    total_nilai DECIMAL GENERATED ALWAYS
    AS (AVG(skor_1, skor_2, skor_3)) STORED
end note

alt Sukses
    DB --> CREATE_HOOK : {id: uuid}
    deactivate DB

    CREATE_HOOK -> CREATE_HOOK : queryClient.invalidateQueries
    note right
        Invalidated:
        - ['penilaian', 'list']
    end note

    CREATE_HOOK --> OPERATOR : Success, navigate /penilaian
    deactivate CREATE_HOOK

else Duplicate Entry Error
    DB --> CREATE_HOOK : error: duplicate key
    deactivate DB

    CREATE_HOOK --> OPERATOR : Error: "Penilaian sudah ada"
    note right
        UNIQUE constraint:
        (id_petugas, id_operator,
        periode_bulan, periode_tahun)
    end note
    deactivate CREATE_HOOK
end

deactivate OPERATOR

@enduml
```

## Mermaid.js

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
        Note over FORM,DB : Load Petugas List
        FORM->>+PETUGAS_HOOK : usePetugasList()
        PETUGAS_HOOK->>+DB : SELECT master_petugas
        DB-->>-PETUGAS_HOOK : Array<petugas aktif>
        PETUGAS_HOOK-->>-FORM : daftar petugas
    end

    FORM-->>-OPERATOR : Tampilkan form

    rect rgb(255, 250, 240)
        Note over OPERATOR,FORM : Input Data
        OPERATOR->>+FORM : Pilih petugas + periode

        loop 3 Kriteria Skor
            OPERATOR->>FORM : Input skor (0-100)
            FORM->>FORM : Validate + preview total
        end
    end

    OPERATOR->>+FORM : Submit

    rect rgb(240, 255, 240)
        Note over CREATE_HOOK,DB : Insert + Calculate
        FORM->>+CREATE_HOOK : mutate(penilaianData)
        CREATE_HOOK->>+DB : INSERT INTO penilaian

        DB->>DB : COMPUTE total_nilai = AVG(skor_1, skor_2, skor_3)

        alt Sukses
            DB-->>-CREATE_HOOK : {id: uuid}
        else Duplicate
            DB-->>-CREATE_HOOK : error: duplicate key
        end
    end

    alt Sukses
        CREATE_HOOK->>CREATE_HOOK : Invalidate queries
        CREATE_HOOK-->>-OPERATOR : Success, navigate /penilaian
    else Duplicate
        CREATE_HOOK-->>-OPERATOR : Error: sudah ada
    end

    deactivate OPERATOR
```

## Deskripsi Alur

| Step | Aksi | Komponen |
|------|------|----------|
| 1 | Akses halaman input penilaian | PenilaianFormPage |
| 2 | Fetch daftar petugas aktif | usePetugasList |
| 3 | Pilih petugas dan periode | Form |
| 4 | Input 3 skor kriteria | Form |
| 5 | Real-time preview total nilai | Form |
| 6 | Submit data | useCreatePenilaian |
| 7 | Insert ke database | SupabaseDB |
| 8 | Auto-compute total_nilai | PostgreSQL Generated Column |
| 9 | Invalidate cache + redirect | TanStack Query |

## Kriteria Penilaian

| Kriteria | Field | Range |
|----------|-------|-------|
| Disiplin dan Kehadiran | skor_displin_kehadiran | 0 - 100 |
| Tanggung Jawab | skor_tanggung_jawab | 0 - 100 |
| Kepatuhan | skor_kepatuhan | 0 - 100 |

## Formula Perhitungan

```sql
total_nilai = (skor_displin + skor_tanggung + skor_kepatuhan) / 3
```

atau menggunakan PostgreSQL:

```sql
total_nilai DECIMAL GENERATED ALWAYS
    AS ((skor_displin + skor_tanggung + skor_kepatuhan) / 3) STORED
```

## Validasi Checklist

| Field | Rule |
|-------|------|
| id_petugas | Required, UUID valid |
| id_operator | Auto-set dari current user |
| periode_bulan | Required, integer 1-12 |
| periode_tahun | Required, integer YYYY |
| skor_* | Required, decimal 0.00 - 100.00 |
| catatan | Optional, text |

## Business Rules

1. **UNIQUE Constraint**: (id_petugas, id_operator, periode_bulan, periode_tahun)
2. **Auto-Generated**: total_nilai dihitung otomatis oleh PostgreSQL
3. **Role-Based**: Hanya Operator yang bisa input penilaian
4. **Periode**: Setiap petugas bisa dinilai 1x per periode oleh 1 operator

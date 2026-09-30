# Sequence Diagram - Membuat Tugas
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

title Sequence Diagram - Membuat Tugas

actor ":Kepala Sesi" as KEPSES
participant ":TugasNewPage" as NEW_PAGE
participant ":useCreateTugas" as CREATE_HOOK
participant ":SupabaseDB" as DB

KEPSES -> NEW_PAGE : Mengakses /tugas/baru
activate KEPSES
activate NEW_PAGE
NEW_PAGE --> KEPSES : Tampilkan form tugas baru
deactivate NEW_PAGE

KEPSES -> NEW_PAGE : Isi form tugas
note right
    - judul_tugas
    - alamat
    - tanggal_tugas
end note
deactivate KEPSES

NEW_PAGE --> KEPSES : Form fields

KEPSES -> NEW_PAGE : Pilih petugas (multi-select)
activate NEW_PAGE
NEW_PAGE --> KEPSES : Dialog pilih petugas
deactivate NEW_PAGE

KEPSES -> NEW_PAGE : Submit form
activate NEW_PAGE

NEW_PAGE -> CREATE_HOOK : mutate(tugasData)
deactivate NEW_PAGE

== Insert tugas_header ==

CREATE_HOOK -> DB : INSERT INTO tugas_header
activate DB
DB -> DB : Generate UUID (id)
DB -> DB : SET id_petugas = first selected
DB -> DB : SET status_tugas = 'Menunggu'
DB --> CREATE_HOOK : {id: uuid}
deactivate DB

== Insert Junction (Multi-Petugas) ==

opt Petugas kedua dan seterusnya
    loop Untuk setiap petugas tersisa
        CREATE_HOOK -> DB : INSERT INTO tugas_petugas
        note right
            Junction table untuk
            multi-petugas assignment
        end note
        activate DB
        DB --> CREATE_HOOK : success
        deactivate DB
    end
end

CREATE_HOOK -> CREATE_HOOK : queryClient.invalidateQueries
note right
    Invalidated queries:
    - ['tugas', 'list']
    - ['tugas', 'detail']
end note

CREATE_HOOK --> KEPSES : navigate('/tugas/:id')
deactivate CREATE_HOOK

@enduml
```

## Mermaid.js

```mermaid
sequenceDiagram
    autonumber
    title Sequence Diagram - Membuat Tugas

    actor KEPSES as :Kepala Sesi
    participant NEW_PAGE as :TugasNewPage
    participant CREATE_HOOK as :useCreateTugas
    participant DB as :SupabaseDB

    KEPSES->>+NEW_PAGE : Mengakses /tugas/baru
    NEW_PAGE-->>-KEPSES : Tampilkan form

    KEPSES->>+NEW_PAGE : Isi form + pilih petugas
    NEW_PAGE-->>-KEPSES : Form terisi

    KEPSES->>+NEW_PAGE : Submit form

    NEW_PAGE->>+CREATE_HOOK : mutate(tugasData)

    rect rgb(240, 248, 255)
        Note over CREATE_HOOK,DB : Insert tugas_header
        CREATE_HOOK->>+DB : INSERT INTO tugas_header
        DB->>DB : Generate UUID, set status='Menunggu'
        DB-->>-CREATE_HOOK : {id: uuid}
    end

    rect rgb(255, 250, 240)
        Note over CREATE_HOOK,DB : Insert Junction
        opt Petugas > 1
            loop Untuk setiap petugas
                CREATE_HOOK->>+DB : INSERT INTO tugas_petugas
                DB-->>-CREATE_HOOK : success
            end
        end
    end

    CREATE_HOOK->>CREATE_HOOK : Invalidate queries
    CREATE_HOOK-->>-KEPSES : navigate('/tugas/:id')

    deactivate KEPSES
```

## Deskripsi Alur

| Step | Aksi | Komponen |
|------|------|----------|
| 1 | Kepala Sesi akses halaman buat tugas | TugasNewPage |
| 2 | Isi form: judul, alamat, tanggal | Form |
| 3 | Pilih petugas (multi-select via dialog) | MultiSelect Dialog |
| 4 | Submit form | Form |
| 5 | Insert ke tugas_header | SupabaseDB |
| 6 | Insert junction untuk petugas tambahan | SupabaseDB |
| 7 | Invalidate TanStack Query cache | useCreateTugas |
| 8 | Redirect ke detail tugas | React Router |

## Business Rules

| Rule | Detail |
|------|--------|
| ID Generation | UUID auto-generated |
| Status Awal | 'Menunggu' |
| Multi-Petugas | via junction table tugas_petugas |
| Required Fields | judul_tugas, tanggal_tugas |

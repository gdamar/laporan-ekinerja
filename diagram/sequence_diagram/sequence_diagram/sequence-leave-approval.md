# Sequence Diagram - Approval Cuti
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
    DividerBackgroundColor ##F1F5F9
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
participant ":CutiApprovalPage" as PAGE
participant ":CutiCard" as CARD
participant ":useCutiList" as LIST_HOOK
participant ":useApproveCuti" as APPROVE_HOOK
participant ":SupabaseDB" as DB

== Akses Halaman ==

OPERATOR -> PAGE : Mengakses /cuti/approval
activate OPERATOR
activate PAGE

PAGE -> LIST_HOOK : query: useCutiList({status: 'Menunggu'})
activate LIST_HOOK
LIST_HOOK -> DB : SELECT cuti WHERE status_approval = 'Menunggu'
activate DB

alt Role = Operator
    DB -> DB : RLS: Tampilkan semua cuti
else Role = Kepala Sesi
    DB -> DB : RLS: Tampilkan semua cuti
end

DB --> LIST_HOOK : Array<cuti pending>
deactivate DB
LIST_HOOK --> PAGE : Render list
deactivate LIST_HOOK

PAGE --> OPERATOR : Tampilkan daftar CutiCard
note right
    Setiap CutiCard menampilkan:
    - Nama petugas
    - Jenis cuti
    - Tanggal (mulai - selesai)
    - Alasan
    - Tombol: Setuju / Tolak / Tangguhkan
end note

== Proses Approval ==

loop Untuk setiap pengajuan

    PAGE -> CARD : Render individual card
    CARD --> OPERATOR : Display details

    OPERATOR -> CARD : Klik action button

    alt Aksi = Setuju
        CARD -> APPROVE_HOOK : mutate({id, status: 'Disetujui'})
    else Aksi = Tolak
        CARD -> APPROVE_HOOK : mutate({id, status: 'Tidak Disetujui'})
    else Aksi = Tangguhkan
        CARD -> APPROVE_HOOK : mutate({id, status: 'Ditangguhkan'})
    end

    CARD --> OPERATOR : Show confirmation dialog
    OPERATOR -> CARD : Konfirmasi
    deactivate CARD

    == Update Status ==

    APPROVE_HOOK -> DB : UPDATE cuti
    activate DB

    note right
        SET status_approval = new_status
        SET approved_by = current_user.id
        SET updated_at = NOW()
    end note

    alt status = 'Disetujui' AND jenis_cuti = 'Tahunan'
        DB -> DB : UPDATE kuota tracking
        note right
            Kurangi sisa_kuota
            berdasarkan jumlah hari cuti
        end note
    end

    DB --> APPROVE_HOOK : {id, status_approval: updated}
    deactivate DB

    APPROVE_HOOK -> LIST_HOOK : queryClient.invalidateQueries
    note right
        Invalidated:
        - ['cuti', 'list']
        - ['cuti', 'detail', id]
    end note

    APPROVE_HOOK --> OPERATOR : Show success toast
    deactivate APPROVE_HOOK

    PAGE --> OPERATOR : Refresh list (auto)
    activate PAGE

end

deactivate PAGE
deactivate OPERATOR

@enduml
```

## Mermaid.js

```mermaid
sequenceDiagram
    autonumber
    title Sequence Diagram - Approval Cuti

    actor OPERATOR as :Operator
    actor KEPSES as :Kepala Sesi
    participant PAGE as :CutiApprovalPage
    participant CARD as :CutiCard
    participant LIST_HOOK as :useCutiList
    participant APPROVE_HOOK as :useApproveCuti
    participant DB as :SupabaseDB

    OPERATOR->>+PAGE : Mengakses /cuti/approval

    rect rgb(240, 248, 255)
        Note over PAGE,DB : Fetch Pending List
        PAGE->>+LIST_HOOK : useCutiList({status: 'Menunggu'})
        LIST_HOOK->>+DB : SELECT cuti WHERE status='Menunggu'
        DB-->>-LIST_HOOK : Array<cuti pending>
        LIST_HOOK-->>-PAGE : Render list
    end

    PAGE-->>-OPERATOR : Tampilkan CutiCard list

    loop Untuk setiap pengajuan

        PAGE->>+CARD : Render card
        CARD-->>-OPERATOR : Display details

        OPERATOR->>+CARD : Klik action

        rect rgb(255, 250, 240)
            Note over CARD,DB : Update Status
            alt Setuju
                CARD->>+APPROVE_HOOK : mutate({status: 'Disetujui'})
            else Tolak
                CARD->>+APPROVE_HOOK : mutate({status: 'Tidak Disetujui'})
            else Tangguhkan
                CARD->>+APPROVE_HOOK : mutate({status: 'Ditangguhkan'})
            end

            OPERATOR->>CARD : Konfirmasi
            CARD->>+DB : UPDATE cuti

            alt Disetujui & Tahunan
                DB->>DB : UPDATE kuota
            end

            DB-->>-APPROVE_HOOK : success
        end

        APPROVE_HOOK-->>-OPERATOR : Toast notification
    end

    PAGE->>PAGE : Refresh list
    deactivate PAGE

    deactivate OPERATOR
```

## Deskripsi Alur

| Step | Aksi | Komponen |
|------|------|----------|
| 1 | Akses halaman approval | CutiApprovalPage |
| 2 | Fetch daftar cuti pending | useCutiList |
| 3 | Tampilkan CutiCard per pengajuan | CutiCard |
| 4 | Review detail pengajuan | Card UI |
| 5 | Pilih aksi (Setuju/Tolak/Tangguhkan) | useApproveCuti |
| 6 | Konfirmasi aksi | Confirmation Dialog |
| 7 | Update status di database | SupabaseDB |
| 8 | Update kuota jika Disetujui + Tahunan | Database trigger |
| 9 | Invalidate cache + show toast | TanStack Query |

## Status Approval

| Status | Arti | Efek ke Kuota |
|--------|------|---------------|
| Menunggu | Pending review | - |
| Disetujui | Approved | Kurangi kuota (jika Tahunan) |
| Ditangguhkan | On hold | - |
| Tidak Disetujui | Rejected | - |

## Aktor yang Bisa Approval

| Role | Hak Approval |
|------|-------------|
| Operator | Ya |
| Kepala Sesi | Ya |
| Petugas | Tidak |

## Validasi Checklist

| Field | Rule |
|-------|------|
| id | Required, UUID valid |
| status | Enum: Disetujui, Ditangguhkan, Tidak Disetujui |
| approved_by | Auto-set dari current user |
| updated_at | Auto-set ke NOW() |

## Business Rules

1. **RLS Policy**: Hanya Operator & Kepala Sesi bisa melihat semua pengajuan
2. **Kuota Update**: Jika Disetujui dan jenis 'Tahunan', kurangi sisa_kuota
3. **Audit Trail**: Simpan approved_by dan updated_at
4. **Real-time**: List auto-refresh setelah action

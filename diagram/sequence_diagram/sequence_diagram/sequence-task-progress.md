# Sequence Diagram - Submit Progress Tugas
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

title Sequence Diagram - Submit Progress Tugas

actor ":Petugas" as PETUGAS
participant ":TugasDetailPage" as DETAIL
participant ":TugasLogForm" as LOG_FORM
participant ":ImageUploader" as UPLOADER
participant ":browser-image-compression" as COMPRESS
participant ":SupabaseStorage" as STORAGE
participant ":useSubmitTugasLog" as LOG_HOOK
participant ":SupabaseDB" as DB

PETUGAS -> DETAIL : Akses /tugas/:id
activate PETUGAS
activate DETAIL
DETAIL --> PETUGAS : Tampilkan detail + tombol "Isi Laporan"
deactivate DETAIL

PETUGAS -> LOG_FORM : Klik "Isi Laporan"
activate LOG_FORM

== Upload Foto (1-3 foto) ==

PETUGAS -> UPLOADER : Pilih file foto
activate UPLOADER

loop Untuk setiap file
    UPLOADER -> COMPRESS : compressImage(file, maxSizeMB=0.5)
    activate COMPRESS
    COMPRESS --> UPLOADER : compressedBlob
    deactivate COMPRESS

    UPLOADER -> STORAGE : Upload to 'tugas-foto' bucket
    activate STORAGE
    STORAGE --> UPLOADER : {publicUrl: string}
    deactivate STORAGE
end

UPLOADER --> LOG_FORM : Array<url_foto>
deactivate UPLOADER

== Ambil Lokasi GPS ==

PETUGAS -> LOG_FORM : Aktifkan GPS / Pilih di map
LOG_FORM -> LOG_FORM : getCurrentPosition()

alt GPS Tersedia
    LOG_FORM --> LOG_FORM : {latitude, longitude}
else GPS Error
    LOG_FORM --> PETUGAS : Error: "Lokasi tidak tersedia"
    stop
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

LOG_HOOK -> DB : INSERT INTO tugas_log
activate DB
DB -> DB : Validate url_foto array length (1-3)
DB -> DB : Validate latitude/longitude exists

== Auto-Trigger: Update Status ==

alt tahapan IN ('Before', 'Ongoing')
    DB -> DB : UPDATE tugas_header SET status_tugas = 'Proses'
    note right
        Trigger: trg_update_status_tugas
        Function: update_status_tugas_on_log()
    end note
else tahapan = 'Finished'
    DB -> DB : UPDATE tugas_header SET status_tugas = 'Selesai'
end

DB --> LOG_HOOK : success
deactivate DB

LOG_HOOK -> LOG_HOOK : queryClient.invalidateQueries
note right
    Invalidated:
    - ['tugas', 'detail', id]
    - ['tugas', 'list']
    - ['tugas', 'logs', id]
end note

LOG_HOOK --> PETUGAS : Success + refresh
deactivate LOG_HOOK

deactivate PETUGAS

@enduml
```

## Mermaid.js

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

    PETUGAS->>+DETAIL : Akses /tugas/:id
    DETAIL-->>-PETUGAS : Tampilkan detail

    PETUGAS->>+LOG_FORM : Klik "Isi Laporan"

    rect rgb(255, 249, 240)
        Note over PETUGAS,STORAGE : Upload Foto
        loop Untuk setiap foto (1-3)
            PETUGAS->>+UPLOADER : Pilih file
            UPLOADER->>+COMPRESS : compressImage()
            COMPRESS-->>-UPLOADER : compressedBlob
            UPLOADER->>+STORAGE : Upload ke bucket
            STORAGE-->>-UPLOADER : url_foto
        end
        UPLOADER-->>-LOG_FORM : Array<url_foto>
    end

    rect rgb(240, 249, 255)
        Note over LOG_FORM : GPS Location
        PETUGAS->>+LOG_FORM : Aktifkan GPS
        LOG_FORM->>LOG_FORM : getCurrentPosition()
        alt GPS Tersedia
            LOG_FORM-->>LOG_FORM : {lat, lng}
        else GPS Error
            LOG_FORM-->>-PETUGAS : Error
        end
    end

    PETUGAS->>+LOG_FORM : Pilih tahapan + deskripsi + Submit

    LOG_FORM->>+LOG_HOOK : mutate(logData)

    rect rgb(255, 240, 245)
        Note over LOG_HOOK,DB : Insert + Auto-Update
        LOG_HOOK->>+DB : INSERT INTO tugas_log

        alt Tahapan IN (Before, Ongoing)
            DB->>DB : UPDATE status = 'Proses'
        else Finished
            DB->>DB : UPDATE status = 'Selesai'
        end
        DB-->>-LOG_HOOK : success
    end

    LOG_HOOK->>LOG_HOOK : Invalidate queries
    LOG_HOOK-->>-PETUGAS : Success

    deactivate PETUGAS
```

## Deskripsi Alur

| Step | Aksi | Komponen |
|------|------|----------|
| 1 | Petugas akses detail tugas | TugasDetailPage |
| 2 | Klik tombol "Isi Laporan" | Form modal |
| 3 | Pilih 1-3 foto bukti | ImageUploader |
| 4 | Kompres & upload ke Supabase Storage | browser-image-compression, SupabaseStorage |
| 5 | Aktifkan GPS atau pilih di map | Geolocation API |
| 6 | Pilih tahapan (Before/Ongoing/Finished) | Form |
| 7 | Isi deskripsi pekerjaan | Form |
| 8 | Submit log | useSubmitTugasLog |
| 9 | Insert ke database + auto-trigger | SupabaseDB |
| 10 | Invalidate cache + refresh | TanStack Query |

## Validasi Checklist

| Field | Rule |
|-------|------|
| foto | Min 1, Max 3 per log |
| format_foto | JPG, PNG, WebP |
| ukuran_foto | Max 5MB (setelah compress: 0.5MB) |
| gps | Wajib (latitude, longitude) |
| tahapan | Enum: Before, Ongoing, Finished |

## Auto-Trigger

| Tahapan Submit | Status Update |
|---------------|---------------|
| Before | status_tugas = 'Proses' |
| Ongoing | status_tugas = 'Proses' |
| Finished | status_tugas = 'Selesai' |

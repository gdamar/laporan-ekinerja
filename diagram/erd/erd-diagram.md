# Entity-Relationship Diagram (ERD)
# Sistem E-Kinerja

```plantuml
@startuml
!theme plain
skinparam shadowing false
skinparam roundcorner 8
skinparam defaultFontName sans-serif
skinparam defaultFontColor #0F172A
skinparam backgroundColor #F8FAFC
skinparam ArrowColor #475569

skinparam class {
    BackgroundColor #FFFFFF
    BorderColor #64748B
    HeaderBackgroundColor #F1F5F9
}

' ============= ENUMS =============
class roles <<enumeration>> {
    .. Enumeration ..
    'L', 'P'
    'Before', 'Ongoing', 'Finished'
    'Menunggu', 'Proses', 'Selesai'
    'Tahunan', 'Sakit', 'Alasan Penting'
    'Menunggu', 'Disetujui', 'Ditangguhkan', 'Tidak Disetujui'
}

' ============= ENTITIES =============

entity "roles" as ROLES {
    * id : INTEGER <<PK>>
    --
    * nama_role : VARCHAR(50)
    * role_code : VARCHAR(50)
    * created_at : TIMESTAMPTZ
}

entity "master_petugas" as PETUGAS {
    * id : UUID <<PK>>
    --
    * id_phl : VARCHAR(50)
    * nama_phl : VARCHAR(255)
    * jenis_kelamin : jenis_kelamin
    * nik : VARCHAR(16)
    * alamat : TEXT
    * no_telp : VARCHAR(20)
    * email : VARCHAR(255)
    * password_hash : VARCHAR(255)
    * role_id : INTEGER <<FK>>
    * status_aktif : BOOLEAN
    * supabase_auth_id : UUID
    * created_at : TIMESTAMPTZ
    * updated_at : TIMESTAMPTZ
}

entity "tugas_header" as TUGAS_HEADER {
    * id : UUID <<PK>>
    --
    * id_petugas : UUID <<FK>>
    * judul_tugas : VARCHAR(255)
    * alamat : VARCHAR(500)
    * tanggal_tugas : DATE
    * status_tugas : status_tugas
    * created_at : TIMESTAMPTZ
    * updated_at : TIMESTAMPTZ
}

entity "tugas_log" as TUGAS_LOG {
    * id : UUID <<PK>>
    --
    * id_tugas : UUID <<FK>>
    * tahapan : tahapan_tugas
    * latitude : DECIMAL(10,8)
    * longitude : DECIMAL(11,8)
    * deskripsi : TEXT
    * url_foto : JSONB
    * created_at : TIMESTAMPTZ
}

entity "tugas_petugas" as TUGAS_PETUGAS {
    * id : UUID <<PK>>
    --
    * id_tugas : UUID <<FK>>
    * id_petugas : UUID <<FK>>
    * created_at : TIMESTAMPTZ
}

entity "cuti" as CUTI {
    * id : UUID <<PK>>
    --
    * id_petugas : UUID <<FK>>
    * jenis_cuti : jenis_cuti
    * tgl_mulai : DATE
    * tgl_selesai : DATE
    * alasan : TEXT
    * lampiran_url : VARCHAR(500)
    * status_approval : status_approval
    * approved_by : UUID <<FK>>
    * created_at : TIMESTAMPTZ
    * updated_at : TIMESTAMPTZ
}

entity "penilaian" as PENILAIAN {
    * id : UUID <<PK>>
    --
    * id_petugas : UUID <<FK>>
    * id_operator : UUID <<FK>>
    * periode_bulan : INTEGER
    * periode_tahun : INTEGER
    * skor_displin_kehadiran : DECIMAL(5,2)
    * skor_tanggung_jawab : DECIMAL(5,2)
    * skor_kepatuhan : DECIMAL(5,2)
    * total_nilai : DECIMAL(5,2) <<GENERATED>>
    * catatan : TEXT
    * created_at : TIMESTAMPTZ
}

' ============= RELATIONSHIPS =============

' Role has many Petugas (1:N)
ROLES ||--o{ PETUGAS : "has"

' Petugas creates Tasks (1:N)
PETUGAS ||--o{ TUGAS_HEADER : "creates"

' Task has many Logs (1:N)
TUGAS_HEADER ||--o{ TUGAS_LOG : "contains"

' Task assigned to many Petugas via Junction (1:N via junction)
TUGAS_HEADER ||--o{ TUGAS_PETUGAS : "assigned"
PETUGAS ||--o{ TUGAS_PETUGAS : "assigned_to"

' Petugas requests Cuti (1:N)
PETUGAS ||--o{ CUTI : "requests"

' Petugas approves Cuti (0:N)
PETUGAS ||--o{ CUTI : "approves"

' Petugas receives Penilaian (1:N)
PETUGAS ||--o{ PENILAIAN : "received"

' Operator creates Penilaian (1:N)
PETUGAS ||--o{ PENILAIAN : "created_by"

' ============= CONSTRAINTS & NOTES =============

note right of PENILAIAN
    UNIQUE constraint:
    (id_petugas, id_operator,
    periode_bulan, periode_tahun)
    total_nilai = AVG(skor_1, skor_2, skor_3)
end note

note right of CUTI
    CHECK constraint:
    tgl_selesai >= tgl_mulai
    Kuota Cuti Tahunan: 12 hari/tahun
end note

note right of TUGAS_LOG
    CHECK constraint:
    array_length(url_foto) BETWEEN 1 AND 3
    GPS coordinates are required
end note

note bottom of TUGAS_PETUGAS
    Junction table for
    multi-petugas task assignment
    UNIQUE: (id_tugas, id_petugas)
end note

@enduml
```

## Legenda

| Simbol | Arti |
|--------|------|
| `<<PK>>` | Primary Key |
| `<<FK>>` | Foreign Key |
| `<<enumeration>>` | Enum Type |
| `<<GENERATED>>` | Auto-generated Column |
| `||--o{` | One-to-Many (crow's foot) |
| `||--||` | One-to-One |

## Enum Types

| Enum Name | Values |
|-----------|--------|
| `jenis_kelamin` | 'L', 'P' |
| `tahapan_tugas` | 'Before', 'Ongoing', 'Finished' |
| `status_tugas` | 'Menunggu', 'Proses', 'Selesai' |
| `jenis_cuti` | 'Tahunan', 'Sakit', 'Alasan Penting' |
| `status_approval` | 'Menunggu', 'Disetujui', 'Ditangguhkan', 'Tidak Disetujui' |

## Constraints Penting

1. **Kuota Cuti**: 12 hari/tahun untuk jenis 'Tahunan'
2. **Foto Tugas**: Minimal 1, maksimal 3 foto per log
3. **GPS**: Wajib untuk setiap submit log tugas
4. **Penilaian Unik**: Kombinasi (id_petugas, id_operator, periode_bulan, periode_tahun) harus unik

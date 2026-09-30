# Sequence Diagram - Login
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

title Sequence Diagram - Login

actor ":Petugas" as PETUGAS
participant ":LoginPage" as LOGIN
participant ":AuthContext" as AUTH
participant ":SupabaseAuth" as SUPA_AUTH
participant ":SupabaseDB" as SUPA_DB

PETUGAS -> LOGIN : Mengakses /login
activate PETUGAS
activate LOGIN
LOGIN -> AUTH : signIn(email, password)
deactivate LOGIN

AUTH -> SUPA_AUTH : signIn(email, password)
activate SUPA_AUTH

alt Autentikasi Berhasil
    SUPA_AUTH --> AUTH : session {user, token}
    deactivate SUPA_AUTH

    AUTH -> SUPA_DB : SELECT master_petugas WHERE email = email
    activate SUPA_DB
    SUPA_DB --> AUTH : profile record
    deactivate SUPA_DB

    AUTH --> PETUGAS : Login berhasil, navigate /dashboard
    deactivate AUTH

else Autentikasi Gagal
    SUPA_AUTH --> AUTH : error {message}
    deactivate SUPA_AUTH
    AUTH --> PETUGAS : Tampilkan error message
    deactivate AUTH
end

deactivate PETUGAS

@enduml
```

## Mermaid.js

```mermaid
sequenceDiagram
    autonumber
    title Sequence Diagram - Login

    actor PETUGAS as :Petugas
    participant LOGIN as :LoginPage
    participant AUTH as :AuthContext
    participant SUPA_AUTH as :SupabaseAuth
    participant SUPA_DB as :SupabaseDB

    PETUGAS->>+LOGIN : Mengakses /login

    LOGIN->>+AUTH : signIn(email, password)
    AUTH->>+SUPA_AUTH : signIn(email, password)

    alt Autentikasi Berhasil
        SUPA_AUTH-->>-AUTH : session {user, token}
        AUTH->>+SUPA_DB : SELECT master_petugas
        SUPA_DB-->>-AUTH : profile record
        AUTH-->>-PETUGAS : Login berhasil, navigate /dashboard
    else Autentikasi Gagal
        SUPA_AUTH-->>-AUTH : error {message}
        AUTH-->>-PETUGAS : Tampilkan error
    end

    deactivate PETUGAS
```

## Deskripsi Alur

| Step | Aksi | Komponen |
|------|------|----------|
| 1 | User mengakses halaman login | LoginPage |
| 2 | Submit form email & password | LoginPage |
| 3 | Panggil signIn dari Supabase Auth | AuthContext |
| 4 | Supabase validasi kredensial | SupabaseAuth |
| 5 | Jika berhasil, fetch profile dari database | SupabaseDB |
| 6 | Set session & profile ke AuthContext | AuthContext |
| 7 | Redirect ke dashboard | - |

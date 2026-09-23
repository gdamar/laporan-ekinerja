# Diagram Alur Metode RAD

```plantuml
@startuml
skinparam backgroundColor transparent
skinparam defaultFontColor black
skinparam activityBackgroundColor transparent
skinparam activityBorderColor black
skinparam activityFontColor black
skinparam activityDiamondBackgroundColor transparent
skinparam activityDiamondBorderColor black
skinparam activityDiamondFontColor black
skinparam activityArrowColor black
skinparam partitionBackgroundColor transparent
skinparam partitionBorderColor black
skinparam partitionFontColor black

start

:Identifikasi
Masalah;
:Studi Literatur;

partition "Melaksanakan Metode RAD" {
  :Menentukan
  Persyaratan
  Proyek;
  :Prototipe;

  repeat
    :Konstruksi Cepat
    & Pengumpulan
    Feedback;
  repeat while (Disetujui?) is (Tidak)

  :Finalisasi Produk
  /Implementasi;
}

:Kesimpulan;
:Saran;

stop
@enduml


```

# Diagram Alur Penelitian Modified

```plantuml
@startuml
skinparam backgroundColor transparent
skinparam defaultFontColor black
skinparam activityBackgroundColor transparent
skinparam activityBorderColor black
skinparam activityFontColor black
skinparam activityDiamondBackgroundColor transparent
skinparam activityDiamondBorderColor black
skinparam activityDiamondFontColor black
skinparam activityArrowColor black
skinparam partitionBackgroundColor transparent
skinparam partitionBorderColor black
skinparam partitionFontColor black

start

  :Menentukan
  Persyaratan
  Proyek;
  :Prototipe;

  repeat
    :Konstruksi Cepat
    & Pengumpulan
    Feedback;
  repeat while (Disetujui?) is (Tidak)

  :Finalisasi Produk
  /Implementasi;

stop
@enduml

```

# Diagram Alur Penelitian Modified - Mermaid

```mermaid
%%{init: {"flowchart": {"curve": "step"}}}%%
flowchart TD
    start([Mulai]) --> identification["Identifikasi<br/>Masalah"]
    identification --> literature["Studi Literatur"]
    literature --> requirements

    subgraph rad["Melaksanakan Metode RAD"]
        requirements["Menentukan<br/>Persyaratan<br/>Proyek"] --> prototype["Prototipe"]
        prototype --> construction["Konstruksi Cepat<br/>& Pengumpulan<br/>Feedback"]
        construction --> approved{"Disetujui?"}
        approved -- "Tidak" --> construction
        approved -- "Ya" --> finalization["Finalisasi Produk<br/>/Implementasi"]
    end

    finalization --> conclusion["Kesimpulan"]
    conclusion --> suggestion["Saran"]
    suggestion --> stop([Selesai])

    style start fill:transparent,stroke:#000,color:#000
    style identification fill:transparent,stroke:#000,color:#000
    style literature fill:transparent,stroke:#000,color:#000
    style requirements fill:transparent,stroke:#000,color:#000
    style prototype fill:transparent,stroke:#000,color:#000
    style construction fill:transparent,stroke:#000,color:#000
    style approved fill:transparent,stroke:#000,color:#000
    style finalization fill:transparent,stroke:#000,color:#000
    style conclusion fill:transparent,stroke:#000,color:#000
    style suggestion fill:transparent,stroke:#000,color:#000
    style stop fill:transparent,stroke:#000,color:#000
    style rad fill:transparent,stroke:#000,color:#000
    linkStyle default stroke:#000,color:#000
```

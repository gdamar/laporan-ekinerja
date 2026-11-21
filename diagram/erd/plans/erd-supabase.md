## Table `roles`

### Columns

| Name         | Type          | Constraints |
| ------------ | ------------- | ----------- |
| `id`         | `int4`        | Primary     |
| `nama_role`  | `varchar`     | Unique      |
| `created_at` | `timestamptz` | Nullable    |

## Table `master_petugas`

### Columns

| Name               | Type            | Constraints     |
| ------------------ | --------------- | --------------- |
| `id`               | `uuid`          | Primary         |
| `id_phl`           | `varchar`       | Unique          |
| `nama_phl`         | `varchar`       |                 |
| `jenis_kelamin`    | `jenis_kelamin` |                 |
| `nik`              | `varchar`       |                 |
| `alamat`           | `text`          | Nullable        |
| `no_telp`          | `varchar`       | Nullable        |
| `email`            | `varchar`       | Nullable Unique |
| `password_hash`    | `varchar`       | Nullable        |
| `role_id`          | `int4`          |                 |
| `status_aktif`     | `bool`          | Nullable        |
| `created_at`       | `timestamptz`   | Nullable        |
| `updated_at`       | `timestamptz`   | Nullable        |
| `supabase_auth_id` | `uuid`          | Nullable        |

## Table `tugas_header`

### Columns

| Name            | Type           | Constraints |
| --------------- | -------------- | ----------- |
| `id`            | `uuid`         | Primary     |
| `id_petugas`    | `uuid`         |             |
| `judul_tugas`   | `varchar`      |             |
| `alamat`        | `varchar`      | Nullable    |
| `tanggal_tugas` | `date`         |             |
| `status_tugas`  | `status_tugas` | Nullable    |
| `created_at`    | `timestamptz`  | Nullable    |
| `updated_at`    | `timestamptz`  | Nullable    |

## Table `tugas_log`

### Columns

| Name         | Type            | Constraints |
| ------------ | --------------- | ----------- |
| `id`         | `uuid`          | Primary     |
| `id_tugas`   | `uuid`          |             |
| `tahapan`    | `tahapan_tugas` |             |
| `latitude`   | `numeric`       |             |
| `longitude`  | `numeric`       |             |
| `deskripsi`  | `text`          | Nullable    |
| `url_foto`   | `jsonb`         |             |
| `created_at` | `timestamptz`   | Nullable    |
| `id_petugas` | `uuid`          | Nullable    |

## Table `cuti`

### Columns

| Name              | Type              | Constraints |
| ----------------- | ----------------- | ----------- |
| `id`              | `uuid`            | Primary     |
| `id_petugas`      | `uuid`            |             |
| `jenis_cuti`      | `jenis_cuti`      |             |
| `tgl_mulai`       | `date`            |             |
| `tgl_selesai`     | `date`            |             |
| `alasan`          | `text`            | Nullable    |
| `lampiran_url`    | `varchar`         | Nullable    |
| `status_approval` | `status_approval` | Nullable    |
| `approved_by`     | `uuid`            | Nullable    |
| `created_at`      | `timestamptz`     | Nullable    |
| `updated_at`      | `timestamptz`     | Nullable    |

## Table `penilaian`

### Columns

| Name                     | Type          | Constraints |
| ------------------------ | ------------- | ----------- |
| `id`                     | `uuid`        | Primary     |
| `id_petugas`             | `uuid`        |             |
| `id_operator`            | `uuid`        |             |
| `periode_bulan`          | `int4`        |             |
| `periode_tahun`          | `int4`        |             |
| `skor_displin_kehadiran` | `numeric`     |             |
| `skor_tanggung_jawab`    | `numeric`     |             |
| `skor_kepatuhan`         | `numeric`     |             |
| `total_nilai`            | `numeric`     | Nullable    |
| `catatan`                | `text`        | Nullable    |
| `created_at`             | `timestamptz` | Nullable    |

## Table `tugas_petugas`

### Columns

| Name         | Type          | Constraints |
| ------------ | ------------- | ----------- |
| `id`         | `uuid`        | Primary     |
| `id_tugas`   | `uuid`        |             |
| `id_petugas` | `uuid`        |             |
| `created_at` | `timestamptz` | Nullable    |

## Custom Types / Enums

### `jenis_kelamin`

`L` | `P`

### `tahapan_tugas`

`Before` | `Ongoing` | `Finished`

### `status_tugas`

`Menunggu` | `Proses` | `Selesai`

### `jenis_cuti`

`Tahunan` | `Sakit` | `Alasan Penting`

### `status_approval`

`Menunggu` | `Disetujui` | `Ditangguhkan` | `Tidak Disetujui`

## RLS Policies

### `roles`

| Policy              | Command | Roles  | Action     | USING                      | WITH CHECK |
| ------------------- | ------- | ------ | ---------- | -------------------------- | ---------- |
| `roles_public_read` | SELECT  | public | PERMISSIVE | `(auth.uid() IS NOT NULL)` | —          |

### `master_petugas`

| Policy                      | Command | Roles  | Action     | USING                                                                                                                                                                                                     | WITH CHECK |
| --------------------------- | ------- | ------ | ---------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- |
| `master_petugas_select`     | SELECT  | public | PERMISSIVE | `(auth.uid() IS NOT NULL)`                                                                                                                                                                                | —          |
| `master_petugas_update_own` | UPDATE  | public | PERMISSIVE | `(((email)::text = (auth.jwt() ->> 'email'::text)) OR (EXISTS ( SELECT 1    FROM master_petugas mp   WHERE (((mp.email)::text = (auth.jwt() ->> 'email'::text)) AND (mp.role_id = ANY (ARRAY[2, 3]))))))` | —          |

### `tugas_header`

| Policy                        | Command | Roles  | Action     | USING                                                                                                                                                                                                                                                                                                                                                      | WITH CHECK                                                                                                                                          |
| ----------------------------- | ------- | ------ | ---------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| `tugas_header_petugas_update` | UPDATE  | public | PERMISSIVE | `(EXISTS ( SELECT 1    FROM master_petugas mp   WHERE (((mp.email)::text = (auth.jwt() ->> 'email'::text)) AND (((mp.role_id = 1) AND (tugas_header.id_petugas = mp.id)) OR (mp.role_id = ANY (ARRAY[2, 3]))))))`                                                                                                                                          | —                                                                                                                                                   |
| `tugas_header_staff_read`     | SELECT  | public | PERMISSIVE | `(EXISTS ( SELECT 1    FROM master_petugas mp   WHERE (((mp.email)::text = (auth.jwt() ->> 'email'::text)) AND (mp.role_id = ANY (ARRAY[2, 3])))))`                                                                                                                                                                                                        | —                                                                                                                                                   |
| `tugas_header_kepala_create`  | INSERT  | public | PERMISSIVE | —                                                                                                                                                                                                                                                                                                                                                          | `(EXISTS ( SELECT 1    FROM master_petugas mp   WHERE (((mp.email)::text = (auth.jwt() ->> 'email'::text)) AND (mp.role_id = ANY (ARRAY[2, 3])))))` |
| `tugas_header_petugas_read`   | SELECT  | public | PERMISSIVE | `(EXISTS ( SELECT 1    FROM master_petugas mp   WHERE (((mp.email)::text = (auth.jwt() ->> 'email'::text)) AND (((mp.role_id = 1) AND ((tugas_header.id_petugas = mp.id) OR (EXISTS ( SELECT 1            FROM tugas_petugas tp           WHERE ((tp.id_tugas = tugas_header.id) AND (tp.id_petugas = mp.id)))))) OR (mp.role_id = ANY (ARRAY[2, 3]))))))` | —                                                                                                                                                   |

### `tugas_log`

| Policy                     | Command | Roles  | Action     | USING                                                                                                                                                                                                    | WITH CHECK                                                                                                                                                                                               |
| -------------------------- | ------- | ------ | ---------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `tugas_log_petugas_insert` | INSERT  | public | PERMISSIVE | —                                                                                                                                                                                                        | `(EXISTS ( SELECT 1    FROM (tugas_header th      JOIN master_petugas mp ON ((th.id_petugas = mp.id)))   WHERE ((th.id = tugas_log.id_tugas) AND ((mp.email)::text = (auth.jwt() ->> 'email'::text)))))` |
| `tugas_log_petugas_read`   | SELECT  | public | PERMISSIVE | `(EXISTS ( SELECT 1    FROM (tugas_header th      JOIN master_petugas mp ON ((th.id_petugas = mp.id)))   WHERE ((th.id = tugas_log.id_tugas) AND ((mp.email)::text = (auth.jwt() ->> 'email'::text)))))` | —                                                                                                                                                                                                        |
| `tugas_log_staff_read`     | SELECT  | public | PERMISSIVE | `(EXISTS ( SELECT 1    FROM master_petugas mp   WHERE (((mp.email)::text = (auth.jwt() ->> 'email'::text)) AND (mp.role_id = ANY (ARRAY[2, 3])))))`                                                      | —                                                                                                                                                                                                        |

### `cuti`

| Policy                 | Command | Roles  | Action     | USING                                                                                                                                               | WITH CHECK                                                                                                                                   |
| ---------------------- | ------- | ------ | ---------- | --------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| `cuti_petugas_insert`  | INSERT  | public | PERMISSIVE | —                                                                                                                                                   | `(EXISTS ( SELECT 1    FROM master_petugas mp   WHERE ((mp.id = cuti.id_petugas) AND ((mp.email)::text = (auth.jwt() ->> 'email'::text)))))` |
| `cuti_petugas_read`    | SELECT  | public | PERMISSIVE | `(EXISTS ( SELECT 1    FROM master_petugas mp   WHERE ((mp.id = cuti.id_petugas) AND ((mp.email)::text = (auth.jwt() ->> 'email'::text)))))`        | —                                                                                                                                            |
| `cuti_operator_read`   | SELECT  | public | PERMISSIVE | `(EXISTS ( SELECT 1    FROM master_petugas mp   WHERE (((mp.email)::text = (auth.jwt() ->> 'email'::text)) AND (mp.role_id = 2))))`                 | —                                                                                                                                            |
| `cuti_kepala_read`     | SELECT  | public | PERMISSIVE | `(EXISTS ( SELECT 1    FROM master_petugas mp   WHERE (((mp.email)::text = (auth.jwt() ->> 'email'::text)) AND (mp.role_id = 3))))`                 | —                                                                                                                                            |
| `cuti_operator_update` | UPDATE  | public | PERMISSIVE | `(EXISTS ( SELECT 1    FROM master_petugas mp   WHERE (((mp.email)::text = (auth.jwt() ->> 'email'::text)) AND (mp.role_id = ANY (ARRAY[2, 3])))))` | —                                                                                                                                            |

### `penilaian`

| Policy                   | Command | Roles  | Action     | USING                                                                                                                                             | WITH CHECK |
| ------------------------ | ------- | ------ | ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- |
| `penilaian_petugas_read` | SELECT  | public | PERMISSIVE | `(EXISTS ( SELECT 1    FROM master_petugas mp   WHERE ((mp.id = penilaian.id_petugas) AND ((mp.email)::text = (auth.jwt() ->> 'email'::text)))))` | —          |
| `penilaian_operator_all` | ALL     | public | PERMISSIVE | `(EXISTS ( SELECT 1    FROM master_petugas mp   WHERE (((mp.email)::text = (auth.jwt() ->> 'email'::text)) AND (mp.role_id = 2))))`               | —          |
| `penilaian_kepala_read`  | SELECT  | public | PERMISSIVE | `(EXISTS ( SELECT 1    FROM master_petugas mp   WHERE (((mp.email)::text = (auth.jwt() ->> 'email'::text)) AND (mp.role_id = 3))))`               | —          |

### `tugas_petugas`

| Policy                        | Command | Roles  | Action     | USING                                                                                                                                                                                                              | WITH CHECK                                                                                                                                          |
| ----------------------------- | ------- | ------ | ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| `tugas_petugas_staff_read`    | SELECT  | public | PERMISSIVE | `(EXISTS ( SELECT 1    FROM master_petugas mp   WHERE (((mp.email)::text = (auth.jwt() ->> 'email'::text)) AND (mp.role_id = ANY (ARRAY[2, 3])))))`                                                                | —                                                                                                                                                   |
| `tugas_petugas_staff_insert`  | INSERT  | public | PERMISSIVE | —                                                                                                                                                                                                                  | `(EXISTS ( SELECT 1    FROM master_petugas mp   WHERE (((mp.email)::text = (auth.jwt() ->> 'email'::text)) AND (mp.role_id = ANY (ARRAY[2, 3])))))` |
| `tugas_petugas_kepala_insert` | INSERT  | public | PERMISSIVE | —                                                                                                                                                                                                                  | `(EXISTS ( SELECT 1    FROM master_petugas mp   WHERE (((mp.email)::text = (auth.jwt() ->> 'email'::text)) AND (mp.role_id = 3))))`                 |
| `tugas_petugas_kepala_delete` | DELETE  | public | PERMISSIVE | `(EXISTS ( SELECT 1    FROM master_petugas mp   WHERE (((mp.email)::text = (auth.jwt() ->> 'email'::text)) AND (mp.role_id = 3))))`                                                                                | —                                                                                                                                                   |
| `tugas_petugas_petugas_read`  | SELECT  | public | PERMISSIVE | `(EXISTS ( SELECT 1    FROM master_petugas mp   WHERE (((mp.email)::text = (auth.jwt() ->> 'email'::text)) AND (((mp.role_id = 1) AND (tugas_petugas.id_petugas = mp.id)) OR (mp.role_id = ANY (ARRAY[2, 3]))))))` | —                                                                                                                                                   |

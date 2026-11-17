-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.roles (
  id integer NOT NULL DEFAULT nextval('roles_id_seq'::regclass),
  nama_role character varying NOT NULL UNIQUE,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT roles_pkey PRIMARY KEY (id)
);
CREATE TABLE public.master_petugas (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  id_phl character varying NOT NULL UNIQUE,
  nama_phl character varying NOT NULL,
  jenis_kelamin USER-DEFINED NOT NULL,
  nik character varying NOT NULL,
  alamat text,
  no_telp character varying,
  email character varying UNIQUE,
  password_hash character varying,
  role_id integer NOT NULL,
  status_aktif boolean DEFAULT true,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  supabase_auth_id uuid,
  CONSTRAINT master_petugas_pkey PRIMARY KEY (id),
  CONSTRAINT master_petugas_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id)
);
CREATE TABLE public.tugas_header (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  id_petugas uuid NOT NULL,
  judul_tugas character varying NOT NULL,
  alamat character varying,
  tanggal_tugas date NOT NULL DEFAULT CURRENT_DATE,
  status_tugas USER-DEFINED DEFAULT 'Menunggu'::status_tugas,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT tugas_header_pkey PRIMARY KEY (id),
  CONSTRAINT tugas_header_id_petugas_fkey FOREIGN KEY (id_petugas) REFERENCES public.master_petugas(id)
);
CREATE TABLE public.tugas_log (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  id_tugas uuid NOT NULL,
  tahapan USER-DEFINED NOT NULL,
  latitude numeric NOT NULL,
  longitude numeric NOT NULL,
  deskripsi text,
  url_foto jsonb NOT NULL CHECK (jsonb_array_length(url_foto) >= 1 AND jsonb_array_length(url_foto) <= 3),
  created_at timestamp with time zone DEFAULT now(),
  id_petugas uuid,
  CONSTRAINT tugas_log_pkey PRIMARY KEY (id),
  CONSTRAINT tugas_log_id_tugas_fkey FOREIGN KEY (id_tugas) REFERENCES public.tugas_header(id),
  CONSTRAINT tugas_log_id_petugas_fkey FOREIGN KEY (id_petugas) REFERENCES public.master_petugas(id)
);
CREATE TABLE public.cuti (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  id_petugas uuid NOT NULL,
  jenis_cuti USER-DEFINED NOT NULL,
  tgl_mulai date NOT NULL,
  tgl_selesai date NOT NULL,
  alasan text,
  lampiran_url character varying,
  status_approval USER-DEFINED DEFAULT 'Menunggu'::status_approval,
  approved_by uuid,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT cuti_pkey PRIMARY KEY (id),
  CONSTRAINT cuti_id_petugas_fkey FOREIGN KEY (id_petugas) REFERENCES public.master_petugas(id),
  CONSTRAINT cuti_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.master_petugas(id)
);
CREATE TABLE public.penilaian (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  id_petugas uuid NOT NULL,
  id_operator uuid NOT NULL,
  periode_bulan integer NOT NULL CHECK (periode_bulan >= 1 AND periode_bulan <= 12),
  periode_tahun integer NOT NULL,
  skor_displin_kehadiran numeric NOT NULL CHECK (skor_displin_kehadiran >= 0::numeric AND skor_displin_kehadiran <= 100::numeric),
  skor_tanggung_jawab numeric NOT NULL CHECK (skor_tanggung_jawab >= 0::numeric AND skor_tanggung_jawab <= 100::numeric),
  skor_kepatuhan numeric NOT NULL CHECK (skor_kepatuhan >= 0::numeric AND skor_kepatuhan <= 100::numeric),
  total_nilai numeric DEFAULT (((skor_displin_kehadiran + skor_tanggung_jawab) + skor_kepatuhan) / 3.0),
  catatan text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT penilaian_pkey PRIMARY KEY (id),
  CONSTRAINT penilaian_id_petugas_fkey FOREIGN KEY (id_petugas) REFERENCES public.master_petugas(id),
  CONSTRAINT penilaian_id_operator_fkey FOREIGN KEY (id_operator) REFERENCES public.master_petugas(id)
);
CREATE TABLE public.tugas_petugas (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  id_tugas uuid NOT NULL,
  id_petugas uuid NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT tugas_petugas_pkey PRIMARY KEY (id),
  CONSTRAINT tugas_petugas_id_tugas_fkey FOREIGN KEY (id_tugas) REFERENCES public.tugas_header(id),
  CONSTRAINT tugas_petugas_id_petugas_fkey FOREIGN KEY (id_petugas) REFERENCES public.master_petugas(id)
);

-- Table: public.gas_agency

-- DROP TABLE IF EXISTS public.gas_agency;

CREATE TABLE IF NOT EXISTS public.gas_agency
(
    agency_id integer NOT NULL,
    agency_name text COLLATE pg_catalog."default" NOT NULL,
    agency_adress text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT gas_agency_pkey PRIMARY KEY (agency_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.gas_agency
    OWNER to grikos;
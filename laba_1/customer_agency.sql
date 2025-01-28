-- Table: public.customer_agency

-- DROP TABLE IF EXISTS public.customer_agency;

CREATE TABLE IF NOT EXISTS public.customer_agency
(
    customer_id integer NOT NULL,
    agency_id integer NOT NULL,
    CONSTRAINT customer_author_pkey PRIMARY KEY (customer_id, agency_id),
    CONSTRAINT customer_agency_agency_id_fkey FOREIGN KEY (agency_id)
        REFERENCES public.gas_agency (agency_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT customer_agency_customer_id_fkey FOREIGN KEY (customer_id)
        REFERENCES public.customer (customer_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.customer_agency
    OWNER to grikos;
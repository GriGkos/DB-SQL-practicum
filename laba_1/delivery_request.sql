-- Table: public.delivery_request

-- DROP TABLE IF EXISTS public.delivery_request;

CREATE TABLE IF NOT EXISTS public.delivery_request
(
    request_id integer NOT NULL,
    customer_id integer NOT NULL,
    destination_city text COLLATE pg_catalog."default" NOT NULL,
    product_quantity numeric NOT NULL,
    delivery_cost numeric NOT NULL,
    agency_id integer NOT NULL,
    CONSTRAINT delivery_request_pkey PRIMARY KEY (request_id),
    CONSTRAINT fk_agency_id FOREIGN KEY (agency_id)
        REFERENCES public.gas_agency (agency_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_customer_id FOREIGN KEY (customer_id)
        REFERENCES public.customer (customer_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.delivery_request
    OWNER to grikos;
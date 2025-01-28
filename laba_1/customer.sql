-- Table: public.customer

-- DROP TABLE IF EXISTS public.customer;

CREATE TABLE IF NOT EXISTS public.customer
(
    customer_id integer NOT NULL,
    customer_name text COLLATE pg_catalog."default" NOT NULL,
    customer_phone integer NOT NULL,
    customer_adress text COLLATE pg_catalog."default" NOT NULL,
    payment_id integer NOT NULL,
    notification_id integer NOT NULL,
    CONSTRAINT customer_pkey PRIMARY KEY (customer_id),
    CONSTRAINT fk_notification_id FOREIGN KEY (notification_id)
        REFERENCES public.notification (notification_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT fk_payment_id FOREIGN KEY (payment_id)
        REFERENCES public.payment (payment_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.customer
    OWNER to grikos;
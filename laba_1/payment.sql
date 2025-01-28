-- Table: public.payment

-- DROP TABLE IF EXISTS public.payment;

CREATE TABLE IF NOT EXISTS public.payment
(
    payment_id integer NOT NULL,
    payment_amount numeric NOT NULL,
    payment_data timestamp with time zone NOT NULL,
    CONSTRAINT payment_pkey PRIMARY KEY (payment_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.payment
    OWNER to grikos;
-- Table: public.feedback

-- DROP TABLE IF EXISTS public.feedback;

CREATE TABLE IF NOT EXISTS public.feedback
(
    feedback_id integer NOT NULL,
    message text COLLATE pg_catalog."default" NOT NULL,
    feedback_date timestamp with time zone NOT NULL,
    customer_id integer NOT NULL,
    CONSTRAINT feedback_pkey PRIMARY KEY (feedback_id),
    CONSTRAINT fk_customer_id FOREIGN KEY (customer_id)
        REFERENCES public.customer (customer_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.feedback
    OWNER to grikos;
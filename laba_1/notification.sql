-- Table: public.notification

-- DROP TABLE IF EXISTS public.notification;

CREATE TABLE IF NOT EXISTS public.notification
(
    notification_id integer NOT NULL,
    booking_status text COLLATE pg_catalog."default" NOT NULL,
    delivery_status text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT notification_pkey PRIMARY KEY (notification_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.notification
    OWNER to grikos;
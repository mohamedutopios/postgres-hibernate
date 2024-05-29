CREATE TABLE public.appellation (
    id integer NOT NULL,
    libelle text NOT NULL,
    region_id integer
)
WITH (autovacuum_enabled=off);


CREATE TABLE public.contenant (
    id integer NOT NULL,
    contenance real NOT NULL,
    libelle text
)
WITH (autovacuum_enabled=off);


CREATE TABLE public.stock (
    vin_id integer NOT NULL,
    contenant_id integer NOT NULL,
    annee integer NOT NULL,
    nombre integer NOT NULL
)
WITH (autovacuum_enabled=off);


CREATE TABLE public.region (
    id integer NOT NULL,
    libelle text NOT NULL
)
WITH (autovacuum_enabled=off);


CREATE TABLE public.recoltant (
    id integer NOT NULL,
    nom text,
    adresse text
)
WITH (autovacuum_enabled=off);


CREATE TABLE public.type_vin (
    id integer NOT NULL,
    libelle text NOT NULL
)
WITH (autovacuum_enabled=off);


CREATE TABLE public.vin (
    id integer NOT NULL,
    recoltant_id integer,
    appellation_id integer NOT NULL,
    type_vin_id integer NOT NULL
)
WITH (autovacuum_enabled=off);

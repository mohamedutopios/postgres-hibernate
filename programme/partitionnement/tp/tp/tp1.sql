
-- Créer la table partitionnée stock
CREATE TABLE stock_test (
    vin_id integer NOT NULL,
    contenant_id integer NOT NULL,
    annee integer NOT NULL,
    nombre integer NOT NULL
)
PARTITION BY RANGE (annee);

-- Créer les partitions de stock
CREATE TABLE stock_1996 PARTITION OF stock_test
    FOR VALUES FROM (1996) TO (1997);

CREATE TABLE stock_1997 PARTITION OF stock_test
    FOR VALUES FROM (1997) TO (1998);

CREATE TABLE stock_1998 PARTITION OF stock_test
    FOR VALUES FROM (1998) TO (1999);

CREATE TABLE stock_1999 PARTITION OF stock_test
    FOR VALUES FROM (1999) TO (2000);

CREATE TABLE stock_2000 PARTITION OF stock_test
    FOR VALUES FROM (2000) TO (2001);


CREATE TABLE stock_default PARTITION OF stock_test DEFAULT;


-- Insérer les enregistrements de stock_old dans la nouvelle table partitionnée stock
INSERT INTO stock_test (vin_id, contenant_id, annee, nombre)
SELECT vin_id, contenant_id, annee, nombre FROM stock_old;

-- Vérifier la présence d’enregistrements dans stock_1999
SELECT * FROM stock_1999;

-- Vérifier qu’il n’y a aucun enregistrement dans la table parent stock
SELECT * FROM ONLY stock_test;

-- Vérifier qu’une requête sur stock pour l'année 1999 ne parcourt qu’une seule partition
EXPLAIN ANALYZE
SELECT * FROM stock_test WHERE annee = 1999;

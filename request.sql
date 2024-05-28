--first table test
CREATE TABLE test (
    id int primary key,
    nombre int
);
--INSERTION
INSERT INTO test (id, nombre) (
    SELECT i,i FROM generate_series(1, 1000000) as i);

CREATE INDEX idx_test_nombre ON test(nombre);

--second table
CREATE TABLE test_texte (
    id int primary key,
    nombre int,
    texte text
);

--INSERTION
EXPLAIN ANALYSE INSERT INTO test_texte (id, nombre, texte) (
    SELECT i,i, 'data for test_text' FROM generate_series(1000000, 1000000) as i);

-- CREATION d'un index sur le nombre
CREATE INDEX idx_test_texte_nombre ON test_texte(nombre);
CREATE INDEX idx_test_texte_nombre ON test_texte(texte);

--CREATION d'un index multi-colonne
CREATE INDEX idx_test_texte_nombre_text ON test_texte(nombre, texte);

SELECT * FROM test_texte WHERE nombre = 10000 AND texte = "data for test_text";

SELECT * FROM test_texte WHERE texte = "data for test_text";
SELECT * FROM test_texte WHERE nombre = 10000::numeric;

SELECT * FROM ma_table where to_char(col_date, 'YYYY') = '2014'

--CREATION INDEX => fonctionnel
CREATE INDEX test_fonction ON test(fonction(col))

--Creation INDEX couvrant
CREATE INDEX idx_test_nombre_couvrant ON test_texte(nombre) INCLUDE(texte);


--Request TP

EXPLAIN (ANALYZE, BUFFERS) SELECT * FROM commandes WHERE date_commande >= '2014-01-01' AND date_commande < '2014-02-01' ORDER By date_commande;

--INDEX SIMPLE 
CREATE INDEX idx_commandes_date_commande ON commandes(date_commande);

--JOIN
EXPLAIN (ANALYZE, BUFFERS) SELECT * FROM commandes
      INNER JOIN clients ON commandes.client_id = clients.client_id
    WHERE clients.client_id = 3;

--INDEX
CREATE INDEX ON commandes (client_id) ;

SELECT * FROM clients WHERE type_client = 'P';
SELECT * FROM clients WHERE type_client = 'E';

CREATE INDEX ON clients (type_client) INCLUDE();

EXPLAIN ANALYSE SELECT * FROM lots
    WHERE date_expedition IS NULL
    AND date_depot < now() - '12h'::interval ;

CREATE INDEX ON lots(date_depot) WHERE date_expedition IS NULL;

SELECT * FROM lots
    WHERE date_reception IS NULL
    AND date_expedition < now() - '3d'::interval;
CREATE INDEX ON lots(date_expedition) WHERE date_reception IS NULL;

SELECT * FROM lignes_commandes WHERE numero_lot_expedition = '190774'::numeric;

--Partition par héritage
CREATE TABLE mere(nom text);

CREATE TABle fille(prenom text) INHERITS (mere);


--- CREATION de la table partitionnée
ALTER TABLE stock rename to sock_old;
CREATE TABLE stock(like stock_old) Partition by LIST(annee);
CREATE TABLE stock_2002 PARTITION of stock for values in (2002);
...
INSERT INTO STOCK  select * FROM stock_old;

SELECT * FROM STOCK where annee=2002;

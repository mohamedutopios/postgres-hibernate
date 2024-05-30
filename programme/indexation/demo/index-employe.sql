CREATE TABLE employe (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(50),
    prenom VARCHAR(50),
    date_embauche DATE,
    salaire DECIMAL(10, 2),
    departement_id INTEGER
);


DO $$
BEGIN
    FOR i IN 1..1000000 LOOP
        INSERT INTO employe (nom, prenom, date_embauche, salaire, departement_id)
        VALUES (
            'Nom' || i,
            'Prenom' || i,
            '2020-01-01'::DATE + (i % 365),
            ROUND((RANDOM() * 100000 + 30000)::numeric, 2),
            (i % 10) + 1
        );
    END LOOP;
END $$;


EXPLAIN ANALYZE
SELECT * FROM employe WHERE departement_id = 5;


CREATE INDEX idx_employe_departement_id ON employe (departement_id);


EXPLAIN ANALYZE
SELECT * FROM employe WHERE departement_id = 5;

---- sans index :

Seq Scan on employe  (cost=0.00..21846.00 rows=99833 width=41) (actual time=0.011..156.570 rows=100000 loops=1)
  Filter: (departement_id = 5)
  Rows Removed by Filter: 900000
Planning Time: 0.238 ms
Execution Time: 218.766 ms


--- avec index : 

Bitmap Heap Scan on employe  (cost=1114.13..11708.04 rows=99833 width=41) (actual time=5.810..89.999 rows=100000 loops=1)
  Recheck Cond: (departement_id = 5)
  Heap Blocks: exact=9346
  ->  Bitmap Index Scan on idx_employe_departement_id  (cost=0.00..1089.17 rows=99833 width=0) (actual time=4.275..4.276 rows=100000 loops=1)
        Index Cond: (departement_id = 5)
Planning Time: 0.232 ms
Execution Time: 151.908 ms

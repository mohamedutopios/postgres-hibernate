-- Création de la table ventes sans partitionnement
CREATE TABLE ventes_sans_partition (
    id SERIAL PRIMARY KEY,
    date_vente DATE NOT NULL,
    montant DECIMAL
);


-- Création de la table ventes avec partitionnement par plage
CREATE TABLE ventes (
    id SERIAL,
    date_vente DATE NOT NULL,
    montant DECIMAL,
    PRIMARY KEY (id, date_vente)
) PARTITION BY RANGE (date_vente);

-- Création des partitions
CREATE TABLE ventes_2022 PARTITION OF ventes FOR VALUES FROM ('2022-01-01') TO ('2023-01-01');
CREATE TABLE ventes_2023 PARTITION OF ventes FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

-- Fonction pour générer des dates aléatoires
CREATE OR REPLACE FUNCTION random_date(start_date DATE, end_date DATE) RETURNS DATE AS $$
BEGIN
    RETURN start_date + (random() * (end_date - start_date))::int;
END;
$$ LANGUAGE plpgsql;

-- Insertion des données dans la table sans partitionnement
DO $$
BEGIN
    FOR i IN 1..100000 LOOP
        INSERT INTO ventes_sans_partition (date_vente, montant)
        VALUES (random_date('2022-01-01', '2023-12-31'), round(random() * 100)::numeric);
    END LOOP;
END;
$$;

-- Insertion des données dans la table avec partitionnement
DO $$
BEGIN
    FOR i IN 1..100000 LOOP
        INSERT INTO ventes (date_vente, montant)
        VALUES (random_date('2022-01-01', '2023-12-31'), round(random() * 100)::numeric);
    END LOOP;
END;
$$;


-- Mesure du temps de la requête sans partitionnement
EXPLAIN ANALYZE
SELECT SUM(montant)
FROM ventes_sans_partition
WHERE date_vente BETWEEN '2022-01-01' AND '2022-12-31';

-- Mesure du temps de la requête avec partitionnement
EXPLAIN ANALYZE
SELECT SUM(montant)
FROM ventes
WHERE date_vente BETWEEN '2022-01-01' AND '2022-12-31';


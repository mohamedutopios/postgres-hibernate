
### 1. Création de la Table Parent et des Partitions

#### Création de la Table Parent
```sql
CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    sale_date DATE NOT NULL,
    amount NUMERIC
);
```

#### Création des Tables Enfants avec des Contraintes de Vérification (CHECK)
```sql
CREATE TABLE sales_2023_01 (
    CHECK (sale_date >= DATE '2023-01-01' AND sale_date < DATE '2023-02-01')
) INHERITS (sales);

CREATE TABLE sales_2023_02 (
    CHECK (sale_date >= DATE '2023-02-01' AND sale_date < DATE '2023-03-01')
) INHERITS (sales);

CREATE TABLE sales_2023_03 (
    CHECK (sale_date >= DATE '2023-03-01' AND sale_date < DATE '2023-04-01')
) INHERITS (sales);
```

### 2. Création de la Fonction et du Déclencheur pour Gérer les Insertion

#### Fonction de Répartition des Insertion
```sql
CREATE OR REPLACE FUNCTION insert_sales_partition()
RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.sale_date >= DATE '2023-01-01' AND NEW.sale_date < DATE '2023-02-01') THEN
        INSERT INTO sales_2023_01 VALUES (NEW.*);
    ELSIF (NEW.sale_date >= DATE '2023-02-01' AND NEW.sale_date < DATE '2023-03-01') THEN
        INSERT INTO sales_2023_02 VALUES (NEW.*);
    ELSIF (NEW.sale_date >= DATE '2023-03-01' AND NEW.sale_date < DATE '2023-04-01') THEN
        INSERT INTO sales_2023_03 VALUES (NEW.*);
    ELSE
        RAISE EXCEPTION 'Date out of range. Fix the insert_sales_partition function!';
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;
```

#### Déclencheur Avant Insertion
```sql
CREATE TRIGGER insert_sales_trigger
BEFORE INSERT ON sales
FOR EACH ROW EXECUTE FUNCTION insert_sales_partition();
```

### 3. Génération de Données de Test en Masse

Nous allons générer des données de test en masse et les insérer dans la table partitionnée. Vous pouvez utiliser un script comme celui-ci pour insérer un grand nombre de lignes :

#### Script pour Générer et Insérer des Données
```sql
DO $$
BEGIN
    FOR i IN 1..10000 LOOP
        INSERT INTO sales (sale_date, amount) 
        VALUES (
            DATE '2023-01-01' + (i % 90), -- Cette ligne répartit les dates sur trois mois
            (RANDOM() * 1000)::NUMERIC -- Génère un montant aléatoire entre 0 et 1000
        );
    END LOOP;
END $$;
```

### 4. Vérification et Opérations

#### Sélection de Toutes les Données
```sql
SELECT COUNT(*) FROM sales;
```

#### Sélection par Partition
```sql
SELECT COUNT(*) FROM sales_2023_01;
SELECT COUNT(*) FROM sales_2023_02;
SELECT COUNT(*) FROM sales_2023_03;
```

#### Mise à Jour des Données
```sql
UPDATE sales SET amount = amount * 1.1 WHERE sale_date < '2023-03-01';
```

#### Suppression des Données
```sql
DELETE FROM sales WHERE sale_date < '2023-02-01';
```

### 5. Ajout de Nouvelles Partitions

Pour ajouter une nouvelle partition pour avril 2023 :

```sql
CREATE TABLE sales_2023_04 (
    CHECK (sale_date >= DATE '2023-04-01' AND sale_date < DATE '2023-05-01')
) INHERITS (sales);
```

Mettre à jour la fonction `insert_sales_partition` pour inclure la nouvelle partition :

```sql
CREATE OR REPLACE FUNCTION insert_sales_partition()
RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.sale_date >= DATE '2023-01-01' AND NEW.sale_date < DATE '2023-02-01') THEN
        INSERT INTO sales_2023_01 VALUES (NEW.*);
    ELSIF (NEW.sale_date >= DATE '2023-02-01' AND NEW.sale_date < DATE '2023-03-01') THEN
        INSERT INTO sales_2023_02 VALUES (NEW.*);
    ELSIF (NEW.sale_date >= DATE '2023-03-01' AND NEW.sale_date < DATE '2023-04-01') THEN
        INSERT INTO sales_2023_03 VALUES (NEW.*);
    ELSIF (NEW.sale_date >= DATE '2023-04-01' AND NEW.sale_date < DATE '2023-05-01') THEN
        INSERT INTO sales_2023_04 VALUES (NEW.*);
    ELSE
        RAISE EXCEPTION 'Date out of range. Fix the insert_sales_partition function!';
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;
```

### levée un exception -> 

```sql
INSERT INTO sales (sale_date, amount) VALUES ('2023-05-01',5);
```
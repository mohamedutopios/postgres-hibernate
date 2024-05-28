Pour fournir un exemple complet de l'impact de différents types d'indexation dans PostgreSQL, nous allons explorer trois types principaux d'index : B-tree, multicolonne et partiel. Nous allons voir comment chacun améliore les performances de requêtes spécifiques. Voici un guide détaillé :

### Configuration de la Base de Données

#### Création de la base de données et de la table

```sql
-- Connectez-vous à PostgreSQL et créez une nouvelle base de données
CREATE DATABASE test_db;
\c test_db

-- Création de la table 'orders' avec des données volumineuses
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER,
    order_date DATE,
    amount NUMERIC
);

-- Insertion de données volumineuses
INSERT INTO orders (customer_id, order_date, amount)
SELECT 
    (RANDOM() * 10000)::int,
    NOW() - '1 day'::interval * (RANDOM() * 1000)::int,
    (RANDOM() * 1000)::numeric
FROM generate_series(1, 1000000);
```

### Sans Index

Nous allons d'abord exécuter des requêtes sans index pour avoir une base de comparaison.

```sql
-- Exécution de requête sans index
EXPLAIN ANALYZE 
SELECT * FROM orders WHERE customer_id = 5000;
```

### Index B-tree

Créons un index B-tree sur la colonne `customer_id`.

```sql
-- Création de l'index B-tree
CREATE INDEX idx_customer_id ON orders(customer_id);

-- Exécution de la requête avec index B-tree
EXPLAIN ANALYZE 
SELECT * FROM orders WHERE customer_id = 5000;
```

### Index Multicolonne

Créons un index multicolonne sur les colonnes `customer_id` et `order_date`.

```sql
-- Création de l'index multicolonne
CREATE INDEX idx_customer_order_date ON orders(customer_id, order_date);

-- Exécution de la requête avec index multicolonne
EXPLAIN ANALYZE 
SELECT * FROM orders WHERE customer_id = 5000 AND order_date > '2023-01-01';
```

### Index Partiel

Créons un index partiel sur la colonne `amount` pour les valeurs supérieures à 500.

```sql
-- Création de l'index partiel
CREATE INDEX idx_high_amount_orders ON orders(amount) WHERE amount > 500;

-- Exécution de la requête avec index partiel
EXPLAIN ANALYZE 
SELECT * FROM orders WHERE amount > 500;
```

### Comparaison des Performances

Pour une comparaison claire, nous allons observer les temps d'exécution pour chaque type de requête avec et sans index.

#### Sans Index

```sql
-- Suppression de tous les index existants
DROP INDEX IF EXISTS idx_customer_id;
DROP INDEX IF EXISTS idx_customer_order_date;
DROP INDEX IF EXISTS idx_high_amount_orders;

-- Mesurer le temps d'exécution sans index
\timing
SELECT * FROM orders WHERE customer_id = 5000;
SELECT * FROM orders WHERE customer_id = 5000 AND order_date > '2023-01-01';
SELECT * FROM orders WHERE amount > 500;
\timing
```

#### Avec Index B-tree

```sql
-- Création de l'index B-tree
CREATE INDEX idx_customer_id ON orders(customer_id);

-- Mesurer le temps d'exécution avec index B-tree
\timing
SELECT * FROM orders WHERE customer_id = 5000;
\timing
```

#### Avec Index Multicolonne

```sql
-- Création de l'index multicolonne
CREATE INDEX idx_customer_order_date ON orders(customer_id, order_date);

-- Mesurer le temps d'exécution avec index multicolonne
\timing
SELECT * FROM orders WHERE customer_id = 5000 AND order_date > '2023-01-01';
\timing
```

#### Avec Index Partiel

```sql
-- Création de l'index partiel
CREATE INDEX idx_high_amount_orders ON orders(amount) WHERE amount > 500;

-- Mesurer le temps d'exécution avec index partiel
\timing
SELECT * FROM orders WHERE amount > 500;
\timing
```

### Résultats et Analyse

Vous verrez que les plans d'exécution (obtenus avec `EXPLAIN ANALYZE`) et les temps d'exécution (`\timing`) montrent des différences significatives dans les performances des requêtes :

- **Sans Index** : La requête effectue un balayage séquentiel de toute la table, ce qui est coûteux en termes de temps pour les grandes tables.
- **Index B-tree** : La requête utilisant l'index B-tree est beaucoup plus rapide pour les recherches d'égalité sur `customer_id`.
- **Index Multicolonne** : L'index multicolonne améliore les performances des requêtes utilisant à la fois `customer_id` et `order_date`.
- **Index Partiel** : L'index partiel optimise les requêtes pour les enregistrements où `amount` est supérieur à une certaine valeur, réduisant ainsi le nombre de lignes scannées.

En appliquant ces différents types d'index, vous pouvez optimiser les performances de vos requêtes en fonction de vos besoins spécifiques.
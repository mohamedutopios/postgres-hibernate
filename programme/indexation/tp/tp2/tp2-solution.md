Pour démontrer l'utilisation de différents types d'index dans la base de données Chinook, nous allons utiliser la table `Track` et la table `InvoiceLine`. Nous allons examiner des scénarios courants pour des analyses de données et des recherches, puis optimiser ces scénarios avec différents types d'index.

### Scénario

Vous travaillez comme analyste de données pour un magasin de musique numérique utilisant la base de données Chinook. Vous devez fréquemment exécuter des requêtes complexes impliquant des recherches de pistes par genre et des analyses de ventes par piste. Pour optimiser ces requêtes, vous allez utiliser des index B-tree, des index GIN pour les recherches textuelles, et des index BRIN pour les tables volumineuses.

---

# TP : Utilisation de Différents Types d'Index dans la Base de Données Chinook

## Objectif

Optimiser les performances des requêtes en utilisant différents types d'index : B-tree, GIN, et BRIN.

## 1. Recherche de Pistes par Genre

### 1.1. Requête Initiale

Requête pour rechercher toutes les pistes d'un genre spécifique (par exemple, `Rock`).

```sql
SELECT * FROM Track WHERE GenreId = (SELECT GenreId FROM Genre WHERE Name = 'Rock');
```

### 1.2. Plan d'Exécution

```sql
EXPLAIN ANALYZE
SELECT * FROM Track WHERE GenreId = (SELECT GenreId FROM Genre WHERE Name = 'Rock');
```

### 1.3. Création d'un Index B-tree

L'index B-tree est le type d'index par défaut et est optimal pour les recherches de valeurs exactes.

```sql
CREATE INDEX idx_track_genreId ON Track (GenreId);
```

### 1.4. Rejouer la Requête avec l'Index B-tree

```sql
EXPLAIN ANALYZE
SELECT * FROM Track WHERE GenreId = (SELECT GenreId FROM Genre WHERE Name = 'Rock');
```

---

## 2. Recherche Textuelle dans les Titres de Pistes

### 2.1. Requête Initiale

Requête pour rechercher toutes les pistes contenant le mot "Love" dans leur titre.

```sql
SELECT * FROM Track WHERE Name ILIKE '%Love%';
```

### 2.2. Plan d'Exécution

```sql
EXPLAIN ANALYZE
SELECT * FROM Track WHERE Name ILIKE '%Love%';
```

### 2.3. Création d'un Index GIN

Les index GIN sont optimaux pour les recherches textuelles et les types de données avec plusieurs valeurs.

```sql
CREATE INDEX idx_track_name_gin ON Track USING gin (to_tsvector('english', Name));
```

### 2.4. Rejouer la Requête avec l'Index GIN

```sql
EXPLAIN ANALYZE
SELECT * FROM Track WHERE to_tsvector('english', Name) @@ to_tsquery('english', 'Love');
```

---

## 3. Analyse des Ventes par Piste

### 3.1. Requête Initiale

Requête pour analyser les ventes de chaque piste.

```sql
SELECT TrackId, SUM(Quantity) AS TotalSales
FROM InvoiceLine
GROUP BY TrackId;
```

### 3.2. Plan d'Exécution

```sql
EXPLAIN ANALYZE
SELECT TrackId, SUM(Quantity) AS TotalSales
FROM InvoiceLine
GROUP BY TrackId;
```

### 3.3. Création d'un Index BRIN

Les index BRIN (Block Range INdexes) sont efficaces pour les tables volumineuses où les données sont naturellement ordonnées.

```sql
CREATE INDEX idx_invoiceLine_trackId_brin ON InvoiceLine USING brin (TrackId);
```

### 3.4. Rejouer la Requête avec l'Index BRIN

```sql
EXPLAIN ANALYZE
SELECT TrackId, SUM(Quantity) AS TotalSales
FROM InvoiceLine
GROUP BY TrackId;
```

---

## Résultats et Comparaison des Plans d'Exécution

### Avant l'Indexation

- **Recherche par Genre** :
  - Sans index : Scan séquentiel sur la table `Track`.
- **Recherche Textuelle** :
  - Sans index : Scan séquentiel sur la table `Track`.
- **Analyse des Ventes par Piste** :
  - Sans index : Scan séquentiel et agrégation coûteuse sur la table `InvoiceLine`.

### Après l'Indexation

- **Recherche par Genre avec Index B-tree** :
  - Avec index : Utilisation de l'index B-tree pour un accès rapide aux pistes par genre.
- **Recherche Textuelle avec Index GIN** :
  - Avec index : Utilisation de l'index GIN pour des recherches textuelles rapides.
- **Analyse des Ventes par Piste avec Index BRIN** :
  - Avec index : Utilisation de l'index BRIN pour optimiser l'agrégation des ventes par piste.

### Exemple de Plans d'Exécution

#### Avant l'Indexation

**Recherche par Genre** :
```plaintext
Seq Scan on Track  (cost=0.00..1125.00 rows=100 width=68) (actual time=0.012..12.345 rows=100 loops=1)
  Filter: (GenreId = 1)
```

**Recherche Textuelle** :
```plaintext
Seq Scan on Track  (cost=0.00..1250.00 rows=10 width=64) (actual time=0.015..15.678 rows=10 loops=1)
  Filter: (Name ~~* '%Love%')
```

**Analyse des Ventes par Piste** :
```plaintext
Seq Scan on InvoiceLine  (cost=0.00..1550.00 rows=100000 width=32) (actual time=0.022..30.456 rows=100000 loops=1)
  Group Key: TrackId
```

#### Après l'Indexation

**Recherche par Genre avec Index B-tree** :
```plaintext
Bitmap Heap Scan on Track  (cost=4.14..24.44 rows=10 width=68) (actual time=0.010..0.025 rows=10 loops=1)
  Recheck Cond: (GenreId = 1)
  ->  Bitmap Index Scan on idx_track_genreId  (cost=0.00..4.14 rows=10 width=0) (actual time=0.008..0.009 rows=10 loops=1)
```

**Recherche Textuelle avec Index GIN** :
```plaintext
Bitmap Heap Scan on Track  (cost=4.14..24.44 rows=10 width=64) (actual time=0.011..0.030 rows=10 loops=1)
  Recheck Cond: (to_tsvector('english'::regconfig, Name) @@ to_tsquery('english', 'Love'::text))
  ->  Bitmap Index Scan on idx_track_name_gin  (cost=0.00..4.14 rows=10 width=0) (actual time=0.009..0.010 rows=10 loops=1)
```

**Analyse des Ventes par Piste avec Index BRIN** :
```plaintext
Bitmap Heap Scan on InvoiceLine  (cost=4.14..24.44 rows=1000 width=32) (actual time=0.022..20.456 rows=100000 loops=1)
  Recheck Cond: (TrackId = 1)
  ->  Bitmap Index Scan on idx_invoiceLine_trackId_brin  (cost=0.00..4.14 rows=1000 width=0) (actual time=0.010..0.011 rows=100000 loops=1)
```

---

En suivant ces étapes, vous pourrez observer comment différents types d'index peuvent améliorer les performances des requêtes dans la base de données Chinook. Vous verrez des améliorations significatives dans les temps d'exécution des requêtes grâce aux index B-tree, GIN et BRIN, chacun étant optimisé pour des scénarios de recherche et d'analyse spécifiques.
PostgreSQL 14 offre plusieurs types de partitionnement qui peuvent être utilisés pour organiser et gérer les tables de manière plus efficace. Voici les principaux types de partitionnement disponibles :

### 1. Partitionnement par plage (Range Partitioning)
Ce type de partitionnement divise une table en partitions basées sur des plages de valeurs.

**Exemple :**
```sql
CREATE TABLE ventes (
    id SERIAL PRIMARY KEY,
    date_vente DATE NOT NULL,
    montant DECIMAL
) PARTITION BY RANGE (date_vente);

CREATE TABLE ventes_2023 PARTITION OF ventes FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');
CREATE TABLE ventes_2022 PARTITION OF ventes FOR VALUES FROM ('2022-01-01') TO ('2023-01-01');
CREATE TABLE ventes_2021 PARTITION OF ventes FOR VALUES FROM ('2021-01-01') TO ('2022-01-01');
```

### 2. Partitionnement par liste (List Partitioning)
Ce type de partitionnement divise une table en partitions basées sur des valeurs discrètes.

**Exemple :**
```sql
CREATE TABLE ventes (
    id SERIAL PRIMARY KEY,
    region TEXT NOT NULL,
    montant DECIMAL
) PARTITION BY LIST (region);

CREATE TABLE ventes_nord PARTITION OF ventes FOR VALUES IN ('NORD');
CREATE TABLE ventes_sud PARTITION OF ventes FOR VALUES IN ('SUD');
CREATE TABLE ventes_est PARTITION OF ventes FOR VALUES IN ('EST');
CREATE TABLE ventes_ouest PARTITION OF ventes FOR VALUES IN ('OUEST');
```

### 3. Partitionnement par hachage (Hash Partitioning)
Ce type de partitionnement utilise une fonction de hachage pour diviser les données en partitions.

**Exemple :**
```sql
CREATE TABLE utilisateurs (
    id SERIAL PRIMARY KEY,
    nom TEXT,
    email TEXT
) PARTITION BY HASH (id);

CREATE TABLE utilisateurs_p0 PARTITION OF utilisateurs FOR VALUES WITH (MODULUS 4, REMAINDER 0);
CREATE TABLE utilisateurs_p1 PARTITION OF utilisateurs FOR VALUES WITH (MODULUS 4, REMAINDER 1);
CREATE TABLE utilisateurs_p2 PARTITION OF utilisateurs FOR VALUES WITH (MODULUS 4, REMAINDER 2);
CREATE TABLE utilisateurs_p3 PARTITION OF utilisateurs FOR VALUES WITH (MODULUS 4, REMAINDER 3);
```

### 4. Partitionnement composite (Combinaison de plusieurs types)
Ce type de partitionnement permet de combiner plusieurs méthodes de partitionnement pour une gestion plus fine des données.

**Exemple :**
```sql
CREATE TABLE ventes (
    id SERIAL PRIMARY KEY,
    date_vente DATE NOT NULL,
    region TEXT,
    montant DECIMAL
) PARTITION BY RANGE (date_vente) SUBPARTITION BY LIST (region);

CREATE TABLE ventes_2023 PARTITION OF ventes FOR VALUES FROM ('2023-01-01') TO ('2024-01-01')
    PARTITION BY LIST (region);

CREATE TABLE ventes_2023_nord PARTITION OF ventes_2023 FOR VALUES IN ('NORD');
CREATE TABLE ventes_2023_sud PARTITION OF ventes_2023 FOR VALUES IN ('SUD');
CREATE TABLE ventes_2023_est PARTITION OF ventes_2023 FOR VALUES IN ('EST');
CREATE TABLE ventes_2023_ouest PARTITION OF ventes_2023 FOR VALUES IN ('OUEST');
```

### Avantages de chaque type de partitionnement

1. **Partitionnement par plage (Range Partitioning)** :
   - **Avantages** : Idéal pour les données temporelles, facilite l'archivage et la gestion des données historiques, améliore les performances des requêtes sur des plages de dates spécifiques.

2. **Partitionnement par liste (List Partitioning)** :
   - **Avantages** : Permet de segmenter les données par catégories distinctes, simplifie les requêtes et les opérations de maintenance pour des groupes de données spécifiques.

3. **Partitionnement par hachage (Hash Partitioning)** :
   - **Avantages** : Répartition uniforme des données, équilibrage de charge, évite les hotspots, facilite la gestion de grands volumes de données avec un accès uniforme.

4. **Partitionnement composite (Combinaison de plusieurs types)** :
   - **Avantages** : Offre une flexibilité maximale, combine les avantages de plusieurs types de partitionnement pour une gestion plus fine et des performances optimisées.

Chaque type de partitionnement a ses propres avantages et peut être choisi en fonction des besoins spécifiques des données et des requêtes. En combinant différentes méthodes, il est possible de maximiser l'efficacité et la performance de la base de données PostgreSQL.
Pour illustrer les opérations de partitionnement de table avec des données fictives, prenons l'exemple d'une table `sales` contenant des données de ventes avec les colonnes `sale_id`, `sale_date`, et `amount`.

### 1. Création de table partitionnée

Créons une table partitionnée par date de vente (`sale_date`), avec des partitions pour chaque année.

```sql
CREATE TABLE sales (
    sale_id INT,
    sale_date DATE,
    amount DECIMAL(10, 2)
)
PARTITION BY RANGE (sale_date) (
    PARTITION p0 VALUES LESS THAN ('2021-01-01'),
    PARTITION p1 VALUES LESS THAN ('2022-01-01'),
    PARTITION p2 VALUES LESS THAN ('2023-01-01')
);
```

### 2. Ajout d'une nouvelle partition

Ajoutons une nouvelle partition pour l'année 2023.

```sql
ALTER TABLE sales ADD PARTITION (
    PARTITION p3 VALUES LESS THAN ('2024-01-01')
);
```

### 3. Détachement d'une partition

Détachons la partition `p1` pour la transformer en une table autonome nommée `sales_p1`.

```sql
ALTER TABLE sales DETACH PARTITION p1 INTO sales_p1;
```

### 4. Suppression d'une partition

Supprimons la partition `p0`.

```sql
ALTER TABLE sales DROP PARTITION p0;
```

### 5. Fusion de partitions

Fusionnons les partitions `p1` et `p2` en une nouvelle partition `p1_p2`.

```sql
ALTER TABLE sales COALESCE PARTITION p1, p2 INTO p1_p2;
```

### 6. Scission d'une partition

Scindons la partition `p2` en deux partitions `p2a` et `p2b`.

```sql
ALTER TABLE sales SPLIT PARTITION p2 INTO (
    PARTITION p2a VALUES LESS THAN ('2022-06-01'),
    PARTITION p2b VALUES LESS THAN ('2023-01-01')
);
```

### 7. Renommer une partition

Renommons la partition `p2` en `p2_new`.

```sql
ALTER TABLE sales RENAME PARTITION p2 TO p2_new;
```

### 8. Changer le tablespace d'une partition

Déplaçons la partition `p1` vers un nouveau tablespace `new_tablespace`.

```sql
ALTER TABLE sales MOVE PARTITION p1 TO tablespace new_tablespace;
```

### 9. Échange de partitions

Échangeons le contenu de la partition `p1` avec une table temporaire `temp_table`.

```sql
ALTER TABLE sales EXCHANGE PARTITION p1 WITH TABLE temp_table;
```

### Données fictives

Pour rendre les exemples plus concrets, voici un ensemble de données fictives pour la table `sales` :

```sql
INSERT INTO sales (sale_id, sale_date, amount) VALUES
(1, '2020-01-15', 100.00),
(2, '2020-02-20', 150.00),
(3, '2020-03-25', 200.00),
(4, '2020-04-15', 250.00),
(5, '2020-05-15', 300.00),
(6, '2020-06-05', 350.00),
(7, '2020-07-22', 400.00),
(8, '2020-08-30', 450.00),
(9, '2020-09-10', 500.00),
(10, '2020-10-15', 550.00),
(11, '2020-11-20', 600.00),
(12, '2020-12-25', 650.00),
(13, '2021-01-15', 700.00),
(14, '2021-02-20', 750.00),
(15, '2021-03-25', 800.00),
(16, '2021-04-15', 850.00),
(17, '2021-05-15', 900.00),
(18, '2021-06-05', 950.00),
(19, '2021-07-22', 1000.00),
(20, '2021-08-30', 1050.00),
(21, '2021-09-10', 1100.00),
(22, '2021-10-15', 1150.00),
(23, '2021-11-20', 1200.00),
(24, '2021-12-25', 1250.00),
(25, '2022-01-15', 1300.00),
(26, '2022-02-20', 1350.00),
(27, '2022-03-25', 1400.00),
(28, '2022-04-15', 1450.00),
(29, '2022-05-15', 1500.00),
(30, '2022-06-05', 1550.00),
(31, '2022-07-22', 1600.00),
(32, '2022-08-30', 1650.00),
(33, '2022-09-10', 1700.00),
(34, '2022-10-15', 1750.00),
(35, '2022-11-20', 1800.00),
(36, '2022-12-25', 1850.00),
(37, '2023-01-15', 1900.00),
(38, '2023-02-20', 1950.00),
(39, '2023-03-25', 2000.00),
(40, '2023-04-15', 2050.00),
(41, '2023-05-15', 2100.00),
(42, '2023-06-05', 2150.00),
(43, '2023-07-22', 2200.00),
(44, '2023-08-30', 2250.00),
(45, '2023-09-10', 2300.00),
(46, '2023-10-15', 2350.00),
(47, '2023-11-20', 2400.00),
(48, '2023-12-25', 2450.00);

```

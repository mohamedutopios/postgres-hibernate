### 1. Création d'une Table Exemple

Nous allons créer une table `sales` avec quelques colonnes pour nos exemples d'indexation.

```sql
CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    product_id INTEGER,
    customer_id INTEGER,
    sale_date DATE,
    quantity INTEGER,
    total DECIMAL(10, 2)
);
```

### 2. Insertion de Données Exemple

Insérons quelques données pour travailler avec.

```sql
INSERT INTO sales (product_id, customer_id, sale_date, quantity, total) VALUES
(1, 1, '2023-01-01', 2, 29.99),
(2, 1, '2023-01-02', 1, 19.99),
(1, 2, '2023-01-03', 5, 99.95),
(3, 3, '2023-01-04', 3, 59.97),
(2, 3, '2023-01-05', 4, 79.96);
```

### 3. Création d'Index

#### Index B-Tree (Par défaut)

L'index B-Tree est le type d'index par défaut dans PostgreSQL et est optimal pour la plupart des recherches d'égalité et de plage.

```sql
CREATE INDEX idx_sales_product_id ON sales (product_id);
```

#### Index Hash

Les index Hash sont optimisés pour les recherches d'égalité.

```sql
CREATE INDEX idx_sales_customer_id_hash ON sales USING hash (customer_id);
```

#### Index GIN (Generalized Inverted Index)

Les index GIN sont utilisés pour les recherches textuelles et les types de données avec plusieurs valeurs, comme les tableaux et les documents JSONB.

```sql
CREATE INDEX idx_sales_product_text_gin ON sales USING gin (to_tsvector('english', product_id::text));
```

#### Index BRIN (Block Range INdexes)

Les index BRIN sont efficaces pour les très grandes tables où les données sont naturellement ordonnées.

```sql
CREATE INDEX idx_sales_date_brin ON sales USING brin (sale_date);
```

#### Index Multicolonne

Les index multicolonne sont utiles lorsque vous souhaitez optimiser les requêtes impliquant plusieurs colonnes.

```sql
CREATE INDEX idx_sales_product_date ON sales (product_id, sale_date);
```

#### Index Partiel

Les index partiels sont utilisés pour indexer uniquement une partie des lignes de la table.

```sql
CREATE INDEX idx_sales_high_quantity ON sales (product_id) WHERE quantity > 3;
```

#### Index sur Colonne Calculée

Les index sur les colonnes calculées optimisent les requêtes utilisant des expressions.

```sql
CREATE INDEX idx_sales_month ON sales ((EXTRACT(MONTH FROM sale_date)));
```

### 4. Suppression d'un Index

Pour supprimer un index, utilisez la commande `DROP INDEX`.

```sql
DROP INDEX idx_sales_product_id;
```

### 5. Modification d'un Index

PostgreSQL ne supporte pas directement la modification d'un index. Si vous avez besoin de modifier un index, vous devez le supprimer et le recréer.

#### Exemple : Recréation d'un Index avec des Modifications

```sql
-- Suppression de l'index existant
DROP INDEX idx_sales_product_date;

-- Création d'un nouvel index avec des modifications
CREATE INDEX idx_sales_product_date_qty ON sales (product_id, sale_date, quantity);
```

### 6. Exemples de Requêtes Optimisées par les Index

#### Utilisation d'un Index B-Tree

```sql
EXPLAIN ANALYZE
SELECT * FROM sales WHERE product_id = 1;
```

#### Utilisation d'un Index Partiel

```sql
EXPLAIN ANALYZE
SELECT * FROM sales WHERE product_id = 1 AND quantity > 3;
```

#### Utilisation d'un Index Multicolonne

```sql
EXPLAIN ANALYZE
SELECT * FROM sales WHERE product_id = 1 AND sale_date = '2023-01-01';
```

#### Utilisation d'un Index sur Colonne Calculée

```sql
EXPLAIN ANALYZE
SELECT * FROM sales WHERE EXTRACT(MONTH FROM sale_date) = 1;
```

### Conclusion

Voici un résumé des opérations possibles pour l'indexation dans PostgreSQL, avec des exemples simples :

- **Créer un index B-Tree** : `CREATE INDEX idx_sales_product_id ON sales (product_id);`
- **Créer un index Hash** : `CREATE INDEX idx_sales_customer_id_hash ON sales USING hash (customer_id);`
- **Créer un index GIN** : `CREATE INDEX idx_sales_product_text_gin ON sales USING gin (to_tsvector('english', product_id::text));`
- **Créer un index BRIN** : `CREATE INDEX idx_sales_date_brin ON sales USING brin (sale_date);`
- **Créer un index multicolonne** : `CREATE INDEX idx_sales_product_date ON sales (product_id, sale_date);`
- **Créer un index partiel** : `CREATE INDEX idx_sales_high_quantity ON sales (product_id) WHERE quantity > 3;`
- **Créer un index sur colonne calculée** : `CREATE INDEX idx_sales_month ON sales ((EXTRACT(MONTH FROM sale_date)));`
- **Supprimer un index** : `DROP INDEX idx_sales_product_id;`
- **Modifier un index** : Supprimer et recréer l'index avec les modifications nécessaires.

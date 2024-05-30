Pour illustrer l'utilisation d'index dans différents cas, y compris les jointures, les index partiels, les index multicolonne, et autres, nous allons utiliser la base de données Chinook. Voici plusieurs scénarios pertinents où chaque type d'index peut être justifié.

### Scénario 1 : Optimisation des Jointures

#### 1.1. Requête Initiale avec Jointure

Nous allons joindre les tables `Invoice` et `Customer` pour obtenir les factures de chaque client.

```sql
SELECT Invoice.InvoiceId, Customer.FirstName, Customer.LastName, Invoice.Total
FROM Invoice
JOIN Customer ON Invoice.CustomerId = Customer.CustomerId;
```

#### 1.2. Plan d'Exécution

```sql
EXPLAIN ANALYZE
SELECT Invoice.InvoiceId, Customer.FirstName, Customer.LastName, Invoice.Total
FROM Invoice
JOIN Customer ON Invoice.CustomerId = Customer.CustomerId;
```

#### 1.3. Création d'un Index sur les Clés Étrangères

Les index sur les clés étrangères optimisent les jointures.

```sql
CREATE INDEX idx_invoice_customerId ON Invoice (CustomerId);
```

#### 1.4. Rejouer la Requête avec l'Index

```sql
EXPLAIN ANALYZE
SELECT Invoice.InvoiceId, Customer.FirstName, Customer.LastName, Invoice.Total
FROM Invoice
JOIN Customer ON Invoice.CustomerId = Customer.CustomerId;
```

---

### Scénario 2 : Indexation Partielle

#### 2.1. Requête Initiale avec Condition

Requête pour obtenir les factures avec un montant total supérieur à 10.

```sql
SELECT * FROM Invoice WHERE Total > 10;
```

#### 2.2. Plan d'Exécution

```sql
EXPLAIN ANALYZE
SELECT * FROM Invoice WHERE Total > 10;
```

#### 2.3. Création d'un Index Partiel

Un index partiel est créé pour optimiser les requêtes avec des conditions spécifiques.

```sql
CREATE INDEX idx_invoice_total_partial ON Invoice (Total) WHERE Total > 10;
```

#### 2.4. Rejouer la Requête avec l'Index Partiel

```sql
EXPLAIN ANALYZE
SELECT * FROM Invoice WHERE Total > 10;
```

---

### Scénario 3 : Indexation Multicolonne

#### 3.1. Requête Initiale

Requête pour obtenir les factures d'un client spécifique, triées par date de facture.

```sql
SELECT * FROM Invoice WHERE CustomerId = 3 ORDER BY InvoiceDate;
```

#### 3.2. Plan d'Exécution

```sql
EXPLAIN ANALYZE
SELECT * FROM Invoice WHERE CustomerId = 3 ORDER BY InvoiceDate;
```

#### 3.3. Création d'un Index Multicolonne

L'index multicolonne optimise les requêtes combinant plusieurs colonnes.

```sql
CREATE INDEX idx_invoice_customer_date ON Invoice (CustomerId, InvoiceDate);
```

#### 3.4. Rejouer la Requête avec l'Index Multicolonne

```sql
EXPLAIN ANALYZE
SELECT * FROM Invoice WHERE CustomerId = 3 ORDER BY InvoiceDate;
```

---

### Scénario 4 : Index sur les Colonnes Calculées

#### 4.1. Requête Initiale

Requête pour obtenir les factures du mois de janvier.

```sql
SELECT * FROM Invoice WHERE EXTRACT(MONTH FROM InvoiceDate) = 1;
```

#### 4.2. Plan d'Exécution

```sql
EXPLAIN ANALYZE
SELECT * FROM Invoice WHERE EXTRACT(MONTH FROM InvoiceDate) = 1;
```

#### 4.3. Création d'un Index sur les Colonnes Calculées

Les index sur les colonnes calculées optimisent les requêtes utilisant des expressions.

```sql
CREATE INDEX idx_invoice_month ON Invoice ((EXTRACT(MONTH FROM InvoiceDate)));
```

#### 4.4. Rejouer la Requête avec l'Index sur Colonne Calculée

```sql
EXPLAIN ANALYZE
SELECT * FROM Invoice WHERE EXTRACT(MONTH FROM InvoiceDate) = 1;
```

---

### Comparaison des Plans d'Exécution

Après avoir créé les différents types d'index, comparez les plans d'exécution avant et après l'indexation pour chaque scénario. Vous devriez observer des améliorations significatives dans les temps d'exécution des requêtes grâce à l'utilisation des index.

---

# TP : Utilisation de Divers Types d'Index dans la Base de Données Chinook

## Objectif

Optimiser les performances des requêtes en utilisant différents types d'index : jointures, index partiels, index multicolonne, et index sur colonnes calculées.

## Étapes

### 1. Optimisation des Jointures

#### 1.1. Requête Initiale

```sql
SELECT Invoice.InvoiceId, Customer.FirstName, Customer.LastName, Invoice.Total
FROM Invoice
JOIN Customer ON Invoice.CustomerId = Customer.CustomerId;
```

#### 1.2. Plan d'Exécution

```sql
EXPLAIN ANALYZE
SELECT Invoice.InvoiceId, Customer.FirstName, Customer.LastName, Invoice.Total
FROM Invoice
JOIN Customer ON Invoice.CustomerId = Customer.CustomerId;
```

#### 1.3. Création d'un Index sur les Clés Étrangères

```sql
CREATE INDEX idx_invoice_customerId ON Invoice (CustomerId);
```

#### 1.4. Rejouer la Requête

```sql
EXPLAIN ANALYZE
SELECT Invoice.InvoiceId, Customer.FirstName, Customer.LastName, Invoice.Total
FROM Invoice
JOIN Customer ON Invoice.CustomerId = Customer.CustomerId;
```

### 2. Requête Initiale avec `GROUP BY`

```sql
SELECT CustomerId, COUNT(*) AS NumInvoices
FROM Invoice
GROUP BY CustomerId;
```

#### Plan d'Exécution sans Index

```sql
EXPLAIN ANALYZE
SELECT CustomerId, COUNT(*) AS NumInvoices
FROM Invoice
GROUP BY CustomerId;
```

### 2.1 Création d'un Index sur `CustomerId`

```sql
CREATE INDEX idx_invoice_customerId ON Invoice (CustomerId);
```

### 2.2 Rejouer la Requête avec l'Index

```sql
EXPLAIN ANALYZE
SELECT CustomerId, COUNT(*) AS NumInvoices
FROM Invoice
GROUP BY CustomerId;
```

### 3. Indexation Partielle

#### 3.1. Requête Initiale

```sql
SELECT * FROM Invoice WHERE Total > 10;
```

#### 3.2. Plan d'Exécution

```sql
EXPLAIN ANALYZE
SELECT * FROM Invoice WHERE Total > 10;
```

#### 3.3. Création d'un Index Partiel

```sql
CREATE INDEX idx_invoice_total_partial ON Invoice (Total) WHERE Total > 10;
```

#### 3.4. Rejouer la Requête

```sql
EXPLAIN ANALYZE
SELECT * FROM Invoice WHERE Total > 10;
```

### 4. Indexation Multicolonne

#### 4.1. Requête Initiale

```sql
SELECT * FROM Invoice WHERE CustomerId = 3 ORDER BY InvoiceDate;
```

#### 4.2. Plan d'Exécution

```sql
EXPLAIN ANALYZE
SELECT * FROM Invoice WHERE CustomerId = 3 ORDER BY InvoiceDate;
```

#### 4.3. Création d'un Index Multicolonne

```sql
CREATE INDEX idx_invoice_customer_date ON Invoice (CustomerId, InvoiceDate);
```

#### 4.4. Rejouer la Requête

```sql
EXPLAIN ANALYZE
SELECT * FROM Invoice WHERE CustomerId = 3 ORDER BY InvoiceDate;
```

### 5. Index sur Colonnes Calculées

#### 5.1. Requête Initiale

```sql
SELECT * FROM Invoice WHERE EXTRACT(MONTH FROM InvoiceDate) = 1;
```

#### 5.2. Plan d'Exécution

```sql
EXPLAIN ANALYZE
SELECT * FROM Invoice WHERE EXTRACT(MONTH FROM InvoiceDate) = 1;
```

#### 5.3. Création d'un Index sur Colonnes Calculées

```sql
CREATE INDEX idx_invoice_month ON Invoice ((EXTRACT(MONTH FROM InvoiceDate)));
```

#### 5.4. Rejouer la Requête

```sql
EXPLAIN ANALYZE
SELECT * FROM Invoice WHERE EXTRACT(MONTH FROM InvoiceDate) = 1;
```

### Comparaison des Plans d'Exécution

Comparez les plans d'exécution avant et après la création des index pour chaque scénario. Notez les différences en termes de coût et de temps d'exécution pour démontrer l'impact positif de l'indexation.

---

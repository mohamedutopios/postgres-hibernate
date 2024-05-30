Bien sûr, voici les consignes formatées en Markdown :

---

# Optimisation des Requêtes avec Indexation dans la Base de Données Chinook

## 1. Requête Affichant les Commandes Passées au Mois de Janvier 2014

### Requête SQL
```sql
SELECT * FROM Invoice WHERE InvoiceDate BETWEEN '2014-01-01' AND '2014-01-31';
```

### Plan de la Requête
```sql
EXPLAIN ANALYZE
SELECT * FROM Invoice WHERE InvoiceDate BETWEEN '2014-01-01' AND '2014-01-31';
```

## 2. Réécrire la Requête par Ordre de Date Croissante

### Requête SQL
```sql
SELECT * FROM Invoice WHERE InvoiceDate BETWEEN '2014-01-01' AND '2014-01-31' ORDER BY InvoiceDate ASC;
```

### Plan de la Requête
```sql
EXPLAIN ANALYZE
SELECT * FROM Invoice WHERE InvoiceDate BETWEEN '2014-01-01' AND '2014-01-31' ORDER BY InvoiceDate ASC;
```

## 3. Créer un Index pour Optimiser les Requêtes

### Création de l'Index sur `InvoiceDate`
```sql
CREATE INDEX idx_invoice_invoiceDate ON Invoice (InvoiceDate);
```

## 4. Afficher le Plan de la Requête Optimisée et Comparer

### Plan de la Requête Optimisée (sans tri)
```sql
EXPLAIN ANALYZE
SELECT * FROM Invoice WHERE InvoiceDate BETWEEN '2014-01-01' AND '2014-01-31';
```

### Plan de la Requête Optimisée (avec tri)
```sql
EXPLAIN ANALYZE
SELECT * FROM Invoice WHERE InvoiceDate BETWEEN '2014-01-01' AND '2014-01-31' ORDER BY InvoiceDate ASC;
```

## 5. Requête Listant les Commandes pour `CustomerId = 3`

### Requête SQL
```sql
SELECT * FROM Invoice WHERE CustomerId = 3;
```

### Plan de la Requête
```sql
EXPLAIN ANALYZE
SELECT * FROM Invoice WHERE CustomerId = 3;
```

## 6. Créer un Index pour Accélérer la Requête

### Création de l'Index sur `CustomerId`
```sql
CREATE INDEX idx_invoice_customerId ON Invoice (CustomerId);
```

## 7. Afficher de Nouveau le Plan de la Requête

### Plan de la Requête Optimisée
```sql
EXPLAIN ANALYZE
SELECT * FROM Invoice WHERE CustomerId = 3;
```

---

Pour ouvrir deux sessions concurrentes dans MySQL Workbench et simuler des transactions concurrentes, vous pouvez suivre les étapes suivantes :

### Étape 1 : Créer les Tables et Insérer des Données

Assurez-vous d'abord d'avoir les tables et les données nécessaires dans votre base de données PostgreSQL. Exécutez ces commandes SQL dans votre base de données PostgreSQL depuis MySQL Workbench :

1. Ouvrez MySQL Workbench et connectez-vous à votre base de données PostgreSQL.
2. Ouvrez une nouvelle fenêtre de requête et exécutez les commandes suivantes pour créer les tables et insérer des données :

```sql
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE NOT NULL
);

INSERT INTO customers (customer_name) VALUES ('Alice'), ('Bob'), ('Charlie');
INSERT INTO orders (customer_id, order_date) VALUES (1, '2023-01-01'), (2, '2023-01-02'), (3, '2023-01-03');
```

### Étape 2 : Ouvrir Deux Sessions de Transactions Concurrentes

Vous allez ouvrir deux fenêtres de requête distinctes dans MySQL Workbench pour simuler des transactions concurrentes.

#### Session 1 : Appliquer un Verrou Exclusif

1. Ouvrez une nouvelle fenêtre de requête en allant dans `File -> New Query Tab` ou en utilisant le raccourci `Ctrl+T`.
2. Dans la première fenêtre de requête, démarrez une transaction et appliquez un verrou exclusif.

```sql
BEGIN;

-- Appliquer un verrou exclusif sur une ligne de la table customers
UPDATE customers SET customer_name = 'Alice Updated' WHERE customer_id = 1;
```

**Ne fermez pas cette session ni ne validez la transaction pour simuler un verrouillage long.**

#### Session 2 : Tenter de Lire la Ligne Verrouillée

1. Ouvrez une autre nouvelle fenêtre de requête en allant dans `File -> New Query Tab` ou en utilisant le raccourci `Ctrl+T`.
2. Dans la deuxième fenêtre de requête, démarrez une autre transaction et essayez de lire la même ligne.

```sql
BEGIN;

-- Tenter de lire la ligne qui est verrouillée par la première transaction
SELECT * FROM customers WHERE customer_id = 1;
```

### Étape 3 : Observer le Verrouillage

Pour observer le verrouillage, ouvrez une troisième fenêtre de requête et exécutez la commande suivante pour voir les verrous actifs :

```sql
SELECT 
    locktype, 
    relation::regclass AS relation, 
    page, 
    tuple, 
    transactionid, 
    virtualtransaction, 
    pid, 
    mode, 
    granted
FROM 
    pg_locks
WHERE 
    NOT granted;
```

### Vérification des Verrous

Les résultats devraient montrer que la deuxième transaction est bloquée en attendant le verrou détenu par la première transaction.

### Libérer les Verrous

Pour libérer les verrous et terminer les transactions, vous pouvez faire un `COMMIT` ou un `ROLLBACK` dans la première session :

#### Session 1

```sql
COMMIT;
```

Une fois que la première transaction est terminée, la deuxième transaction pourra accéder à la ligne verrouillée et terminer son `SELECT`.

### Conclusion

En utilisant MySQL Workbench, vous pouvez ouvrir plusieurs fenêtres de requête pour simuler des transactions concurrentes et observer le comportement de verrouillage dans PostgreSQL. Cela vous permet de diagnostiquer les problèmes de verrouillage et de contention dans votre base de données.
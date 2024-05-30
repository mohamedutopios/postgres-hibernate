La fonction `pg_blocking_pids` dans PostgreSQL est très utile pour identifier les processus qui bloquent d'autres processus. Cette fonction renvoie une liste des IDs de processus (PIDs) qui bloquent la transaction courante ou une transaction spécifique.

### Utilisation de `pg_blocking_pids`

Voici comment vous pouvez utiliser `pg_blocking_pids` pour diagnostiquer les transactions bloquantes et bloquées.

### Étape 1 : Créer les Tables et Insérer des Données

Supposons que vous avez les tables suivantes :

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

### Étape 2 : Simuler des Transactions Concurrentes

#### Session 1 : Appliquer un Verrou Exclusif

1. Ouvrez une nouvelle session et exécutez les commandes suivantes :

```sql
BEGIN;

-- Appliquer un verrou exclusif sur une ligne de la table customers
UPDATE customers SET customer_name = 'Alice Updated' WHERE customer_id = 1;
```

#### Session 2 : Tenter de Lire la Ligne Verrouillée

2. Ouvrez une autre session et exécutez les commandes suivantes :

```sql
BEGIN;

-- Tenter de lire la ligne qui est verrouillée par la première transaction
SELECT * FROM customers WHERE customer_id = 1;
```

La deuxième transaction sera bloquée en attendant que la première transaction soit validée ou annulée.

### Étape 3 : Identifier les Transactions Bloquantes

Ouvrez une troisième session et exécutez les commandes suivantes pour identifier les transactions bloquantes et bloquées :

#### Utilisation de `pg_blocking_pids`

```sql
SELECT 
    pid, 
    pg_blocking_pids(pid) AS blocking_pids
FROM 
    pg_stat_activity
WHERE 
    state = 'active' 
    AND pid <> pg_backend_pid();
```

### Étape 4 : Interpréter les Résultats

Les résultats devraient ressembler à ceci :

```
 pid  | blocking_pids 
------+---------------
 1234 | {5678}
 5678 | {}
```

Cela signifie que le processus avec PID `1234` est bloqué par le processus avec PID `5678`.

### Étape 5 : Afficher des Détails Supplémentaires

Pour obtenir des informations plus détaillées sur les transactions bloquantes et bloquées, vous pouvez joindre la table `pg_stat_activity` :

```sql
SELECT 
    blocked.pid AS blocked_pid, 
    blocked.usename AS blocked_user, 
    blocked.query AS blocked_query, 
    blocking.pid AS blocking_pid, 
    blocking.usename AS blocking_user, 
    blocking.query AS blocking_query
FROM 
    pg_stat_activity blocked
JOIN 
    pg_stat_activity blocking ON blocking.pid = ANY(pg_blocking_pids(blocked.pid))
WHERE 
    blocked.state = 'active' 
    AND blocked.pid <> pg_backend_pid();
```

### Conclusion

En utilisant `pg_blocking_pids`, vous pouvez identifier rapidement les transactions qui causent des blocages dans PostgreSQL. Cette fonction est particulièrement utile pour diagnostiquer les problèmes de verrouillage et de contention dans votre base de données. Avec les informations fournies par `pg_stat_activity`, vous pouvez également obtenir des détails sur les requêtes impliquées, ce qui vous permet de prendre des mesures correctives plus facilement.
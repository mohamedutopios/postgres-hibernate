### Étape 1 : Configurer `shared_buffers` à 128 MB

1. **Modifier `postgresql.conf`**

   Ouvrez le fichier de configuration :

   ```bash
   sudo nano /etc/postgresql/14/main/postgresql.conf
   ```

   Modifiez ou ajoutez la ligne suivante :

   ```ini
   shared_buffers = '128MB'
   ```

2. **Recharger la Configuration**

   Rechargez PostgreSQL pour appliquer les changements :

   ```bash
   sudo systemctl reload postgresql
   ```

### Étape 2 : Exécuter `EXPLAIN ANALYZE` avec `shared_buffers` à 128 MB

1. **Créer une Table de Test et Insérer des Données**

   Connectez-vous à PostgreSQL et créez une table de test :

   ```sql
   CREATE TABLE test_table (
       id SERIAL PRIMARY KEY,
       data TEXT
   );
   ```

   Insérez des données pour créer une charge de travail initiale :

   ```sql
   DO $$ 
   BEGIN 
       FOR i IN 1..100000 LOOP 
           INSERT INTO test_table (data) VALUES (md5(random()::text)); 
       END LOOP; 
   END $$;
   ```

2. **Exécuter `EXPLAIN ANALYZE`**

   Exécutez `EXPLAIN ANALYZE` pour une requête représentative :

   ```sql
   EXPLAIN (ANALYZE, BUFFERS) SELECT * FROM test_table WHERE id = 1;
   ```

   Notez les résultats, en particulier les statistiques de buffers.

### Exemple de Résultat avec `shared_buffers` à 128 MB

```plaintext
Seq Scan on test_table  (cost=0.00..431.00 rows=10000 width=37) (actual time=0.031..4.258 rows=10000 loops=1)
  Buffers: shared hit=4 read=30
Planning Time: 0.145 ms
Execution Time: 4.529 ms
```

### Étape 3 : Configurer `shared_buffers` à 1 GB

1. **Modifier `postgresql.conf`**

   Ouvrez le fichier de configuration :

   ```bash
   sudo nano /etc/postgresql/14/main/postgresql.conf
   ```

   Modifiez ou ajoutez la ligne suivante :

   ```ini
   shared_buffers = '1GB'
   ```

2. **Recharger la Configuration**

   Rechargez PostgreSQL pour appliquer les changements :

   ```bash
   sudo systemctl reload postgresql
   ```

### Étape 4 : Exécuter `EXPLAIN ANALYZE` avec `shared_buffers` à 1 GB

1. **Exécuter à Nouveau `EXPLAIN ANALYZE`**

   Exécutez à nouveau la même requête avec `EXPLAIN ANALYZE` :

   ```sql
   EXPLAIN (ANALYZE, BUFFERS) SELECT * FROM test_table WHERE id = 1;
   ```

   Notez les résultats, en particulier les statistiques de buffers.

### Exemple de Résultat avec `shared_buffers` à 1 GB

```plaintext
Seq Scan on test_table  (cost=0.00..431.00 rows=10000 width=37) (actual time=0.020..3.850 rows=10000 loops=1)
  Buffers: shared hit=34 read=0
Planning Time: 0.120 ms
Execution Time: 3.960 ms
```

### Analyse des Résultats

Comparez les résultats obtenus avec `shared_buffers` à 128 MB et à 1 GB :

1. **hit** : Une augmentation des `hit` indique que plus de pages sont trouvées dans le cache, ce qui signifie une meilleure utilisation des buffers.
2. **read** : Une diminution des `read` indique que moins de pages doivent être lues à partir du disque, ce qui améliore les performances.


Pour générer une requête lente et observer ses statistiques à l'aide de `pg_stat_statements`, suivez les étapes suivantes :

### Étape 1 : Activer l'extension `pg_stat_statements`

1. **Modifier le fichier `postgresql.conf`** :

    Ajoutez ou modifiez les lignes suivantes dans `postgresql.conf` pour activer `pg_stat_statements` :

    ```conf
    shared_preload_libraries = 'pg_stat_statements'
    pg_stat_statements.track = all
    ```

2. **Redémarrer PostgreSQL** pour appliquer les modifications :

    ```bash
    sudo systemctl restart postgresql
    ```

3. **Créer l'extension** dans votre base de données :

    ```sql
    CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
    ```

### Étape 2 : Créer une table et insérer des données

1. **Créer une table** :

    ```sql
    CREATE TABLE demo_large_table (
        id SERIAL PRIMARY KEY,
        data TEXT
    );
    ```

2. **Insérer un grand nombre de lignes** :

    ```sql
    INSERT INTO demo_large_table (data)
    SELECT md5(random()::text)
    FROM generate_series(1, 1000000);
    ```

### Étape 3 : Exécuter une requête lente

1. **Exécuter une requête lente** :

    ```sql
    SELECT *
    FROM demo_large_table
    WHERE data LIKE '%abc%';
    ```

### Étape 4 : Observer les statistiques avec `pg_stat_statements`

1. **Interroger `pg_stat_statements`** :

    Après avoir exécuté la requête lente, utilisez la vue `pg_stat_statements` pour observer les statistiques des requêtes :

    ```sql
    SELECT
        query,
        calls,
        total_exec_time AS total_time,
        mean_exec_time AS mean_time,
        min_exec_time AS min_time,
        max_exec_time AS max_time,
        stddev_exec_time AS stddev_time
    FROM
        pg_stat_statements
    WHERE
        query LIKE '%demo_large_table%'
    ORDER BY
        total_exec_time DESC
    LIMIT 10;
    ```

### Exemple Complet

Voici un script complet que vous pouvez utiliser :

1. **Activer `pg_stat_statements` (si ce n'est pas déjà fait)** :

    ```sql
    CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
    ```

2. **Créer et peupler une table** :

    ```sql
    CREATE TABLE demo_large_table (
        id SERIAL PRIMARY KEY,
        data TEXT
    );

    INSERT INTO demo_large_table (data)
    SELECT md5(random()::text)
    FROM generate_series(1, 1000000);
    ```

3. **Exécuter une requête lente** :

    ```sql
    SELECT *
    FROM demo_large_table
    WHERE data LIKE '%abc%';
    ```

4. **Observer les statistiques** :

    ```sql
    SELECT
        query,
        calls,
        total_exec_time AS total_time,
        mean_exec_time AS mean_time,
        min_exec_time AS min_time,
        max_exec_time AS max_time,
        stddev_exec_time AS stddev_time
    FROM
        pg_stat_statements
    WHERE
        query LIKE '%demo_large_table%'
    ORDER BY
        total_exec_time DESC
    LIMIT 10;
    ```

En suivant ces étapes, vous pourrez observer les statistiques de votre requête lente grâce à `pg_stat_statements`.
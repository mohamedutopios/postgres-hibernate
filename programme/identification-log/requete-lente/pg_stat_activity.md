Pour générer une requête qui dure plus d'une minute, nous pouvons créer une requête qui effectue une opération intensive sur une grande table. Voici un exemple de comment vous pouvez le faire :

### Étapes pour créer une requête longue

1. **Créer une table et insérer des données** :
   - Nous allons créer une table avec un grand nombre de lignes.
   - Ensuite, nous allons exécuter une requête complexe qui prendra du temps.

### Exemple Complet

1. **Créer une table avec un grand nombre de lignes** :

    ```sql
    CREATE TABLE demo_large_table (
        id SERIAL PRIMARY KEY,
        data TEXT
    );

    INSERT INTO demo_large_table (data)
    SELECT md5(random()::text)
    FROM generate_series(1, 10000000);
    ```

    Cette requête crée une table `demo_large_table` et insère 10 millions de lignes avec des données aléatoires.

2. **Exécuter une requête qui prend du temps** :

    Nous allons exécuter une requête qui effectue une opération intensive. Par exemple, une recherche de motif avec `LIKE` sur une grande table sans index sur la colonne `data`.

    ```sql
    SELECT count(*)
    FROM demo_large_table
    WHERE data LIKE '%abc%';
    ```

    Cette requête scanne toute la table pour rechercher les occurrences de `'abc'` dans la colonne `data`, ce qui devrait prendre plus d'une minute sur une grande table.

### Vérification avec `pg_stat_activity`

1. **Exécuter la requête longue** :

    Dans une session SQL, exécutez la requête ci-dessus :

    ```sql
    SELECT count(*)
    FROM demo_large_table
    WHERE data LIKE '%abc%';
    ```

2. **Surveiller les requêtes longues avec `pg_stat_activity`** :

    Dans une autre session SQL, exécutez la requête suivante pour vérifier les requêtes en cours d'exécution depuis plus d'une minute :

    ```sql
    SELECT 
        pid, 
        now() - pg_stat_activity.query_start AS duration, 
        query, 
        state
    FROM 
        pg_stat_activity
    WHERE 
        (now() - pg_stat_activity.query_start) > interval '1 minute'
        AND state = 'active'
    ORDER BY 
        duration DESC;
    ```

### Exemple Complet de Génération et Surveillance

Voici le script complet pour générer une requête longue et la surveiller :

1. **Créer et insérer des données** :

    ```sql
    CREATE TABLE demo_large_table (
        id SERIAL PRIMARY KEY,
        data TEXT
    );

    INSERT INTO demo_large_table (data)
    SELECT md5(random()::text)
    FROM generate_series(1, 10000000);
    ```

2. **Exécuter une requête longue** :

    ```sql
    SELECT count(*)
    FROM demo_large_table
    WHERE data LIKE '%abc%';
    ```

3. **Surveiller les requêtes longues** :

    ```sql
    SELECT 
        pid, 
        now() - pg_stat_activity.query_start AS duration, 
        query, 
        state
    FROM 
        pg_stat_activity
    WHERE 
        (now() - pg_stat_activity.query_start) > interval '1 minute'
        AND state = 'active'
    ORDER BY 
        duration DESC;
    ```

En utilisant cette approche, vous pouvez générer une requête qui dure plus d'une minute et utiliser `pg_stat_activity` pour la surveiller et l'analyser.
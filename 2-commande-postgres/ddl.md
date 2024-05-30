Les commandes DDL (Data Definition Language) en PostgreSQL sont utilisées pour définir et gérer les structures de la base de données telles que les schémas, les tables, les index, les vues, etc. Voici une liste complète de commandes DDL avec des exemples :

### Commandes DDL pour PostgreSQL

#### 1. Créer une base de données

```sql
CREATE DATABASE nom_de_la_base;
```

#### 2. Supprimer une base de données

```sql
DROP DATABASE nom_de_la_base;
```

#### 3. Créer un schéma

```sql
CREATE SCHEMA nom_du_schéma;
```

#### 4. Supprimer un schéma

```sql
DROP SCHEMA nom_du_schéma [CASCADE];
```

#### 5. Créer une table

```sql
CREATE TABLE nom_de_la_table (
    id SERIAL PRIMARY KEY,
    nom_colonne1 TYPE1,
    nom_colonne2 TYPE2,
    ...
);
```

#### 6. Supprimer une table

```sql
DROP TABLE nom_de_la_table;
```

#### 7. Modifier une table

- Ajouter une colonne

```sql
ALTER TABLE nom_de_la_table ADD COLUMN nom_colonne TYPE;
```

- Supprimer une colonne

```sql
ALTER TABLE nom_de_la_table DROP COLUMN nom_colonne;
```

- Modifier le type d'une colonne

```sql
ALTER TABLE nom_de_la_table ALTER COLUMN nom_colonne TYPE nouveau_type;
```

- Renommer une colonne

```sql
ALTER TABLE nom_de_la_table RENAME COLUMN ancienne_colonne TO nouvelle_colonne;
```

- Renommer une table

```sql
ALTER TABLE ancienne_table RENAME TO nouvelle_table;
```

#### 8. Créer un index

```sql
CREATE INDEX nom_de_l_index ON nom_de_la_table (nom_colonne);
```

#### 9. Supprimer un index

```sql
DROP INDEX nom_de_l_index;
```

#### 10. Créer une vue

```sql
CREATE VIEW nom_de_la_vue AS
SELECT colonne1, colonne2, ...
FROM nom_de_la_table
WHERE condition;
```

#### 11. Supprimer une vue

```sql
DROP VIEW nom_de_la_vue;
```

#### 12. Créer une séquence

```sql
CREATE SEQUENCE nom_de_la_sequence
START WITH valeur_initiale
INCREMENT BY increment
NO MINVALUE
NO MAXVALUE
CACHE 1;
```

#### 13. Supprimer une séquence

```sql
DROP SEQUENCE nom_de_la_sequence;
```

#### 14. Créer une fonction

```sql
CREATE FUNCTION nom_de_la_fonction(paramètres) RETURNS type_retour AS $$
BEGIN
    -- Corps de la fonction
END;
$$ LANGUAGE plpgsql;
```

#### 15. Supprimer une fonction

```sql
DROP FUNCTION nom_de_la_fonction(paramètres);
```

### Exemple complet d'utilisation

```sql
-- Créer une base de données
CREATE DATABASE exemple_db;

-- Se connecter à la base de données
\c exemple_db

-- Créer un schéma
CREATE SCHEMA exemple_schema;

-- Créer une table dans le schéma
CREATE TABLE exemple_schema.utilisateurs (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

SELECT *
FROM information_schema.tables
WHERE table_schema = 'public';

-- Ajouter une colonne à la table
ALTER TABLE exemple_schema.utilisateurs ADD COLUMN age INT;

-- Créer un index sur la colonne email
CREATE INDEX idx_email ON exemple_schema.utilisateurs (email);

-- Créer une vue
CREATE VIEW exemple_schema.vue_utilisateurs AS
SELECT nom, email FROM exemple_schema.utilisateurs WHERE age > 18;

-- Supprimer une vue
DROP VIEW exemple_schema.vue_utilisateurs;

-- Supprimer un index
DROP INDEX idx_email;

-- Supprimer une table
DROP TABLE exemple_schema.utilisateurs;

-- Supprimer un schéma
DROP SCHEMA exemple_schema CASCADE;

-- Supprimer une base de données
DROP DATABASE exemple_db;
```

Ces commandes couvrent une grande partie des opérations DDL que vous pouvez effectuer dans PostgreSQL. Vous pouvez les utiliser pour créer, modifier et supprimer des structures de base de données selon vos besoins.
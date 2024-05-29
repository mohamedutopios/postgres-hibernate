Les commandes DML (Data Manipulation Language) en PostgreSQL sont utilisées pour manipuler les données dans les tables de la base de données. Voici une liste des principales commandes DML avec des exemples pour chaque commande :

### Commandes DML pour PostgreSQL

#### 1. INSERT
La commande `INSERT` est utilisée pour insérer des données dans une table.

```sql
INSERT INTO nom_de_la_table (colonne1, colonne2, ...) VALUES (valeur1, valeur2, ...);
```

Exemple :

```sql
INSERT INTO utilisateurs (nom, email, age) VALUES ('Alice', 'alice@example.com', 30);
```

#### 2. UPDATE
La commande `UPDATE` est utilisée pour mettre à jour les données existantes dans une table.

```sql
UPDATE nom_de_la_table SET colonne1 = valeur1, colonne2 = valeur2, ... WHERE condition;
```

Exemple :

```sql
UPDATE utilisateurs SET age = 31 WHERE nom = 'Alice';
```

#### 3. DELETE
La commande `DELETE` est utilisée pour supprimer des lignes d'une table.

```sql
DELETE FROM nom_de_la_table WHERE condition;
```

Exemple :

```sql
DELETE FROM utilisateurs WHERE nom = 'Alice';
```

#### 4. SELECT
La commande `SELECT` est utilisée pour récupérer des données à partir d'une table.

```sql
SELECT colonne1, colonne2, ... FROM nom_de_la_table WHERE condition;
```

Exemple :

```sql
SELECT nom, email FROM utilisateurs WHERE age > 25;
```

#### 5. INSERT ... ON CONFLICT (UPSERT)
La commande `INSERT ... ON CONFLICT` est utilisée pour insérer des données et gérer les conflits (par exemple, les doublons) en mettant à jour les données existantes.

```sql
INSERT INTO nom_de_la_table (colonne1, colonne2, ...)
VALUES (valeur1, valeur2, ...)
ON CONFLICT (colonne_unique)
DO UPDATE SET colonne1 = valeur1, colonne2 = valeur2;
```

Exemple :

```sql
INSERT INTO utilisateurs (id, nom, email, age)
VALUES (1, 'Bob', 'bob@example.com', 28)
ON CONFLICT (id)
DO UPDATE SET nom = EXCLUDED.nom, email = EXCLUDED.email, age = EXCLUDED.age;
```

### Exemples complets

#### INSERT

```sql
-- Insérer une nouvelle ligne dans la table utilisateurs
INSERT INTO utilisateurs (nom, email, age) VALUES ('Alice', 'alice@example.com', 30);

-- Insérer plusieurs lignes à la fois
INSERT INTO utilisateurs (nom, email, age) VALUES 
('Bob', 'bob@example.com', 28),
('Charlie', 'charlie@example.com', 25);
```

#### UPDATE

```sql
-- Mettre à jour l'âge d'un utilisateur spécifique
UPDATE utilisateurs SET age = 31 WHERE nom = 'Alice';

-- Mettre à jour l'email pour plusieurs utilisateurs
UPDATE utilisateurs SET email = 'nouveau_email@example.com' WHERE age > 30;
```

#### DELETE

```sql
-- Supprimer un utilisateur spécifique
DELETE FROM utilisateurs WHERE nom = 'Alice';

-- Supprimer tous les utilisateurs de moins de 25 ans
DELETE FROM utilisateurs WHERE age < 25;
```

#### SELECT

```sql
-- Sélectionner tous les utilisateurs
SELECT * FROM utilisateurs;

-- Sélectionner les noms et emails des utilisateurs de plus de 25 ans
SELECT nom, email FROM utilisateurs WHERE age > 25;

-- Sélectionner et trier les utilisateurs par âge
SELECT nom, age FROM utilisateurs ORDER BY age DESC;
```

#### INSERT ... ON CONFLICT (UPSERT)

```sql
-- Insérer un utilisateur ou mettre à jour les informations s'il existe déjà
INSERT INTO utilisateurs (id, nom, email, age)
VALUES (1, 'Bob', 'bob@example.com', 28)
ON CONFLICT (id)
DO UPDATE SET nom = EXCLUDED.nom, email = EXCLUDED.email, age = EXCLUDED.age;
```

Ces commandes DML vous permettent de manipuler les données dans votre base de données PostgreSQL de manière flexible et puissante, couvrant les opérations d'insertion, de mise à jour, de suppression et de sélection de données.
La mise en place de la scalabilité horizontale pour PostgreSQL implique l'ajout de plusieurs instances de base de données afin de répartir la charge de travail. Il existe plusieurs approches pour y parvenir, notamment la réplication, le sharding et l'utilisation de proxies. Voici un guide détaillé sur la mise en place de la scalabilité horizontale avec PostgreSQL :

### 1. Réplication

La réplication permet de copier les données d'un serveur principal vers plusieurs serveurs secondaires, répartissant ainsi la charge de lecture. Voici comment mettre en place une réplication asynchrone :

#### Configuration du Serveur Principal

1. **Configurer les paramètres de réplication** :
   Modifiez le fichier `postgresql.conf` pour activer la réplication :

   ```plaintext
   wal_level = replica
   max_wal_senders = 10
   wal_keep_segments = 64
   archive_mode = on
   archive_command = 'cp %p /var/lib/postgresql/12/archive/%f'
   ```

2. **Configurer les permissions de réplication** :
   Ajoutez une entrée au fichier `pg_hba.conf` pour permettre aux serveurs secondaires de se connecter pour la réplication :

   ```plaintext
   host replication replicator 192.168.1.0/24 md5
   ```

3. **Créer un utilisateur de réplication** :

   ```sql
   CREATE ROLE replicator WITH REPLICATION LOGIN PASSWORD 'replicator_password';
   ```

4. **Redémarrer le serveur principal** :

   ```bash
   sudo systemctl restart postgresql
   ```

#### Configuration des Serveurs Secondaires

1. **Synchroniser les données du serveur principal** :
   Utilisez `pg_basebackup` pour initialiser le serveur secondaire :

   ```bash
   pg_basebackup -h 192.168.1.1 -D /var/lib/postgresql/12/main -U replicator -v -P --wal-method=stream
   ```

2. **Configurer la réplication** :
   Créez un fichier `recovery.conf` (ou utilisez `postgresql.auto.conf` dans les versions récentes) dans le répertoire de données du serveur secondaire :

   ```plaintext
   standby_mode = 'on'
   primary_conninfo = 'host=192.168.1.1 port=5432 user=replicator password=replicator_password'
   trigger_file = '/tmp/postgresql.trigger.5432'
   ```

3. **Redémarrer le serveur secondaire** :

   ```bash
   sudo systemctl start postgresql
   ```

### 2. Sharding

Le sharding consiste à diviser les données entre plusieurs bases de données pour répartir la charge d'écriture et de lecture. PostgreSQL n'a pas de sharding natif, mais vous pouvez utiliser des outils comme **Citus** pour cette fonctionnalité.

#### Utilisation de Citus pour le Sharding

1. **Installer Citus** :
   Suivez les instructions d'installation sur le [site officiel de Citus](https://www.citusdata.com/download/).

2. **Configurer un cluster Citus** :
   Configurez un cluster avec un nœud maître et plusieurs nœuds de travail.

3. **Créer des tables distribuées** :
   Connectez-vous au nœud maître et créez des tables distribuées :

   ```sql
   CREATE TABLE users (user_id bigint, name text, email text, created_at timestamp);
   SELECT create_distributed_table('users', 'user_id');
   ```

4. **Insérer et interroger des données** :
   Utilisez des requêtes SQL standard pour insérer et interroger des données sur le cluster Citus.

### 3. Utilisation de Proxies

Les proxies peuvent aider à équilibrer la charge entre plusieurs instances de PostgreSQL. **PgBouncer** et **HAProxy** sont des solutions populaires.

#### Configuration de PgBouncer

1. **Installer PgBouncer** :

   ```bash
   sudo apt-get install pgbouncer
   ```

2. **Configurer PgBouncer** :
   Modifiez le fichier `pgbouncer.ini` :

   ```ini
   [databases]
   yourdatabase = host=127.0.0.1 port=5432 dbname=yourdatabase

   [pgbouncer]
   listen_addr = *
   listen_port = 6432
   auth_type = md5
   auth_file = /etc/pgbouncer/userlist.txt
   ```

3. **Configurer les utilisateurs** :
   Ajoutez les utilisateurs au fichier `userlist.txt` :

   ```plaintext
   "username" "md5passwordhash"
   ```

4. **Démarrer PgBouncer** :

   ```bash
   sudo systemctl start pgbouncer
   ```

5. **Modifier les applications** :
   Configurez vos applications pour se connecter via PgBouncer au lieu de se connecter directement à PostgreSQL.

### 4. Démonstration de l'Intérêt

1. **Réplication** :
   - Amélioration de la tolérance aux pannes : Si le serveur principal tombe en panne, les serveurs secondaires peuvent prendre le relais.
   - Répartition de la charge de lecture : Les requêtes de lecture peuvent être dirigées vers les serveurs secondaires, réduisant la charge sur le serveur principal.

2. **Sharding** :
   - Répartition de la charge d'écriture : Chaque shard gère un sous-ensemble de données, ce qui permet de répartir la charge d'écriture.
   - Scalabilité horizontale : Ajoutez de nouveaux shards pour gérer des volumes de données croissants.

3. **Proxies** :
   - Équilibrage de charge : Distribue les connexions sur plusieurs serveurs, améliorant les performances globales.
   - Gestion de la connexion : PgBouncer réduit le coût de gestion des connexions, surtout pour les applications à forte demande de connexion.

En combinant ces techniques, vous pouvez créer une architecture PostgreSQL évolutive et résiliente, capable de gérer des charges de travail importantes et des volumes de données croissants.
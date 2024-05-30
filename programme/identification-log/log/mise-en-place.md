Il semble que la journalisation soit configurée pour envoyer les logs à un fichier unique au lieu d'un répertoire dédié avec des fichiers journaliers. Ce comportement peut se produire si la configuration a été ajustée ou si les paramètres par défaut n'ont pas été complètement modifiés.

Voici comment vous pouvez vérifier et ajuster la configuration pour utiliser le répertoire `pg_log` avec des fichiers journaliers :

### 1. Vérifiez la Configuration Actuelle

Ouvrez le fichier de configuration `postgresql.conf` pour vérifier les paramètres de journalisation actuels :

```bash
sudo nano /etc/postgresql/14/main/postgresql.conf
```

### 2. Assurez-vous que les Paramètres de Journalisation sont Corrects

Vérifiez les paramètres suivants dans `postgresql.conf` :

```ini
# Activer le collecteur de logs
logging_collector = on

# Spécifier le répertoire des logs (utilisez un chemin absolu ou relatif au répertoire de données)
log_directory = 'pg_log'

# Modèle de nom de fichier de log
log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'

# Quelle commande SQL enregistrer
log_statement = 'all'

# Durée des commandes SQL
log_duration = on

# Enregistrer les déclarations SQL qui prennent plus de 1 seconde
log_min_duration_statement = 1000

# Enregistrer les connexions et déconnexions
log_connections = on
log_disconnections = on
```

### 3. Créez le Répertoire de Logs

Assurez-vous que le répertoire de logs `pg_log` existe et que PostgreSQL a les permissions nécessaires pour y écrire :

```bash
sudo mkdir -p /var/lib/postgresql/14/main/pg_log
sudo chown postgres:postgres /var/lib/postgresql/14/main/pg_log
sudo chmod 700 /var/lib/postgresql/14/main/pg_log
```

### 4. Recharger ou Redémarrer PostgreSQL

Après avoir modifié `postgresql.conf`, rechargez la configuration ou redémarrez le serveur PostgreSQL pour appliquer les modifications.

#### Recharger la Configuration

```sql
SELECT pg_reload_conf();
```

Ou avec `pg_ctl` :

```bash
pg_ctl reload -D /var/lib/postgresql/14/main
```

Ou avec `systemctl` :

```bash
sudo systemctl reload postgresql
```

#### Redémarrer le Serveur (si nécessaire)

```bash
sudo systemctl restart postgresql
```

### 5. Vérifiez les Logs

Après avoir rechargé ou redémarré PostgreSQL, vérifiez si les logs sont créés dans le répertoire `pg_log` :

```bash
ls -l /var/lib/postgresql/14/main/pg_log

tail -f postgresql-2024-05-29_191541.log

```

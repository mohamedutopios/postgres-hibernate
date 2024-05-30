L'erreur `sudo: make: command not found` indique que l'utilitaire `make` n'est pas installé sur votre système. `make` est nécessaire pour compiler et installer `pgBadger`. Voici comment vous pouvez installer `make` et ensuite procéder à l'installation de `pgBadger`.

### Étape 1 : Installer `make` et les Outils de Compilation

Installez `make` ainsi que les outils de compilation nécessaires en utilisant `apt-get` :

```bash
sudo apt-get update
sudo apt-get install -y build-essential
```

Le paquet `build-essential` contient `make` ainsi que d'autres outils de compilation nécessaires.

### Étape 2 : Télécharger et Installer `pgBadger`

Une fois `make` installé, vous pouvez reprendre l'installation de `pgBadger`.

1. Téléchargez `pgBadger` depuis GitHub :

    ```bash
    cd /usr/local/src
    sudo wget https://github.com/darold/pgbadger/archive/refs/tags/v11.7.tar.gz -O pgbadger.tar.gz
    sudo tar xzf pgbadger.tar.gz
    cd pgbadger-11.7
    ```

2. Compilez et installez `pgBadger` :

    ```bash
    sudo perl Makefile.PL
    sudo make && sudo make install
    ```

### Étape 3 : Configurer la Journalisation de PostgreSQL

Si vous ne l'avez pas encore fait, configurez PostgreSQL pour générer des logs détaillés en modifiant le fichier `postgresql.conf` :

```bash
sudo nano /etc/postgresql/14/main/postgresql.conf
```

Ajoutez ou modifiez les paramètres suivants :

```ini
# Activer le collecteur de logs
logging_collector = on

# Spécifier le répertoire des logs
log_directory = 'pg_log'

# Modèle de nom de fichier de log
log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'

# Activer la journalisation des checkpoints
log_checkpoints = on

# Activer la journalisation des connexions et déconnexions
log_connections = on
log_disconnections = on

# Journaliser les instructions SQL
log_statement = 'all'

# Journaliser la durée des instructions SQL
log_duration = on
```

Rechargez ou redémarrez PostgreSQL pour appliquer les modifications :

```bash
sudo systemctl reload postgresql
```

### Étape 4 : Générer un Rapport avec `pgBadger`

Après avoir configuré PostgreSQL pour générer des logs détaillés et laissé tourner le système pendant un certain temps pour accumuler des données, vous pouvez utiliser `pgBadger` pour analyser les logs et générer un rapport.

Par exemple, pour analyser tous les logs dans le répertoire `pg_log` et générer un rapport HTML :

```bash
sudo pgbadger /var/lib/postgresql/14/main/pg_log/*.log -o /var/lib/postgresql/14/main/pgbadger_report.html
```

### Étape 5 : Visualiser le Rapport

Le rapport HTML généré peut être ouvert dans un navigateur web :

```bash
xdg-open /var/lib/postgresql/14/main/pgbadger_report.html
```

### Conclusion

En suivant ces étapes, vous pouvez installer les outils de compilation nécessaires (`make`), puis installer `pgBadger`, configurer PostgreSQL pour générer des logs détaillés, et utiliser `pgBadger` pour analyser ces logs et générer des rapports sur les performances des requêtes SQL. Cela vous aide à identifier les requêtes lentes, à surveiller l'activité de la base de données et à optimiser les performances globales du système.
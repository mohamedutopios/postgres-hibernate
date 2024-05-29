pgBadger est un outil d'analyse de logs PostgreSQL, qui génère des rapports détaillés sur les performances de votre base de données. Voici un exemple de la manière dont vous pouvez utiliser pgBadger pour analyser les logs de PostgreSQL :

1. **Installation de pgBadger** :
   Pour installer pgBadger, vous pouvez utiliser `cpan` ou télécharger directement le binaire. Voici comment l'installer avec `cpan` :

   ```sh
   sudo cpan install pgBadger
   ```

   Ou vous pouvez utiliser le package `deb` ou `rpm` si vous êtes sur un système Debian/Ubuntu ou Red Hat/CentOS.

2. **Configuration de PostgreSQL pour la journalisation** :
   Assurez-vous que votre fichier de configuration PostgreSQL (`postgresql.conf`) est configuré pour enregistrer les logs dans un format compréhensible par pgBadger. Voici quelques paramètres de configuration importants :

   ```conf
   logging_collector = on
   log_directory = 'pg_log'
   log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'
   log_statement = 'all'
   log_duration = on
   log_line_prefix = '%t [%p]: [%l-1] user=%u,db=%d,app=%a,client=%h '
   ```

3. **Génération du rapport avec pgBadger** :
   Une fois que PostgreSQL génère des logs, vous pouvez exécuter pgBadger pour analyser ces logs et générer un rapport HTML. Par exemple :

   ```sh
   pgbadger /path/to/your/logfile.log -o /path/to/output/report.html
   ```

   Voici un exemple plus complet avec plusieurs options :

   ```sh
   pgbadger -f stderr -p '%t [%p]: [%l-1] user=%u,db=%d,app=%a,client=%h ' /var/log/postgresql/postgresql-*.log -o /var/www/html/pg_reports/summary.html
   ```

   - `-f stderr` : Spécifie le format de log utilisé par PostgreSQL.
   - `-p` : Spécifie le préfixe de ligne de log configuré dans `postgresql.conf`.
   - `/var/log/postgresql/postgresql-*.log` : Chemin vers les fichiers de logs PostgreSQL.
   - `-o /var/www/html/pg_reports/summary.html` : Spécifie le fichier de sortie HTML.

4. **Accès au rapport** :
   Une fois le rapport généré, vous pouvez l'ouvrir dans un navigateur web pour visualiser les détails sur les performances de votre base de données. Le rapport inclura des informations comme le temps d'exécution des requêtes, les erreurs, les statistiques sur les connexions, et bien plus encore.

Voici un exemple de la commande complète et de la sortie attendue :

```sh
pgbadger -f stderr -p '%t [%p]: [%l-1] user=%u,db=%d,app=%a,client=%h ' /var/log/postgresql/postgresql-*.log -o /var/www/html/pg_reports/summary.html
```

Sortie attendue (sous forme de rapport HTML accessible via navigateur) :

![Exemple de rapport pgBadger](https://pgbadger.darold.net/images/pgbadger_v10_dashboard.png)

Ce rapport vous fournira une vue détaillée et intuitive des performances de votre base de données PostgreSQL, ce qui vous permettra d'identifier et de résoudre les problèmes de manière efficace.
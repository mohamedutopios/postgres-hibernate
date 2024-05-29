Voici une liste complète des commandes `psql`, l'interface en ligne de commande de PostgreSQL, avec une brève description pour chacune :

### Commandes de base
- **\c[onnect] [base de données] [utilisateur] [hôte] [port]** : Connecte à une nouvelle base de données.
- **\q** : Quitte `psql`.
- **\l** ou **\list** : Liste toutes les bases de données.
- **\dt** : Affiche les tables de la base de données actuelle.
- **\d [nom_table]** : Affiche la structure de la table spécifiée.
- **\du** ou **\list users** : Liste tous les rôles/utilisateurs.

### Commandes d'information
- **\d[S+] [objet]** : Affiche la description de l'objet spécifié (table, vue, séquence, index, etc.).
- **\dp [pattern]** : Affiche les privilèges d'accès.
- **\df [pattern]** : Liste les fonctions.
- **\dv [pattern]** : Liste les vues.
- **\di [pattern]** : Liste les index.
- **\ds [pattern]** : Liste les séquences.
- **\dn [pattern]** : Liste les schémas.
- **\dD [pattern]** : Liste les domaines.
- **\dT [pattern]** : Liste les types de données.
- **\dL [pattern]** : Liste les grands objets.
- **\dx** : Liste les extensions installées.

### Commandes de métadonnées
- **\df+ [pattern]** : Affiche plus d'informations sur les fonctions.
- **\d+ [nom_table]** : Affiche plus d'informations sur la table spécifiée.
- **\l+** : Affiche plus d'informations sur les bases de données.

### Commandes de manipulation
- **\e [fichier]** : Ouvre l'éditeur de texte pour éditer la commande en cours.
- **\i [fichier]** : Exécute les commandes dans le fichier spécifié.
- **\g** : Exécute la commande précédente.
- **\r** : Annule la commande en cours.

### Commandes de formatage
- **\x [on|off|auto]** : Active/désactive le mode étendu.
- **\a** : Active/désactive l'affichage sans alignement.
- **\H** : Active/désactive l'affichage HTML.
- **\t** : Active/désactive l'affichage des en-têtes et des pieds de page.
- **\pset [paramètre] [valeur]** : Définit les options de formatage de l'affichage.
  - Exemples :
    - `\pset border 2` : Définit le bord du tableau.
    - `\pset null '[NULL]'` : Définit la valeur affichée pour NULL.
    - `\pset format aligned|unaligned|wrapped|html|latex|troff-ms|markdown` : Définit le format de sortie.

### Commandes de transaction
- **BEGIN** ou **START TRANSACTION** : Commence une nouvelle transaction.
- **COMMIT** : Valide la transaction en cours.
- **ROLLBACK** : Annule la transaction en cours.
- **SAVEPOINT [nom]** : Définit un point de sauvegarde dans la transaction.
- **RELEASE SAVEPOINT [nom]** : Libère le point de sauvegarde spécifié.
- **ROLLBACK TO SAVEPOINT [nom]** : Restaure à l'état du point de sauvegarde spécifié.

### Autres commandes utiles
- **\echo [message]** : Affiche un message à l'écran.
- **\conninfo** : Affiche les informations sur la connexion actuelle.
- **\password [nom_utilisateur]** : Change le mot de passe pour le rôle spécifié.
- **\! [commande_shell]** : Exécute une commande shell.

### Commandes de script
- **\set [nom] [valeur]** : Définit une variable.
- **\unset [nom]** : Supprime une variable.
- **\if [expression]** ... **\elif [expression]** ... **\else** ... **\endif** : Commandes de condition pour les scripts.

### Commandes de copie
- **\copy [table] TO/FROM [fichier]** : Copie les données entre une table et un fichier.
- **COPY [table] TO/FROM [fichier]** : Version SQL de la commande précédente.

Ces commandes vous permettront d'interagir efficacement avec PostgreSQL via `psql`. Pour obtenir plus de détails sur chaque commande, vous pouvez utiliser la commande `\?` dans `psql`, qui affichera l'aide intégrée.
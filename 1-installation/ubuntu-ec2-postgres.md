- sudo apt update
- sudo apt install postgresql postgresql-contrib
- sudo systemctl start postgresql.service
- sudo -i -u postgres
- psql
- \password postgres
- \q


---

Pour vous connecter à un serveur PostgreSQL sur une instance EC2 en utilisant pgAdmin, suivez ces étapes :

### Pré-requis

1. **Instance EC2 avec PostgreSQL installé** : Assurez-vous que votre instance EC2 exécute PostgreSQL et que le serveur est configuré pour accepter les connexions externes.
2. **pgAdmin installé** : Vous devez avoir pgAdmin installé sur votre machine locale.

### Étapes

#### 1. Configurer PostgreSQL pour accepter les connexions externes

1. **Modifier le fichier `postgresql.conf`** :
    - Localisez le fichier `postgresql.conf` sur votre instance EC2. Il est généralement situé dans le répertoire `/etc/postgresql/<version>/main/` ou `/var/lib/pgsql/<version>/data/`.
    - Recherchez la ligne `listen_addresses` et modifiez-la pour écouter toutes les adresses IP :
      ```conf
      listen_addresses = '*'
      ```

2. **Modifier le fichier `pg_hba.conf`** :
    - Localisez le fichier `pg_hba.conf` dans le même répertoire que `postgresql.conf`.
    - Ajoutez une ligne pour permettre les connexions depuis n'importe quelle adresse IP (ou restreignez-la à votre IP publique pour plus de sécurité) :
      ```conf
      host    all             all             0.0.0.0/0               md5
      ```

3. **Redémarrer PostgreSQL** :
    - Redémarrez le service PostgreSQL pour appliquer les modifications :
      ```sh
      sudo systemctl restart postgresql
      ```

#### 2. Configurer le groupe de sécurité AWS

1. **Modifier le groupe de sécurité de l'instance EC2** :
    - Accédez à la console de gestion AWS EC2.
    - Sélectionnez votre instance EC2 et cliquez sur le groupe de sécurité associé.
    - Ajoutez une règle d'entrée pour autoriser le trafic entrant sur le port PostgreSQL (par défaut 5432) depuis l'adresse IP de votre machine locale :
      ```plaintext
      Type: Custom TCP
      Protocol: TCP
      Port Range: 5432
      Source: Your_IP_Address/32
      ```

#### 3. Connecter pgAdmin à PostgreSQL

1. **Ouvrir pgAdmin** :
    - Lancez pgAdmin sur votre machine locale.

2. **Ajouter un nouveau serveur** :
    - Cliquez sur "Add New Server" dans pgAdmin.

3. **Configurer les paramètres de connexion** :
    - Dans l'onglet "General", donnez un nom à votre serveur.
    - Dans l'onglet "Connection", entrez les détails suivants :
      - **Host name/address** : L'adresse publique de votre instance EC2.
      - **Port** : 5432 (ou le port que vous utilisez pour PostgreSQL).
      - **Maintenance database** : `postgres` (ou votre base de données par défaut).
      - **Username** : Votre nom d'utilisateur PostgreSQL.
      - **Password** : Votre mot de passe PostgreSQL.

4. **Sauvegarder et connecter** :
    - Cliquez sur "Save" pour enregistrer les paramètres et vous connecter au serveur PostgreSQL.

Si toutes les configurations sont correctes, vous devriez être en mesure de vous connecter à votre instance PostgreSQL sur EC2 depuis pgAdmin.


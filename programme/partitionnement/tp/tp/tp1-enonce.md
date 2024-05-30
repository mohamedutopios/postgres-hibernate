### TP partition : 

1. Étape 1 : Renommer la table Invoice en Invoice_old

2. Étape 2 : Créer la table partitionnée Invoice avec la clé primaire incluant InvoiceDate

3. Étape 3 : Créer les partitions pour chaque année

4. Étape 4 : Insérer les enregistrements de Invoice_old dans la nouvelle table Invoice

5. Étape 5 : Vérifier les enregistrements dans les partitions. Vérification dans Invoice_2011

7. Vérification dans la table parent Invoice. Requête sur les enregistrements pour l'année 2011

8. Étape 6 : Tenter d’ajouter une facture avec une date en dehors des partitions existantes

9. Étape 7 : Ajouter une partition par défaut pour recevoir les enregistrements hors plage. Retenter l'insertion des factures de 2013






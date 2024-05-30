## TP divers indexation

#### Toujours avec la volonté d'améliorer les performances des différents appels à notre serveur de base de données, vous allez devoir rendre plus performants les opérations suivantes : 

- La récupération de l'identifiant de facture, le nom et prénom du client et le montant total de la facture pour chaque facture.

- On souhaite avoir le nombre de facture par identifiant client.

- Les factures inférieures à 10 euros ne sont pas intéressantes à traiter. On voudrait rendre ces appels pour les factures supérieurs à 10 euros plus performants.

- Souvent la recherche de facture par client demande aussi de récuperer les factures triées de la plus récente à la plus ancienne.

- On a aussi besoin très régulièrement d'obtenir les informations sur les factures pour un mois en particulier.




Pour chacune de ces opérations, on aura besoin de mesurer qu'il y a bien une amélioration en terme de temps de traitement. Une vérification avant et après sera nécéssaire.

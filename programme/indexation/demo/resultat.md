Les résultats que vous avez fournis montrent les plans d'exécution pour une requête exécutée sans index et avec index sur la table `employe`. Analysons ces résultats pour comprendre comment l'indexation a affecté les performances de la requête.

### Plan d'exécution sans index

```
Seq Scan on employe  (cost=0.00..21846.00 rows=99833 width=41) (actual time=0.011..156.570 rows=100000 loops=1)
  Filter: (departement_id = 5)
  Rows Removed by Filter: 900000
Planning Time: 0.238 ms
Execution Time: 218.766 ms
```

#### Explication du plan d'exécution sans index

- **Seq Scan on employe** : PostgreSQL effectue un "Sequential Scan" (scan séquentiel) de toute la table `employe`. Cela signifie que chaque ligne de la table est lue pour vérifier si elle satisfait la condition `departement_id = 5`.
- **cost=0.00..21846.00** : Le coût estimé pour exécuter le scan séquentiel. Le premier chiffre (0.00) est le coût initial, et le deuxième chiffre (21846.00) est le coût total estimé pour lire toutes les lignes de la table.
- **rows=99833** : Le nombre estimé de lignes qui satisferont la condition `departement_id = 5`.
- **width=41** : La largeur moyenne des lignes en octets.
- **actual time=0.011..156.570** : Le temps réel pris pour exécuter la requête. Le premier chiffre (0.011 ms) est le temps initial, et le deuxième chiffre (156.570 ms) est le temps total pour lire toutes les lignes.
- **rows=100000** : Le nombre réel de lignes retournées par la requête.
- **Rows Removed by Filter: 900000** : Le nombre de lignes éliminées par le filtre `departement_id = 5`. Cela signifie que 900000 lignes ne satisfaisaient pas la condition.
- **Planning Time: 0.238 ms** : Le temps pris pour planifier la requête.
- **Execution Time: 218.766 ms** : Le temps total pour exécuter la requête, y compris le temps de planification.

### Plan d'exécution avec index

```
Bitmap Heap Scan on employe  (cost=1114.13..11708.04 rows=99833 width=41) (actual time=5.810..89.999 rows=100000 loops=1)
  Recheck Cond: (departement_id = 5)
  Heap Blocks: exact=9346
  ->  Bitmap Index Scan on idx_employe_departement_id  (cost=0.00..1089.17 rows=99833 width=0) (actual time=4.275..4.276 rows=100000 loops=1)
        Index Cond: (departement_id = 5)
Planning Time: 0.232 ms
Execution Time: 151.908 ms
```

#### Explication du plan d'exécution avec index

- **Bitmap Heap Scan on employe** : PostgreSQL effectue un "Bitmap Heap Scan". Cela signifie que PostgreSQL utilise un index bitmap pour trouver les pages de la table qui contiennent les lignes satisfaisant la condition `departement_id = 5` avant de lire ces pages.
- **cost=1114.13..11708.04** : Le coût estimé pour exécuter le bitmap heap scan. Le premier chiffre (1114.13) est le coût initial, et le deuxième chiffre (11708.04) est le coût total estimé.
- **rows=99833** : Le nombre estimé de lignes qui satisferont la condition `departement_id = 5`.
- **width=41** : La largeur moyenne des lignes en octets.
- **actual time=5.810..89.999** : Le temps réel pris pour exécuter la requête. Le premier chiffre (5.810 ms) est le temps initial, et le deuxième chiffre (89.999 ms) est le temps total pour lire les lignes.
- **rows=100000** : Le nombre réel de lignes retournées par la requête.
- **Recheck Cond: (departement_id = 5)** : Condition de re-vérification pour s'assurer que les lignes retournées satisfont bien la condition.
- **Heap Blocks: exact=9346** : Nombre de blocs de la table effectivement lus.
- **-> Bitmap Index Scan on idx_employe_departement_id** : Cette ligne indique que PostgreSQL utilise un "Bitmap Index Scan" sur l'index `idx_employe_departement_id` pour trouver les lignes correspondantes.
- **cost=0.00..1089.17** : Le coût estimé pour exécuter le bitmap index scan. Le premier chiffre (0.00) est le coût initial, et le deuxième chiffre (1089.17) est le coût total estimé.
- **rows=99833** : Le nombre estimé de lignes correspondant à la condition `departement_id = 5`.
- **actual time=4.275..4.276** : Le temps réel pris pour exécuter le bitmap index scan. Le premier chiffre (4.275 ms) est le temps initial, et le deuxième chiffre (4.276 ms) est le temps total pour lire les index.
- **Index Cond: (departement_id = 5)** : Condition de l'index pour le scan.
- **Planning Time: 0.232 ms** : Le temps pris pour planifier la requête.
- **Execution Time: 151.908 ms** : Le temps total pour exécuter la requête, y compris le temps de planification.

### Comparaison des performances

- **Scan Séquentiel (sans index)** :
  - Le scan séquentiel lit chaque ligne de la table, ce qui est très inefficace pour les grandes tables.
  - **Execution Time: 218.766 ms**.

- **Bitmap Heap Scan (avec index)** :
  - Le bitmap heap scan utilise un index pour trouver les lignes pertinentes, ce qui réduit le nombre de pages de la table à lire.
  - **Execution Time: 151.908 ms**.

### Conclusion

L'utilisation de l'index a considérablement amélioré les performances de la requête. Le temps d'exécution a été réduit de 218.766 ms à 151.908 ms, montrant une réduction significative du coût de la requête grâce à l'indexation. L'indexation permet de réduire le nombre de lignes et de pages de la table que PostgreSQL doit lire, ce qui améliore l'efficacité et la rapidité des requêtes.
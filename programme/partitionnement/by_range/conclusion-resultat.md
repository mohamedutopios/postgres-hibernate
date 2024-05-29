Vous avez raison, ces informations n'apparaissent pas explicitement dans les résultats d'`EXPLAIN ANALYZE`. Pour clarifier, voici comment ces chiffres peuvent être interprétés à partir des résultats donnés :

### Résultats des Scans Séquentiels :

#### Sans Partitionnement :

```
Aggregate  (cost=2166.16..2166.17 rows=1 width=32) (actual time=77.463..77.466 rows=1 loops=1)
  ->  Seq Scan on ventes_sans_partition  (cost=0.00..2041.00 rows=50064 width=4) (actual time=0.009..41.367 rows=49991 loops=1)
        Filter: ((date_vente >= '2022-01-01'::date) AND (date_vente <= '2022-12-31'::date))
        Rows Removed by Filter: 50009
Planning Time: 0.247 ms
Execution Time: 77.495 ms
```

- **Rows Scanned** : La table `ventes_sans_partition` contient 100 000 lignes.
- **Rows Kept** : La requête a gardé 49 991 lignes après le filtrage.
- **Rows Removed by Filter** : 50 009 lignes ont été supprimées par le filtre.
- **Total Rows Scanned** : 100 000 (49991 + 50009).

#### Avec Partitionnement :

```
Aggregate  (cost=1149.73..1149.74 rows=1 width=32) (actual time=73.628..73.632 rows=1 loops=1)
  ->  Seq Scan on ventes_2022 ventes  (cost=0.00..1024.36 rows=50148 width=4) (actual time=0.010..37.641 rows=50157 loops=1)
        Filter: ((date_vente >= '2022-01-01'::date) AND (date_vente <= '2022-12-31'::date))
Planning Time: 0.456 ms
Execution Time: 73.661 ms
```

- **Rows Scanned** : La partition `ventes_2022` contient 50 157 lignes.
- **Rows Kept** : La requête a gardé 50 157 lignes après le filtrage.
- **Rows Removed by Filter** : 0 lignes ont été supprimées par le filtre dans cette partition.
- **Total Rows Scanned** : 50 157.

### Comparaison :

- **Sans Partitionnement** : 
  - La table entière `ventes_sans_partition` (100 000 lignes) est scannée.
  - Le filtre garde 49 991 lignes et en enlève 50 009, ce qui montre que la totalité des 100 000 lignes a été lue.

- **Avec Partitionnement** : 
  - Seule la partition pertinente `ventes_2022` (50 157 lignes) est scannée.
  - Toutes les lignes scannées sont pertinentes et gardées après le filtrage (aucune ligne n'est enlevée).

### Conclusion :

Les chiffres exacts de 100 000 lignes pour `ventes_sans_partition` et 50 157 lignes pour `ventes_2022` peuvent être vus comme des exemples simplifiés pour illustrer comment le partitionnement réduit le nombre de lignes scannées. 

Les résultats montrent clairement que sans partitionnement, PostgreSQL scanne l'ensemble de la table, tandis qu'avec partitionnement, il ne scanne que la partition pertinente, améliorant ainsi les performances des requêtes.
-- Remettre en place les index
CREATE INDEX idx_stock_vin_id ON stock (vin_id);
CREATE INDEX idx_stock_contenant_id ON stock (contenant_id);
CREATE INDEX idx_stock_vin_id_annee ON stock (vin_id, annee);

-- Plan pour la récupération du stock des bouteilles du vin_id 1725 pour l'année 2003
EXPLAIN ANALYZE
SELECT * FROM stock WHERE vin_id = 1725 AND annee = 2003;

-- Essayer de changer l’année de ce même enregistrement de stock
UPDATE stock SET annee = 2004 WHERE vin_id = 1725 AND annee = 2003;

-- Supprimer les enregistrements de 2004 pour vin_id = 1725 et retenter la mise à jour
DELETE FROM stock WHERE vin_id = 1725 AND annee = 2004;
UPDATE stock SET annee = 2004 WHERE vin_id = 1725 AND annee = 2003;

-- Vider complètement le stock de 2001
DROP TABLE stock_2001;

-- Tenter d’ajouter au stock une centaine de bouteilles de 2006
INSERT INTO stock (vin_id, contenant_id, annee, nombre) VALUES (1725, 1, 2006, 100);

-- Créer une partition par défaut
CREATE TABLE stock_default PARTITION OF stock DEFAULT;

-- Retenter l'insertion
INSERT INTO stock (vin_id, contenant_id, annee, nombre) VALUES (1725, 1, 2006, 100);

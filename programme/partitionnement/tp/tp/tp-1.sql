-- Étape 1 : Renommer la table Invoice en Invoice_old
ALTER TABLE Invoice RENAME TO Invoice_old;

-- Étape 2 : Créer la table partitionnée Invoice avec la clé primaire incluant InvoiceDate
CREATE TABLE Invoice (
    InvoiceId SERIAL,
    CustomerId INTEGER NOT NULL,
    InvoiceDate DATE NOT NULL,
    BillingAddress TEXT,
    BillingCity TEXT,
    BillingState TEXT,
    BillingCountry TEXT,
    BillingPostalCode TEXT,
    Total NUMERIC(10, 2) NOT NULL,
    PRIMARY KEY (InvoiceId, InvoiceDate)
) PARTITION BY RANGE (InvoiceDate);

-- Étape 3 : Créer les partitions pour chaque année
CREATE TABLE Invoice_2009 PARTITION OF Invoice
FOR VALUES FROM ('2009-01-01') TO ('2010-01-01');

CREATE TABLE Invoice_2010 PARTITION OF Invoice
FOR VALUES FROM ('2010-01-01') TO ('2011-01-01');

CREATE TABLE Invoice_2011 PARTITION OF Invoice
FOR VALUES FROM ('2011-01-01') TO ('2012-01-01');

CREATE TABLE Invoice_2012 PARTITION OF Invoice
FOR VALUES FROM ('2012-01-01') TO ('2013-01-01');

-- Étape 4 : Insérer les enregistrements de Invoice_old dans la nouvelle table Invoice
INSERT INTO Invoice (InvoiceId, CustomerId, InvoiceDate, BillingAddress, BillingCity, BillingState, BillingCountry, BillingPostalCode, Total)
SELECT InvoiceId, CustomerId, InvoiceDate, BillingAddress, BillingCity, BillingState, BillingCountry, BillingPostalCode, Total
FROM Invoice_old;


INSERT INTO "Invoice" (InvoiceId, CustomerId, InvoiceDate, BillingAddress, BillingCity, BillingState, BillingCountry, BillingPostalCode, Total)
SELECT "InvoiceId", "CustomerId", "InvoiceDate", "BillingAddress", "BillingCity", "BillingState", "BillingCountry", "BillingPostalCode", "Total"
FROM Invoice_old;

-- Étape 5 : Vérifier les enregistrements dans les partitions
-- Vérification dans Invoice_2011
SELECT * FROM Invoice_2011 LIMIT 10;

-- Vérification dans la table parent Invoice
SELECT * FROM ONLY Invoice LIMIT 10;

-- Requête sur les enregistrements pour l'année 2011
EXPLAIN ANALYZE
SELECT * FROM Invoice WHERE InvoiceDate BETWEEN '2011-01-01' AND '2011-12-31';

-- Étape 6 : Tenter d’ajouter une facture avec une date en dehors des partitions existantes
-- Cela échoue car il n'y a pas de partition pour 2013
INSERT INTO Invoice (CustomerId, InvoiceDate, BillingAddress, BillingCity, BillingState, BillingCountry, BillingPostalCode, Total)
VALUES (1, '2013-05-15', '123 Test St.', 'Test City', 'TS', 'Test Country', '12345', 20.00);

-- Étape 7 : Ajouter une partition par défaut pour recevoir les enregistrements hors plage
CREATE TABLE Invoice_default PARTITION OF Invoice DEFAULT;

-- Retenter l'insertion des factures de 2013
INSERT INTO Invoice (CustomerId, InvoiceDate, BillingAddress, BillingCity, BillingState, BillingCountry, BillingPostalCode, Total)
VALUES (1, '2013-05-15', '123 Test St.', 'Test City', 'TS', 'Test Country', '12345', 20.00);

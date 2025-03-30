--Veicolo con maggior cavalli e un solo proprietario --
SELECT v.* 
FROM veicolo v
LEFT JOIN proprietari_passati pp ON v.targa = pp.targa
WHERE pp.targa IS NULL
ORDER BY v.cavalli DESC
LIMIT 1;


-- Società con esattamente 2 veicoli passati --
SELECT s.partita_iva, COUNT(pp.targa) AS num_veicoli
FROM societa s
JOIN proprietari_passati pp ON s.id_proprietario = pp.id_proprietario
GROUP BY s.partita_iva
HAVING COUNT(pp.targa) = 2;


-- Veicoli da fabbriche con 3 modelli --
SELECT v.* 
FROM veicolo v
JOIN modello m ON v.modello = m.id_modello
WHERE m.fabbrica_di_produzione IN (
    SELECT fabbrica_di_produzione 
    FROM modello 
    GROUP BY fabbrica_di_produzione 
    HAVING COUNT(*) = 3
);


-- Veicoli con proprietario corrente anche passato --
SELECT v.* 
FROM veicolo v
WHERE EXISTS (
    SELECT 1 
    FROM proprietari_passati pp 
    WHERE pp.targa = v.targa 
    AND pp.id_proprietario = v.proprietario
);

-- Fabbrica con più veicoli elettrici --
SELECT f.nome, COUNT(*) AS num_elettrici
FROM veicolo v
JOIN modello m ON v.modello = m.id_modello
JOIN fabbrica f ON m.fabbrica_di_produzione = f.id_fabbrica
WHERE v.codice_combustibile = 'ELET'
GROUP BY f.nome
ORDER BY num_elettrici DESC
LIMIT 1;


--query che mi da la targa del veicolo, il proprietario corrente e tutti i proprietari passatti e le date di aquisto e vendita.
--serve per rapportare i dati prima di cancellare un veicolo
SELECT --Recupero del proprietario corrente, deve anche trovare se e' un privato o una societa'
    v.targa,
    p.id_proprietario,
    CASE
        WHEN pr.id_proprietario IS NOT NULL 
            THEN CONCAT('Privato CF ', pr.cf)
        WHEN s.id_proprietario IS NOT NULL 
            THEN CONCAT('Società P.IVA ', s.partita_iva)
    END AS proprietario,
    v.data AS data_acquisto,
    NULL AS data_vendita,
    'Ultimo proprietario' AS stato
FROM veicolo v
JOIN proprietario p ON v.proprietario = p.id_proprietario
LEFT JOIN privato pr ON p.id_proprietario = pr.id_proprietario
LEFT JOIN societa s ON p.id_proprietario = s.id_proprietario
WHERE v.targa = 'AA000BB'

UNION ALL

SELECT --Recupero dei proprietario correnti, deve anche trovare se sono dei privati o delle societa'
    pp.targa,
    pp.id_proprietario, 
    CASE
        WHEN pr.id_proprietario IS NOT NULL 
            THEN CONCAT('Rrivato CF ', pr.cf)
        WHEN s.id_proprietario IS NOT NULL 
            THEN CONCAT('Società IVA ', s.partita_iva)
    END AS proprietario,
    pp.data_acquisto,
    pp.data_vendita,
    'Ex proprietario' AS stato
FROM proprietari_passati pp
JOIN proprietario p ON pp.id_proprietario = p.id_proprietario
LEFT JOIN privato pr ON p.id_proprietario = pr.id_proprietario
LEFT JOIN societa s ON p.id_proprietario = s.id_proprietario
WHERE pp.targa = 'AA000BB'

ORDER BY data_acquisto DESC;


-- le query di inserimenti/cancellazione/aggiornamento

--inserimento e aggiornamento
--passagio di proprieta
WITH vecchio_proprietario AS (
    SELECT targa, proprietario, data 
    FROM veicolo 
    WHERE targa = 'AB123CD'
),
registrazione_storico AS (
    INSERT INTO proprietari_passati (targa, id_proprietario, data_acquisto, data_vendita)
    SELECT targa, proprietario, data, CURRENT_DATE 
    FROM vecchio_proprietario
)
UPDATE veicolo 
SET 
    proprietario = 78,
    data = CURRENT_DATE
WHERE targa = 'AB123CD';

--cancellazione
-- eliminare tutti i proprietari (privati e società) senza veicoli attuali o storici
DELETE FROM societa
WHERE id_proprietario IN (
    SELECT p.id_proprietario
    FROM proprietario p
    LEFT JOIN veicolo v ON p.id_proprietario = v.proprietario
    LEFT JOIN proprietari_passati pp ON p.id_proprietario = pp.id_proprietario
    WHERE v.targa IS NULL AND pp.targa IS NULL
);

DELETE FROM privato
WHERE id_proprietario IN (
    SELECT p.id_proprietario
    FROM proprietario p
    LEFT JOIN veicolo v ON p.id_proprietario = v.proprietario
    LEFT JOIN proprietari_passati pp ON p.id_proprietario = pp.id_proprietario
    WHERE v.targa IS NULL AND pp.targa IS NULL
);

DELETE FROM proprietario
WHERE id_proprietario NOT IN (
    SELECT id_proprietario FROM veicolo
    UNION
    SELECT id_proprietario FROM proprietari_passati
);

COMMIT;
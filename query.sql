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

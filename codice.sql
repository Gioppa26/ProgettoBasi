--CREZIONE DATABASE-
CREATE DATABASE "registro automobilistico"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LOCALE_PROVIDER = 'libc'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

--Creazione tabelle--
CREATE TABLE fabbrica (
    id_fabbrica INT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    numero_veicoli_prodotti INT DEFAULT 0
);

CREATE TABLE modello (
    id_modello INT PRIMARY KEY,
    nome_modello VARCHAR(50),
    numero_versioni INT NOT NULL CHECK (numero_versioni > 0),
    fabbrica_di_produzione INT NOT NULL,
    FOREIGN KEY (fabbrica_di_produzione) REFERENCES fabbrica(id_fabbrica)
);

CREATE TABLE combustibile (
    codice_combustibile VARCHAR(15) PRIMARY KEY,
    tipo_combustibile VARCHAR(20)
);

CREATE TABLE proprietario (
    id_proprietario INT PRIMARY KEY,
    indirizzo VARCHAR(255) NOT NULL
);

CREATE TABLE privato (
    id_proprietario INT PRIMARY KEY,
    cf VARCHAR(16) NOT NULL UNIQUE,
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    data_nascita DATE,
    FOREIGN KEY (id_proprietario) REFERENCES proprietario(id_proprietario)
);

CREATE TABLE societa (
    id_proprietario INT PRIMARY KEY,
    partita_iva VARCHAR(16) NOT NULL UNIQUE,
    FOREIGN KEY (id_proprietario) REFERENCES proprietario(id_proprietario)
);

CREATE TABLE veicolo (
    targa VARCHAR(10) PRIMARY KEY,
    cilindrata INT NOT NULL,
    cavalli INT NOT NULL,
    velocita INT NOT NULL,
    numero_posti INT NOT NULL,
    data_immatricolazione DATE NOT NULL,
    data DATE NOT NULL,
    modello INT NOT NULL,
    codice_combustibile VARCHAR(15) NOT NULL,
    proprietario INT NOT NULL,
    CHECK (
        (cilindrata >= 0) AND 
        (cavalli >= 0) AND 
        (velocita >= 0) AND 
        (numero_posti >= 0)
    ),
    FOREIGN KEY (modello) REFERENCES modello(id_modello),
    FOREIGN KEY (codice_combustibile) REFERENCES combustibile(codice_combustibile),
    FOREIGN KEY (proprietario) REFERENCES proprietario(id_proprietario)
);

CREATE TABLE automobile (
    targa VARCHAR(10) PRIMARY KEY,
    tipologia VARCHAR(20),
    FOREIGN KEY (targa) REFERENCES veicolo(targa)
);

CREATE TABLE ciclomotore (
    targa VARCHAR(10) PRIMARY KEY,
    bauletto BOOLEAN,
    FOREIGN KEY (targa) REFERENCES veicolo(targa)
);

CREATE TABLE camion (
    targa VARCHAR(10) PRIMARY KEY,
    numero_assi INT,
    FOREIGN KEY (targa) REFERENCES veicolo(targa)
);

CREATE TABLE rimorchio (
    targa VARCHAR(10) PRIMARY KEY,
    tipologia VARCHAR(20),
    carico INT,
    FOREIGN KEY (targa) REFERENCES veicolo(targa)
);

CREATE TABLE proprietari_passati (
    targa VARCHAR(10),
    id_proprietario INT,
    data_acquisto DATE NOT NULL,
    data_vendita DATE NOT NULL,
    PRIMARY KEY (targa, id_proprietario),
    CHECK (data_vendita > data_acquisto),
    FOREIGN KEY (targa) REFERENCES veicolo(targa),
    FOREIGN KEY (id_proprietario) REFERENCES proprietario(id_proprietario)
);

--Definizione trigger--
--controllo nr_veicoli_prodotti--
CREATE OR REPLACE FUNCTION aggiorna_conteggio_veicoli() 
RETURNS TRIGGER AS $$
BEGIN
    UPDATE fabbrica
    SET numero_veicoli_prodotti = numero_veicoli_prodotti + 1
    WHERE id_fabbrica = (
        SELECT fabbrica_di_produzione 
        FROM modello 
        WHERE id_modello = NEW.modello
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_conteggio_veicoli
AFTER INSERT ON veicolo
FOR EACH ROW EXECUTE FUNCTION aggiorna_conteggio_veicoli();

-------------------------------------------------------------------------------
-- Trigger per verificare mutua esclusione PRIVATO
CREATE OR REPLACE FUNCTION check_privato_mutua_esclusione()
RETURNS TRIGGER AS $$
BEGIN
    -- Verifica se esiste già in societa
    IF EXISTS (SELECT 1 FROM societa WHERE id_proprietario = NEW.id_proprietario) THEN
        RAISE EXCEPTION 'Mutua esclusione violata: ID % è già registrato come società', NEW.id_proprietario;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_privato
BEFORE INSERT OR UPDATE ON privato
FOR EACH ROW EXECUTE FUNCTION check_privato_mutua_esclusione();

-- Trigger per verificare mutua esclusione SOCIETA
CREATE OR REPLACE FUNCTION check_societa_mutua_esclusione()
RETURNS TRIGGER AS $$
BEGIN
    -- Verifica se esiste già in privato
    IF EXISTS (SELECT 1 FROM privato WHERE id_proprietario = NEW.id_proprietario) THEN
        RAISE EXCEPTION 'Mutua esclusione violata: ID % è già registrato come privato', NEW.id_proprietario;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_societa
BEFORE INSERT OR UPDATE ON societa
FOR EACH ROW EXECUTE FUNCTION check_societa_mutua_esclusione();

--Query--
--Il veicolo con il maggior numero di cavalli che ha avuto 1 e un solo proprietario.--
SELECT v.* 
FROM veicolo v
LEFT JOIN proprietari_passati pp ON v.targa = pp.targa
WHERE pp.targa IS NULL
ORDER BY v.cavalli DESC
LIMIT 1;

--Le società che è un proprietario passato di esattamente 2 veicoli--
SELECT s.partita_iva, COUNT(pp.targa) AS num_veicoli
FROM societa s
JOIN proprietari_passati pp ON s.id_proprietario = pp.id_proprietario
GROUP BY s.partita_iva
HAVING COUNT(pp.targa) = 2;

--Tutti i veicoli prodotti da fabbriche che hanno prodotto esattamente 3 modelli.--
SELECT v.* 
FROM veicolo v
JOIN modello m ON v.modello = m.id_modello
WHERE m.fabbrica_di_produzione IN (
    SELECT fabbrica_di_produzione 
    FROM modello 
    GROUP BY fabbrica_di_produzione 
    HAVING COUNT(*) = 3
);
--oppure--
SELECT V.targa
FROM veicolo AS V
JOIN modello AS M ON V.modello = M.id_modello
JOIN fabbrica AS F ON M.fabbrica_di_produzione = F.id_fabbrica
WHERE F.id_fabbrica IN (
    SELECT F2.id_fabbrica
    FROM fabbrica F2
    WHERE EXISTS (
        SELECT *
        FROM modello M2
        WHERE M2.fabbrica_di_produzione = F2.id_fabbrica
        AND EXISTS (
            SELECT *
            FROM modello M3
            WHERE M3.fabbrica_di_produzione = F2.id_fabbrica
            AND M3.id_modello <> M2.id_modello
            AND EXISTS (
                SELECT *
                FROM modello M4
                WHERE M4.fabbrica_di_produzione = F2.id_fabbrica
                AND M4.id_modello <> M2.id_modello
                AND M4.id_modello <> M3.id_modello
                AND NOT EXISTS (
                    SELECT *
                    FROM modello M5
                    WHERE M5.fabbrica_di_produzione = F2.id_fabbrica
                    AND M5.id_modello <> M2.id_modello
                    AND M5.id_modello <> M3.id_modello
                    AND M5.id_modello <> M4.id_modello
                )
            )
        )
    )
);

--Il numero dei veicoli in cui il proprietario corrente è anche un proprietario passato--
SELECT COUNT(*) AS numero_veicoli
FROM veicolo v
JOIN proprietari_passati pp ON v.targa = pp.targa
WHERE v.proprietario = pp.id_proprietario;

--La fabbrica con il massimo numero di veicoli elettrici.--
SELECT f.nome, COUNT(*) AS num_elettrici
FROM veicolo v
JOIN modello m ON v.modello = m.id_modello
JOIN fabbrica f ON m.fabbrica_di_produzione = f.id_fabbrica
WHERE v.codice_combustibile = 'ELET'
GROUP BY f.nome
ORDER BY num_elettrici DESC
LIMIT 1;
--oppure--
CREATE VIEW veicoli_elettrici_per_fabbrica AS (
  SELECT m.fabbrica_di_produzione, COUNT(v.targa) AS numero_veicoli_elettrici
  FROM veicolo v
  JOIN modello m ON v.modello = m.id_modello
  WHERE v.codice_combustibile = 'ELET'
  GROUP BY m.fabbrica_di_produzione
);
SELECT fabbrica.nome, numero_veicoli_elettrici
FROM veicoli_elettrici_per_fabbrica, fabbrica
WHERE fabbrica.id_fabbrica=fabbrica_di_produzione AND numero_veicoli_elettrici = (
  SELECT MAX(numero_veicoli_elettrici)
  FROM veicoli_elettrici_per_fabbrica
);

--Data una targa, cercare il veicolo o, il proprietario corrente (Cf se privato altrimenti IVA) e tutti i proprietari passatti (Cf se privati altrimenti IVA) e le date di aquisto e vendita. Servirebbe per rapportare i dati prima di cancellare un veicolo--
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
WHERE v.targa = 'GC908BT'

UNION ALL

SELECT --Recupero dei proprietario correnti, deve anche trovare se sono dei privati o delle societa'
    pp.targa,
    pp.id_proprietario, 
    CASE
        WHEN pr.id_proprietario IS NOT NULL 
            THEN CONCAT('Privato CF ', pr.cf)
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
WHERE pp.targa = 'GC908BT'

ORDER BY data_acquisto DESC;

--Query di inserimento/cancellazione/aggiornamento--
--Inserimento e aggiornamento: passagio di proprieta --
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

--Cancellazione: eliminare tutti i proprietari (privati e società) senza veicoli attuali o storici--
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
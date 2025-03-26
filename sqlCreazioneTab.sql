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



-- Trigger --
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



-------------------------------------------------------------------------------

-- inserimenti --
INSERT INTO fabbrica (id_fabbrica, nome, numero_veicoli_prodotti)
VALUES 
(1, 'mercedes', 0),
(2, 'audi', 0),
(3, 'bmw', 0),
(4, 'volswagen', 0),
(5, 'opel', 0);


INSERT INTO modello (id_modello, nome_modello, numero_versioni, fabbrica_di_produzione)
VALUES 
-- Mercedes
(1, 'Classe A', 3, 1),
(2, 'Classe C', 4, 1),
(3, 'GLE', 2, 1),

-- Audi
(4, 'A3', 3, 2),
(5, 'Q5', 2, 2),
(6, 'e-tron', 2, 2),

-- BMW
(7, 'Serie 3', 4, 3),
(8, 'X5', 3, 3),
(9, 'i4', 2, 3),

-- Volkswagen
(10, 'Golf', 5, 4),
(11, 'Tiguan', 3, 4),
(12, 'ID.4', 2, 4),

-- Opel
(13, 'Corsa', 3, 5),
(14, 'Astra', 2, 5),
(15, 'Mokka', 2, 5);



INSERT INTO combustibile (codice_combustibile, tipo_combustibile)
VALUES 
('BENZ', 'benzina'),
('DIES', 'diesel'),
('GPL', 'gpl'),
('ELET', 'elettrico'),
('MET', 'metano');


INSERT INTO proprietario (id_proprietario, indirizzo)
VALUES 
(1, 'Via Roma 123, Milano'),
(2, 'Corso Italia 45, Roma'),
(3, 'Piazza Garibaldi 7, Napoli'),
(4, 'Via Dante 89, Firenze'),
(5, 'Corso Vittorio Emanuele 56, Torino'),
(6, 'Via dei Mille 34, Bologna'),
(7, 'Piazza San Marco 12, Venezia'),
(8, 'Via XX Settembre 78, Genova'),
(9, 'Corso Umberto I 23, Palermo'),
(10, 'Via della Libertà 67, Bari'),
(11, 'Piazza del Duomo 9, Milano'),
(12, 'Via Nazionale 101, Roma'),
(13, 'Corso Garibaldi 55, Napoli'),
(14, 'Via dei Calzaiuoli 32, Firenze'),
(15, 'Piazza Castello 18, Torino'),
(16, 'Via Indipendenza 90, Bologna'),
(17, 'Fondamenta Nuove 43, Venezia'),
(18, 'Via Balbi 22, Genova'),
(19, 'Corso Calatafimi 76, Palermo'),
(20, 'Via Sparano 88, Bari'),
(21, 'Viale Monza 150, Milano'),
(22, 'Via Appia Nuova 200, Roma'),
(23, 'Corso Umberto I 111, Napoli'),
(24, 'Viale dei Colli 65, Firenze'),
(25, 'Corso Francia 87, Torino'),
(26, 'Via Rizzoli 40, Bologna'),
(27, 'Riva degli Schiavoni 15, Venezia'),
(28, 'Via Garibaldi 5, Genova'),
(29, 'Via Maqueda 180, Palermo'),
(30, 'Corso Vittorio Emanuele II 29, Bari');



INSERT INTO veicolo (targa, cilindrata, cavalli, velocita, numero_posti, data_immatricolazione, data, modello, codice_combustibile, proprietario)
VALUES 
('AA000BB', 1600, 120, 180, 5, '2022-01-15', '2022-02-01', 1, 'BENZ', 1),
('BB111CC', 2000, 150, 200, 5, '2021-11-20', '2021-12-05', 2, 'DIES', 2),
('CC222DD', 1400, 95, 170, 5, '2023-03-10', '2023-03-25', 3, 'GPL', 3),
('DD333EE', 1800, 140, 190, 5, '2022-07-05', '2022-07-20', 4, 'BENZ', 4),
('EE444FF', 2200, 180, 220, 5, '2021-09-30', '2021-10-15', 5, 'DIES', 5),
('FF555GG', 1200, 75, 160, 4, '2023-01-25', '2023-02-10', 6, 'BENZ', 6),
('GG666HH', 2500, 200, 230, 5, '2022-05-12', '2022-05-27', 7, 'DIES', 7),
('HH777II', 1600, 130, 185, 5, '2021-08-18', '2021-09-02', 8, 'GPL', 8),
('II888JJ', 1400, 100, 175, 5, '2023-04-05', '2023-04-20', 9, 'BENZ', 9),
('JJ999KK', 2000, 160, 210, 5, '2022-10-22', '2022-11-06', 10, 'DIES', 10),
('KK111LL', 1800, 145, 195, 5, '2021-12-30', '2022-01-14', 11, 'BENZ', 11),
('LL222MM', 1600, 125, 180, 5, '2023-02-28', '2023-03-15', 12, 'GPL', 12),
('MM333NN', 2200, 190, 225, 5, '2022-06-10', '2022-06-25', 13, 'DIES', 13),
('NN444OO', 1400, 90, 165, 4, '2021-10-05', '2021-10-20', 14, 'BENZ', 14),
('OO555PP', 2000, 155, 205, 5, '2023-05-15', '2023-05-30', 15, 'DIES', 15),
('PP666QQ', 1600, 135, 190, 5, '2022-08-20', '2022-09-04', 1, 'GPL', 16),
('QQ777RR', 1800, 150, 200, 5, '2021-11-25', '2021-12-10', 2, 'BENZ', 17),
('RR888SS', 2500, 210, 235, 5, '2023-01-05', '2023-01-20', 3, 'DIES', 18),
('SS999TT', 1200, 80, 155, 4, '2022-04-12', '2022-04-27', 4, 'BENZ', 19),
('TT111UU', 2000, 165, 215, 5, '2021-07-18', '2021-08-02', 5, 'GPL', 20),
('UU222VV', 1600, 130, 185, 5, '2023-03-22', '2023-04-06', 6, 'BENZ', 21),
('VV333WW', 2200, 185, 220, 5, '2022-09-30', '2022-10-15', 7, 'DIES', 22),
('WW444XX', 1400, 105, 170, 5, '2021-12-05', '2021-12-20', 8, 'BENZ', 23),
('XX555YY', 1800, 140, 195, 5, '2023-06-10', '2023-06-25', 9, 'GPL', 24),
('YY666ZZ', 2000, 160, 210, 5, '2022-02-15', '2022-03-02', 10, 'DIES', 25),
('ZZ777AA', 1600, 125, 180, 5, '2021-05-20', '2021-06-04', 11, 'BENZ', 26),
('AB123CD', 2500, 205, 230, 5, '2023-04-25', '2023-05-10', 12, 'DIES', 27),
('CD456EF', 1400, 95, 165, 4, '2022-11-30', '2022-12-15', 13, 'GPL', 28),
('EF789GH', 2000, 170, 220, 5, '2021-08-05', '2021-08-20', 14, 'BENZ', 29),
('GH012IJ', 1800, 145, 200, 5, '2023-01-10', '2023-01-25', 15, 'DIES', 30);

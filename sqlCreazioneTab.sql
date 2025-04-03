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

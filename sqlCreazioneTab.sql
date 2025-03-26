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
    codice_combustibile INT PRIMARY KEY,
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

CREATE TABLE veicolo (
    targa VARCHAR(10) PRIMARY KEY,
    cilindrata INT NOT NULL,
    cavalli INT NOT NULL,
    velocita INT NOT NULL,
    numero_posti INT NOT NULL,
    data_immatricolazione DATE NOT NULL,
    data_acquisto DATE NOT NULL,
    modello INT NOT NULL,
    codice_combustibile INT NOT NULL,
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
CREATE TABLE Fabbrica (
    idFabbrica INT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    numeroVeicoliProdotti INT DEFAULT 0
);

CREATE TABLE Modello (
    idModello INT PRIMARY KEY,
    nomeModello VARCHAR(50),
    numeroVersioni INT NOT NULL CHECK (numeroVersioni > 0),
    FabbricaDiProduzione INT NOT NULL,
    FOREIGN KEY (FabbricaDiProduzione) REFERENCES Fabbrica(idFabbrica)
);

CREATE TABLE Combustibile (
    codiceCombustibile INT PRIMARY KEY,
    tipoCombustibile VARCHAR(20)
);

CREATE TABLE Proprietario (
    IdProprietario INT PRIMARY KEY,
    indirizzo VARCHAR(255) NOT NULL
);

CREATE TABLE Privato (
    IdProprietario INT PRIMARY KEY,
    CF VARCHAR(16) NOT NULL UNIQUE,
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    dataNascita DATE,
    FOREIGN KEY (IdProprietario) REFERENCES Proprietario(IdProprietario)
);

CREATE TABLE Veicolo (
    Targa VARCHAR(10) PRIMARY KEY,
    cilindrata INT NOT NULL,
    cavalli INT NOT NULL,
    velocita INT NOT NULL,
    numeroPosti INT NOT NULL,
    dataImmatricolazione DATE NOT NULL,
    dataAcquisto DATE NOT NULL,
    Modello INT NOT NULL,
    CodiceCombustibile INT NOT NULL,
    Proprietario INT NOT NULL,
    CHECK (
        (cilindrata >= 0) AND 
        (cavalli >= 0) AND 
        (velocita >= 0) AND 
        (numeroPosti >= 0)
    ),
    FOREIGN KEY (Modello) REFERENCES Modello(idModello),
    FOREIGN KEY (CodiceCombustibile) REFERENCES Combustibile(codiceCombustibile),
    FOREIGN KEY (Proprietario) REFERENCES Proprietario(IdProprietario)
);

CREATE TABLE Automobile (
    Targa VARCHAR(10) PRIMARY KEY,
    tipologia VARCHAR(20),
    FOREIGN KEY (Targa) REFERENCES Veicolo(Targa)
);

CREATE TABLE Ciclomotore (
    Targa VARCHAR(10) PRIMARY KEY,
    bauletto BOOLEAN,
    FOREIGN KEY (Targa) REFERENCES Veicolo(Targa)
);

CREATE TABLE Camion (
    Targa VARCHAR(10) PRIMARY KEY,
    numeroAssi INT,
    FOREIGN KEY (Targa) REFERENCES Veicolo(Targa)
);

CREATE TABLE Rimorchio (
    Targa VARCHAR(10) PRIMARY KEY,
    tipologia VARCHAR(20),
    carico INT,
    FOREIGN KEY (Targa) REFERENCES Veicolo(Targa)
);

CREATE TABLE ProprietariPassati (
    Targa VARCHAR(10),
    IdProprietario INT,
    dataAcquisto DATE NOT NULL,
    dataVendita DATE NOT NULL,
    PRIMARY KEY (Targa, IdProprietario),
    CHECK (dataVendita > dataAcquisto),
    FOREIGN KEY (Targa) REFERENCES Veicolo(Targa),
    FOREIGN KEY (IdProprietario) REFERENCES Proprietario(IdProprietario)
);
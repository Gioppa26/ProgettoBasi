# Relazione Progetto Basi di Dati
## Consegna
- Si progetti uno schema entità/relazioni per la gestione di un registro automobilistico, facente parte del sistema informativo di un ufficio di motorizzazione, contenente le seguenti informazioni:
- di ciascun veicolo interessa registrare la targa, la cilindrata, i cavalli fiscali, la velocità, il numero di posti e la data di immatricolazione;
- i veicoli sono classificati in categorie (automobili, ciclomotori, camion, rimorchi, ecc.);
- ciascun veicolo appartiene ad uno specifico modello;
- tra i dati relativi ai veicoli, vi è la codifica del tipo di combustibile utilizzato;
- di ciascun modello di veicolo è registrata la fabbrica di produzione e il numero delle versioni prodotte;
- ciascun veicolo può avere uno o più proprietari, che si succedono nel corso della “vita” del veicolo; di ciascun proprietario interessa registrare cognome, nome e indirizzo di residenza.<br>

Lo schema entità/relazioni dovrà essere completato con attributi "ragionevoli" per ciascuna entità, identificando le possibili chiavi e le relazioni necessarie per la gestione del sistema in esame.
A partire dallo schema entità/relazioni, si costruisca il corrispondente schema relazionale.<br>

## GLOSSARIO Termini
- **Registro Automobilistico**: Dominio
- **Veicolo**: informazione da registrare nel registro
- **Modello**: tipo di modello che il veicolo può avere 
- **combusibile**: quale carburante utilizza il veicolo
- **proprietari**: "vita" del veicolo

## Documento di Specifiche
Si progetti uno schema entità/relazioni per la gestione di un registro automobilistico, facente parte del sistema informativo di un ufficio di motorizzazione, contenente le seguenti informazioni:
+ di ciascun veicolo interessa registrare la targa, la cilindrata, i cavalli fiscali, la velocità, il numero di posti e la data di immatricolazione;
+ i veicoli sono classificati in categorie (automobili, ciclomotori, camion, rimorchi, ecc.);
+ ciascun veicolo appartiene ad uno specifico modello;
+ tra i dati relativi ai veicoli, vi è la codifica del tipo di combustibile utilizzato;
+ di ciascun modello di veicolo è registrata la fabbrica di produzione e il numero delle versioni prodotte;
+ ciascun veicolo può avere uno o più proprietari, che si succedono nel corso della “vita” del veicolo; di ciascun proprietario interessa registrare cognome, nome e indirizzo di residenza.
## Strutturazione dei requisiti

## Operazioni richeste
- **Op1**: Aggiunta nuovo veicolo prodotto [15 al giorno]
- **Op2**: Calcolare tutti i dati relativi alla fabbrica soprattutto il numero dei veicoli prodotti [2 al giorno]
## Modello ER

<img src="img/SchemaER.drawio.png"/>

## Regole di Gestione
- Gli attributi data_acquisto e data_vendita nella relazione PROPRIETARI PASSATI non devono combaciare, non devono intersecarsi tra intervalli di proprietari diversi e data_acquisto non deve essere NULL

### Vincoli d'integrità

### Regole di derivazione

## Progettazione Logica
### Tabella volumi
Aggingere tabella volumi

### Analisi delle ridondanze
Si prende in considerazione la prima operazione. In un giorno vengono registrati 15 veicoli.

Mentre la seconda operazione ovvero, la visualizzazione dei dati della fabbrica viene eseguita due volte al giorno sia all'apertura che alla chiusura del portale.

#### Presenza di ridondanza
- Aggiundere (fare) mini schema ER

Per eseguire il calcolo delle operazione in presenza di ridondanze si fa il calcolo di ogni micro processo:

+ Operazione 1: 
  + Memorizzo il nuovo veicolo 
  + memorizzo la coppia veicolo-modello 
  + cerco il modello e per risalire alla fabbrica
  + cerca la fabbrica di interesse
  + incremento di uno i veicoli prodotti
[Inserire tabella con i valori e il calcolo]
+ Operazione 2:
  + Leggere gli attributi della fabbrica
[Inserire tabella con i valori e il calcolo]

#### Assenza di ridondanza
- Aggiundere (fare) mini schema ER

- Operazioen 1:
  - Memorizzo il nuovo veicolo
  - Memorizzo la coppia veicolo modello
[Inserire tabella con i valori e il calcolo]

- Operazione 2: Per calcolare il numero di veicoli prodotti da una fabbrica dobbiamo accedere alla relazione "prodotto" un n di volte pare al numero medio di veicoli prodotti da una certa fabbrica (dalla fabbrica): nrModelli/nrFabbriche (200/10) **e per ogni di questi modelli** bisogna accedere un nr di volte pari al numero medio di veicoli appertenenti ad un modello : nrVeicoli /nrModelli (90000/200)
[Inserire tabella con i valori e il calcolo]
  

### Costi operazione
### Eliminazione delle generalizzazioni
In questa fase del progetto sono state gestite le generalizzazioni presenti eliminando le gerarchie, in particolare sono state trasformate le seguenti parti:
**Veicolo**
**Proprietario**

Automobile: Tipologia (Velocita' max)
Ciclomotore: Bauletto -> si/no
Camion: numeroAssi
Rimorchio: Tipologia, carico.
### Selezione degli identificatori
### Traduzione modello logico
## Progettazione Fisica
### Definizione database in SQL
#### Definizione dati
#### Creazione tabelle
#### Definizione trigger
### Popolazione base di dati
### Query
## Analisi con R
## Conclusioni
# Relazione Progetto Basi di Dati
## Consegna
- Si progetti uno schema entità/relazioni per la gestione di un registro automobilistico, facente parte del sistema informativo di un ufficio di motorizzazione, contenente le seguenti informazioni:
- di ciascun veicolo interessa registrare la targa, la cilindrata, i cavalli fiscali, la velocità, il numero di posti e la data di immatricolazione;
- i veicoli sono classificati in categorie (automobili, ciclomotori, camion, rimorchi, ecc.);
- ciascun veicolo appartiene ad uno specifico modello;
tra i dati relativi ai veicoli, vi è la codifica del tipo di combustibile utilizzato;
- di ciascun modello di veicolo è registrata la fabbrica di produzione e il numero delle versioni prodotte;
- ciascun veicolo può avere uno o più proprietari, che si succedono nel corso della “vita” del veicolo; di ciascun proprietario interessa registrare cognome, nome e indirizzo di residenza.<br>
Lo schema entità/relazioni dovrà essere completato con attributi "ragionevoli" per ciascuna entità, identificando le possibili chiavi e le relazioni necessarie per la gestione del sistema in esame.
A partire dallo schema entità/relazioni, si costruisca il corrispondente schema relazionale.<br>

## GLOSSARIO Termini
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
### Vincoli d'integrità
### Regole di derivazione
## Progettazione Logica
### Tabella volumi
### Analisi delle ridondanze
### Costi operazione
#### Presenza di ridondanza
#### Assenza ridondanza
### Eliminazione delle generalizzazioni
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

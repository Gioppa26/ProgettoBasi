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
| Concetto               | Tipo  | Volume   |
|---                     | ---   | ---      |
| Veicolo                | E     | 90000    |
| Proprietario           | E     | 125000   |
| Combustibile           | E     | 5        |
| Modello                | E     | 200      |
| Fabbrica               | E     | 10       |
| ProprietarioCorrente   | R     | 90000    |
| ProprietariPassati     | R     | 225000   |
| Appartiene             | R     | 90000    |
| Prodotto               | R     | 200      |
| Utilizza               | R     | 90000    |

*In media una persona possiede 0.75 veicoli*
*In media un veicolo ha avuto 2.5 proprietari nel passato*

### Analisi delle ridondanze
Si prende in considerazione la prima operazione. In un giorno vengono registrati 15 veicoli.

Mentre la seconda operazione ovvero, la visualizzazione dei dati della fabbrica viene eseguita due volte al giorno sia all'apertura che alla chiusura del portale.

#### Presenza di ridondanza
- Aggiundere (fare) mini schema ER
<img src="img/SchemaRidondanza2.drawio.png"/>

Per eseguire il calcolo delle operazione in presenza di ridondanze si fa il calcolo di ogni micro processo:

+ Operazione 1: 
  + Memorizzo il nuovo veicolo 
  + memorizzo la coppia veicolo-modello 
  + cerco il modello e per risalire alla fabbrica
  + cerca la fabbrica di interesse
  + incremento di uno i veicoli prodotti

|Concetto     |Costrutto|Accessi|Tipo|
|--------     |---------|-------|----|
|Veicolo      | E       |1      |S   |
|Appartiene   |R        |1      |S   |
|Modello      |E        |0      |    |
|Prodotto     |R        |1      |L   |
|Fabbrica     |E        |1      |L   |
|Fabbrica     |E        |1      |S   |

```math
(15*3)*2 + (15*2) = 120
```
+ Operazione 2:
  + Leggere gli attributi della fabbrica

|Concetto     |Costrutto|Accessi|Tipo|
|--------     |---------|-------|----|
|Fabbrica     |E        |1      |L   |

```math
2*1 = 2
```

#### Assenza di ridondanza
- Aggiundere (fare) mini schema ER
<img src="img/SchemaRidondanza.drawio.png"/>
- Operazioen 1:
  - Memorizzo il nuovo veicolo
  - Memorizzo la coppia veicolo modello

|Concetto     |Costrutto|Accessi|Tipo|
|--------     |---------|-------|----|
|Veicolo      |E        |1      |S   |
|Appartiene   |R        |1      |S   |
|Modello      |E        |0      |    |
|Prodotto     |R        |0      |    |
|Fabbrica     |E        |0      |    |


$(15 * 2) * 2 = 60$

- Operazione 2: Per calcolare il numero di veicoli prodotti da una fabbrica dobbiamo accedere alla relazione "prodotto" un n di volte pare al numero medio di veicoli prodotti da una certa fabbrica (dalla fabbrica): nrModelli/nrFabbriche (200/10) **e per ogni di questi modelli** bisogna accedere un nr di volte pari al numero medio di veicoli appertenenti ad un modello : nrVeicoli /nrModelli (90000/200)

|Concetto     |Costrutto|Accessi|Tipo|
|--------     |---------|-------|----|
|Fabbrica     |E        |1      |L   | 
|Prodotto     |E        |20     |L   |
|Appartiene   |E        |9000 (20*450)   |L   | 

$1+20+9000 = 9021$

### Costi operazione
Presenza di ridondanza &Longrightarrow; $120+2=122$

Assenza di ridondanza &Longrightarrow; $60 + 9021 = 9081$

Quindi ci conviene tenere il dato ridondante. 

#### Eliminazione delle generalizzazioni
In questa fase del progetto sono state gestite le generalizzazioni presenti eliminando le gerarchie, in particolare sono state trasformate le seguenti parti:
**Veicolo**
<img src="/img/SchemaER_modificato_veicolo.drawio(1).png"/>

**Proprietario**
<img src="/img/Proprietario.drawio.png"/>

#### Partizionamento o accorpamento
Sono stati eliminati gli attributi non atomici, nel nostro caso l'attributo indirizzo dell'entita *propritario*. Noi abbiamo gia partizionato le nostre entita e relazioni durante la progettazione dello schema ER **(chiedere al prof)** 
### Selezione degli identificatori

| Entita`     |  Chiavi          | 
|-------------|-------------------|
| Veicolo     | Targa             | 
| Combustibile| codiceCombustibile | 
| Proprietario| CodiceFiscale      | 
| Modello     | idModello         | 
| Fabbrica    | idFabbrica       | 

### Traduzione modello logico
+ Fabbrica(_idFabbrica_,nome,numeroVeicoloProdotti)
+ Modello(_idModello_,nomeModello,numeroVersioni,**_FabbricaDiProduzione_**)
+ Combustibile(_codiceCombustibile_,tipoCombustibile)
+ Proprietario(_CodiceFiscale_,nome,cognome,indirizzo)
+ Privato(_**CodiceFiscale**_,dataNascita)
+ Societa(_**CodiceFiscale**_,partitaIva)
+ Veicolo(_Targa_,cavalli,velocita,numeroPosti,dataImmatricolazione, cilindrata, _**Modello**_,_**CodiceCombustibile**_,_**Proprietario**_)
+ ProprietariPassati(**_Targa,CodiceFiscale_**,dataVendita,dataAcquisto)
+ Automobile(_**Targa**_,tipologia)
+ Ciclomotore(_**Targa**_,bauletto)
+ Camion(_**Targa**_,numeroAssi)
+ Rimorchio(_**Targa**_,tipologia,carico)

## Progettazione Fisica
### Definizione database in SQL
#### Definizione dati
#### Creazione tabelle
#### Definizione trigger
### Popolazione base di dati
### Query
## Analisi con R
## Conclusioni
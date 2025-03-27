import pandas as pd
import random
from datetime import date, timedelta

# Generazione di proprietari.csv (come prima)
data_proprietari = []
for i in range(1, 1251):
    via = random.choice(["Via", "Corso", "Piazza", "Viale", "Strada"])
    nome_via = f"{via} {random.choice([
    "Roma", "Italia", "Garibaldi", "Verdi", "Dante", "Napoli", "Milano", "Torino",
    "Firenze", "Venezia", "Bologna", "Genova", "Palermo", "Bari", "Cavour",
    "Leopardi", "Petrarca", "Manzoni", "Ariosto", "Alfieri", "Galilei", "Fermi",
    "Volta", "Marconi", "Einstein", "Newton", "Pitagora", "Archimede", "Omero",
    "Virgilio", "D'Annunzio", "Pirandello", "Deledda", "Saba", "Ungaretti",
    "Montale", "Quasimodo", "Moravia", "Calvino"
])} {random.randint(1, 100)}"
    citta = random.choice([
    "Milano", "Roma", "Napoli", "Torino", "Firenze", "Bologna", "Genova", "Palermo",
    "Venezia", "Bari", "Catania", "Verona", "Messina", "Padova", "Trieste", "Brescia",
    "Prato", "Taranto", "Reggio Calabria", "Modena", "Parma", "Reggio Emilia",
    "Perugia", "Livorno", "Ravenna", "Cagliari", "Foggia", "Salerno", "Rimini",
    "Ferrara", "Sassari", "Siracusa", "Pescara", "Monza", "Bergamo", "Forlì", "Trento",
    "Vicenza", "Terni"
])
    indirizzo = f"{nome_via}, {citta}"
    data_proprietari.append([i, indirizzo])

df_proprietari = pd.DataFrame(data_proprietari, columns=["id_proprietario", "indirizzo"])
df_proprietari.to_csv("proprietari.csv", index=False)

# Generazione di privati.csv
data_privati = []
for i in range(1, 626):
    cf = f"{''.join(random.choices('ABCDEFGHIJKLMNOPQRSTUVWXYZ', k=6))}{''.join(random.choices('0123456789', k=2))}{random.choice('ABCDEFGHIJKLMNOPQRSTUVWXYZ')}{''.join(random.choices('0123456789', k=2))}{random.choice('ABCDEFGHIJKLMNOPQRSTUVWXYZ')}"
    nome = random.choice([
    "Mario", "Giovanni", "Giuseppe", "Bruno", "Luigi", "Antonio", "Carlo", "Alberto",
    "Marco", "Andrea", "Paolo", "Luca", "Fabio", "Roberto", "Stefano", "Alessandro",
    "Davide", "Michele", "Simone", "Enrico", "Sara", "Laura", "Anna", "Maria",
    "Francesca", "Giulia", "Elena", "Valentina", "Chiara", "Silvia", "Martina",
    "Federica", "Alessia", "Elisa", "Simona", "Roberta", "Paola", "Cristina",
    "Daniela", "Monica"
])
    cognome = random.choice(["Rossi", "Verdi", "Esposito", "Leoni", "Rizzo", "Colombo", "Ferrari", "Bianchi",
    "Romano", "Gallo", "Costa", "Fontana", "Conti", "Ricci", "Bruno", "Moretti",
    "Barbieri", "Santoro", "Marino", "Greco", "Lombardi", "De Luca", "Mancini",
    "Russo", "Ferrara", "Gentile", "Messina", "Sanna", "Piras", "Carta", "Meloni",
    "Serra", "Lai", "Usai", "Vacca", "Puddu", "Pinna", "Floris"
])
    start_date = date(1950, 1, 1)
    end_date = date(2005, 12, 31)
    random_days = random.randint(0, (end_date - start_date).days)
    data_nascita = start_date + timedelta(days=random_days)
    data_privati.append([i, cf, nome, cognome, data_nascita])

df_privati = pd.DataFrame(data_privati, columns=["id_proprietario", "cf", "nome", "cognome", "data_nascita"])
df_privati.to_csv("privati.csv", index=False)

# Generazione di societa.csv
data_societa = []
for i in range(626, 1251):
    partita_iva = ''.join(random.choices('0123456789', k=11))
    data_societa.append([i, partita_iva])

df_societa = pd.DataFrame(data_societa, columns=["id_proprietario", "partita_iva"])
df_societa.to_csv("societa.csv", index=False)

print("File proprietari.csv, privati.csv e societa.csv generati.")


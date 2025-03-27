import pandas as pd
import random
from datetime import date, timedelta

# Funzione di supporto
def random_date(start_date, end_date):
    random_days = random.randint(0, (end_date - start_date).days)
    return start_date + timedelta(days=random_days)

# Caricamento dei dati dalle tabelle esistenti
df_modelli = pd.read_csv("modello.csv")
df_combustibili = pd.read_csv("combustibile.csv")
df_proprietari = pd.read_csv("proprietari.csv")

# Generazione di veicoli.csv
data_veicoli = []
for i in range(1, 1001):
    targa = f"{''.join(random.choices('ABCDEFGHIJKLMNOPQRSTUVWXYZ', k=2))}{''.join(random.choices('0123456789', k=3))}{''.join(random.choices('ABCDEFGHIJKLMNOPQRSTUVWXYZ', k=2))}"
    cavalli = random.randint(70, 300)
    velocita = random.randint(150, 250)
    numero_posti = random.choice([2, 4, 5, 7])
    data_immatricolazione = random_date(date(2000, 1, 1), date(2023, 12, 31))
    cilindrata = random.choice([1200, 1400, 1600, 1800, 2000])
    # La data di acquisto deve essere successiva alla data di immatricolazione
    data_acquisto = random_date(data_immatricolazione, date(2024, 12, 31))
    modello = random.choice(df_modelli["id_modello"].tolist())
    codice_combustibile = random.choice(df_combustibili["codice_combustibile"].tolist())
    proprietario = random.choice(df_proprietari["id_proprietario"].tolist())
    data_veicoli.append([targa, cavalli, velocita, numero_posti, data_immatricolazione, cilindrata, data_acquisto, modello, codice_combustibile, proprietario])

df_veicoli = pd.DataFrame(data_veicoli, columns=["targa", "cavalli", "velocita", "numero_posti", "data_immatricolazione", "cilindrata", "data", "modello", "codice_combustibile", "proprietario"])
df_veicoli.to_csv("veicoli.csv", index=False)

print("File veicoli.csv generato.")
import pandas as pd
import random
from datetime import date, timedelta, datetime

# Funzioni di supporto
def random_date(start_date, end_date):
    random_days = random.randint(0, (end_date - start_date).days)
    return start_date + timedelta(days=random_days)

# Caricamento dei dati dalle tabelle esistenti
df_modelli = pd.read_csv("modelli.csv")
df_combustibili = pd.read_csv("combustibili.csv")
df_proprietari = pd.read_csv("proprietari.csv")
df_veicoli = pd.read_csv("veicoli.csv")

# Generazione di proprietari_passati.csv
data_proprietari_passati = []
for i in range(1, 501):  # Meno righe di veicoli.csv
    targa = random.choice(df_veicoli["targa"].tolist())
    proprietario = random.choice(df_proprietari["id_proprietario"].tolist())
    # Converti datetime.date in datetime.datetime
    data_acquisto_date = df_veicoli[df_veicoli["targa"] == targa]["data"].values[0]
    data_acquisto_datetime = datetime.strptime(data_acquisto_date, '%Y-%m-%d').date()

    # Calcola la data di vendita, assicurandoci che sia successiva alla data di acquisto
    max_vendita_date = date(2024, 12, 31)
    min_vendita_date = data_acquisto_datetime + timedelta(days=30)
    if min_vendita_date > max_vendita_date:
        data_vendita = max_vendita_date
    else:
        data_vendita = random_date(min_vendita_date, max_vendita_date)

    data_proprietari_passati.append([targa, proprietario, data_vendita, data_acquisto_datetime])

df_proprietari_passati = pd.DataFrame(data_proprietari_passati, columns=["targa", "id_proprietario", "data_vendita", "data_acquisto"])
df_proprietari_passati.to_csv("proprietari_passati.csv", index=False)

print("File proprietari_passati.csv generato.")
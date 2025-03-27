import pandas as pd
import random

# Caricamento del file veicoli.csv
df_veicoli = pd.read_csv("veicoli.csv")

# Generazione di automobile.csv
auto_data = []
for targa in df_veicoli["targa"].tolist():
    if random.random() < 0.6:  # Probabilità del 60% che sia un'automobile
        tipologia = random.choice(["Berlina", "SUV", "Familiare", "Sportiva", "Utilitaria", "Coupé", "Cabriolet", "Monovolume"])
        auto_data.append([targa, tipologia])
df_auto = pd.DataFrame(auto_data, columns=["targa", "tipologia"])
df_auto.to_csv("automobile.csv", index=False)

# Generazione di ciclomotore.csv
ciclomotore_data = []
for targa in df_veicoli["targa"].tolist():
    if random.random() < 0.1:  # Probabilità del 10% che sia un ciclomotore
        bauletto = random.choice([True, False])
        ciclomotore_data.append([targa, bauletto])
df_ciclomotori = pd.DataFrame(ciclomotore_data, columns=["targa", "bauletto"])
df_ciclomotori.to_csv("ciclomotore.csv", index=False)

# Generazione di camion.csv
camion_data = []
for targa in df_veicoli["targa"].tolist():
    if random.random() < 0.15:  # Probabilità del 15% che sia un camion
        numero_assi = random.choice([2, 3, 4, 6, 8])
        camion_data.append([targa, numero_assi])
df_camion = pd.DataFrame(camion_data, columns=["targa", "numero_assi"])
df_camion.to_csv("camion.csv", index=False)

# Generazione di rimorchio.csv
rimorchio_data = []
for targa in df_veicoli["targa"].tolist():
    if random.random() < 0.05:  # Probabilità del 5% che sia un rimorchio
        tipologia = random.choice(["Trasporto merci", "Trasporto auto", "Trasporto animali"])
        carico = random.randint(5, 2000)
        rimorchio_data.append([targa, tipologia, carico])
df_rimorchio = pd.DataFrame(rimorchio_data, columns=["targa", "tipologia", "carico"])
df_rimorchio.to_csv("rimorchio.csv", index=False)

print("File automobile.csv, ciclomotore.csv, camion.csv e rimorchio.csv generati.")
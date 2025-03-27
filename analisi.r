library("DBI")
library("RPostgres")

pg_connection <- dbConnect(
  RPostgres::Postgres(),
  dbname = "registro_automobilistico",
  host= "127.0.0.1",
  port="5432",
  user="postgres",
  password="admin")

fabbriche <- read.csv("dataset/fabbriche.csv",header = TRUE)
dbWriteTable(pg_connection,name="fabbrica",value = fabbriche, append = T, row.names = F)

modelli <- read.csv("dataset/modelli.csv",header = TRUE)
dbWriteTable(pg_connection,name="modello",value = modelli, append = T, row.names = F)

combustibili <- read.csv("dataset/combustibili.csv",header = TRUE)
dbWriteTable(pg_connection,name="combustibile",value = combustibili, append = T, row.names = F)

proprietari <- read.csv("dataset/proprietari.csv",header = TRUE)
dbWriteTable(pg_connection,name="proprietario",value = proprietari, append = T, row.names = F)

privati <- read.csv("dataset/privati.csv",header = TRUE)
dbWriteTable(pg_connection,name="privato",value = privati, append = T, row.names = F)

societa <- read.csv("dataset/societa.csv",header = TRUE)
dbWriteTable(pg_connection,name="societa",value = societa, append = T, row.names = F)

veicoli <- read.csv("dataset/veicoli.csv",header = TRUE)
dbWriteTable(pg_connection,name="veicolo",value = veicoli, append = T, row.names = F)

proprietari_passati <- read.csv("dataset/proprietari_passati.csv",header = TRUE)
dbWriteTable(pg_connection,name="proprietari_passati",value = proprietari_passati, append = T, row.names = F)

automobili <- read.csv("dataset/automobili.csv",header = TRUE)
dbWriteTable(pg_connection,name="automobile",value = automobili, append = T, row.names = F)

camion <- read.csv("dataset/camion.csv",header = TRUE)
dbWriteTable(pg_connection,name="camion",value = camion, append = T, row.names = F)

ciclomotori <- read.csv("dataset/ciclomotori.csv",header = TRUE)
dbWriteTable(pg_connection,name="ciclomotore",value = ciclomotori, append = T, row.names = F)

rimorchi <- read.csv("dataset/rimorchi.csv",header = TRUE)
dbWriteTable(pg_connection,name="rimorchio",value = rimorchi, append = T, row.names = F)
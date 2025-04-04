library("DBI")
library("RPostgres")
library("ggplot2")

pg_connection <- dbConnect(
  RPostgres::Postgres(),
  dbname = "registroAuto",
  host= "127.0.0.1",
  port="5432",
  user="postgres",
  password="Giovanni26!")

result <- dbGetQuery(pg_connection,
                     "SELECT f.nome AS fabbriche,count(m.id_modello) as numeroModelli
                      FROM fabbrica as f, modello as m
                      WHERE f.id_fabbrica = m.fabbrica_di_produzione
                      GROUP BY f.nome")

result <- na.omit(result)
modelli <- list(result$numeromodelli)

barplot(
  modelli,
  names.arg = result$fabbriche,
  xlab = "Fabbriche",
  ylab = "Numero Modelli",
  main = "Numero di Modelli per Fabbrica",
  col = rainbow(length(result$fabbriche)), # Colori arcobaleno per le barre
  ylim = c(0, max(result$numeromodelli) + 2) # Imposta il limite superiore dell'asse y
)

text(
  x = seq(1, length(result$fabbriche) * 1.2, by = 1.2),
  y = result$numeromodelli + 0.5,
  labels = result$numeromodelli,
  cex = 0.8 # Dimensione del testo
)
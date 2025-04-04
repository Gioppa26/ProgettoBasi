library("DBI")
library("RPostgres")
library("ggplot2")

pg_connection <- dbConnect(
  RPostgres::Postgres(),
  dbname = "registro_m",
  host= "127.0.0.1",
  port="5432",
  user="postgres",
  password="password")


# grafico che visualizza il numero di modellio per ogni fabbrica##############
result <- dbGetQuery(pg_connection,
                     "SELECT f.nome AS fabbriche,count(m.id_modello) as numeroModelli
                      FROM fabbrica as f, modello as m
                      WHERE f.id_fabbrica = m.fabbrica_di_produzione
                      GROUP BY f.nome")


# Creazione del grafico a barre con ggplot2
ggplot(data = result, aes(x = fabbriche, y = numeromodelli, fill = numeromodelli)) +
  geom_bar(stat = "identity", color = "black") +
  xlab("Fabbriche") +
  ylab("Numero di Modelli") +
  ggtitle("Numero di Modelli per Fabbrica") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_gradient(low = "lightblue", high = "darkblue")
#########################################################################


## Distribuzione dei Veicoli per Categoria ########################################
result <- dbGetQuery(pg_connection,
                     "SELECT
                      CASE
                          WHEN targa IN (SELECT targa FROM automobile) THEN 'automobile'
                          WHEN targa IN (SELECT targa FROM camion) THEN 'camion'
                          WHEN targa IN (SELECT targa FROM ciclomotore) THEN 'ciclomotore'
                          WHEN targa IN (SELECT targa FROM rimorchio) THEN 'rimorchio'
                          ELSE 'altro'
                        END AS categoria,
                        COUNT(*) AS numero_veicoli
                      FROM veicolo
                      GROUP BY categoria")

ggplot(result, aes(x = "", y = numero_veicoli, fill = categoria)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  labs(x = NULL, y = NULL, fill = "Categoria", title = "Distribuzione dei Veicoli per Categoria") +
  theme_void() +
  theme(plot.title = element_text(hjust = 0.5))
#########################################################################



# Disconnessione dal database
dbDisconnect(pg_connection)
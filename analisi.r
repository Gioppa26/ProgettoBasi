library("DBI")
library("RPostgres")

pg_connection <- dbConnect(
  RPostgres::Postgres(),
  dbname = "registro_automobilistico",
  host= "127.0.0.1",
  port="5432",
  user="postgres",
  password="admin")

df <- dbGetQuery()
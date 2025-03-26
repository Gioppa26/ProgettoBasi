library("RPostgreSQL")

drv <- dbDriver("PostgreSQL")

con <- dbConnect(drv,
                 dbname = "registro_automobilistico",
                 host= "<indirizzo IP dbserver>",
                 port="5432",
                 user="postgres",
                 password="<passwd>")

dbWriteTable( con,
              name=c("<schema>", "<tabella>"),
              value=<data_frame>,
              append=<T=F>,
              row.names=<T=F>)

fabbriche_df <- data.frame(
  id_fabbrica = sample(1:10,1,replace = F),
  nome = sample()
)
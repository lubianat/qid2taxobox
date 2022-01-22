library(stringr)
library(dplyr)
library(httr)
library(WikidataQueryServiceR)

get_parent_taxon_df <- function(qid) {
  query = paste0('SELECT 
  ?taxonRankLabel
  ?taxonName
  WHERE 
  {
    wd:',qid,' wdt:P171* ?parentTaxon.
    ?parentTaxon wdt:P105 ?taxonRank.
    ?parentTaxon wdt:P225 ?taxonName.
    SERVICE wikibase:label { bd:serviceParam wikibase:language "pt". }
  }')
    
  parent_taxon_df <- query_wikidata(query)
}


get_taxobox_from_df <- function(parent_taxon_df) {
  
  result <- ("{{Info/Taxonomia\n")
  to_append <- ("| imagem                = {{#statements:P18}}\n")
  
  result <- paste0(result, to_append)
  
  for (i in 1:nrow(parent_taxon_df)) {
    rank = parent_taxon_df[i,1]
    name = parent_taxon_df[i,2]
    
    n_space = 22 - nchar(rank)
    to_append <- (paste0("| ", rank,
               strrep(" ",n_space),
               "= ",
               "[[",
               name,
               "]]",
               "\n"))
    
    result <- paste0(result, to_append)
  }
  to_append <- ("}}")
  result <- paste0(result, to_append)
  
  return(result)
}

get_taxobox <- function(qid) {
  df <- get_parent_taxon_df(qid)
  a <- get_taxobox_from_df(df)
  return(a)
}

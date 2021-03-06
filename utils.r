library(stringr)
library(dplyr)
library(httr)
library(WikidataQueryServiceR)

query = 'SELECT 
?taxonRankLabel
?taxonName
WHERE 
{
  wd:Q10571738 wdt:P171* ?parentTaxon.
  ?parentTaxon wdt:P105 ?taxonRank.
  ?parentTaxon wdt:P225 ?taxonName.
  SERVICE wikibase:label { bd:serviceParam wikibase:language "pt". }
}'
  
parent_taxons <- query_wikidata(query)


print_taxobox <- function(parent_taxons) {
  cat("{{Info/Taxonomia\n")
  cat("|imagem          = {{#statements:P18}}\n")
  for (i in 1:nrow(parent_taxons)) {
    rank = parent_taxons[i,1]
    name = parent_taxons[i,2]
    
    n_space = 22 - nchar(rank)
    cat(paste0("| ", rank,
               strrep(" ",n_space),
               "= ",
               "[[",
               name,
               "]]",
               "\n"))
    # do more things with the data frame...
  }
  cat("}}")
}

print_taxobox(parent_taxons)

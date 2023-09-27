#Install packages if needed
#install.packages("remotes", "here")
#library(remotes)
#install_github("elizagrames/litsearchr", ref="main")

#Load libraries
library(litsearchr)
library(here)

#Import .ris files from naive search and benchmark
search_directory <- (here("naive_search/"))

naiveimport <-
  litsearchr::import_results(directory = search_directory, verbose = TRUE)

#Remove duplicates
naiveresults <-
  litsearchr::remove_duplicates(naiveimport, field = "title", method = "string_osa")

#Extract keywords
rakedkeywords <-
  litsearchr::extract_terms(
    text = paste(naiveresults$title, naiveresults$abstract),
    method = "fakerake",
    min_freq = 2, #must occur at least 2 times
    ngrams = TRUE, #look for multi-word phrase 
    min_n = 2, #of two words in length
    language = "English"
  )

all_keywords <- unique(rakedkeywords)

#Create matrix of keywords and their occurrent in records
naivedfm <-
  litsearchr::create_dfm(
    elements = paste(naiveresults$title, naiveresults$abstract),
    features = all_keywords
  )

#Create graph object
naivegraph <-
  litsearchr::create_network(
    search_dfm = naivedfm,
    min_studies = 2,
    min_occ = 2
  )

#Set cutoff point
cutoff <-
  litsearchr::find_cutoff(
    naivegraph,
    method = "cumulative",
    percent = .80,
    imp_method = "strength"
  )

#Create network graph
reducedgraph <-
  litsearchr::reduce_graph(naivegraph, cutoff_strength = cutoff[1])

#Write out search terms
searchterms <- litsearchr::get_keywords(reducedgraph)

head(searchterms, 20)

#Write to .csv
write.csv(searchterms, "./litsearchr_terms.csv")

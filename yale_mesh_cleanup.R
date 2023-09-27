#Load the necessary library if not already loaded
# install.packages("readxl", "dplyr", "here")  #Run this line if you don't have the packages
library(readxl)
library(dplyr)
library(here)

# Load data into a data frame 
yale_mesh_1 <- read_excel(here("mesh_terms", "mesh_analysis.xlsx"))
yale_mesh_2 <- read_excel(here("mesh_terms", "mesh_analysis(1).xlsx"))
yale_mesh_3 <- read_excel(here("mesh_terms", "mesh_analysis(2).xlsx"))
yale_mesh_4 <- read_excel(here("mesh_terms", "mesh_analysis(3).xlsx"))
yale_mesh_5 <- read_excel(here("mesh_terms", "mesh_analysis(4).xlsx"))

#Write a function to restructure output from Yale MeSH Analyzer
process_yale_mesh <- function(x) {
  yale_mesh_tp <- t(x[, -1]) %>%  as.data.frame() %>%
    mutate_all(~ gsub("\n", ";", .)) %>% 
    rename(title = V1, author_year = V2, mesh = V3) %>% 
    unite(mesh, starts_with("V"), sep = ";", remove = TRUE, na.rm = TRUE) %>% 
    mutate(mesh = ifelse(is.na(mesh), "", mesh)) %>%
    separate_rows(mesh, sep = ";") %>%
    mutate(mesh = trimws(mesh)) %>%
    filter(mesh != "")
  
    yale_mesh_clean <- yale_mesh_tp %>% 
      data.frame(mesh = yale_mesh_tp$mesh) %>% 
      distinct(mesh) %>%
      arrange(mesh)

  return(yale_mesh_clean)
}

#Process individual files
yale_mesh_1_clean <- process_yale_mesh(yale_mesh_1)
yale_mesh_2_clean <- process_yale_mesh(yale_mesh_2)
yale_mesh_3_clean <- process_yale_mesh(yale_mesh_3)
yale_mesh_4_clean <- process_yale_mesh(yale_mesh_4)
yale_mesh_5_clean <- process_yale_mesh(yale_mesh_5)

#Combine individual restructure dataframes
dataframes <- list(yale_mesh_1_clean, yale_mesh_2_clean, yale_mesh_3_clean, yale_mesh_4_clean, yale_mesh_5_clean)

all_yale_mesh_clean <- bind_rows(dataframes) %>%
  distinct(mesh) %>%
  arrange(mesh)

#Write .csv list of MeSH terms
write.csv(all_yale_mesh_clean, "all_yale_mesh.csv")




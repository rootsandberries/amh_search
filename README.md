# Search strategy development for "Abortion and patients' mental health outcomes: A systematic review and meta-analysis"

This repository contains the code and associated files for the search strategy development for "Abortion and patients' mental health outcomes: A systematic review and meta-analysis". More details about the search strategy development process can be found in [Open Science Framework](https://osf.io/v8t92/). 

This repository includes code for term harvesting using the R package [*litsearchr*](https://elizagrames.github.io/litsearchr/) and a short script for converting exports from [Yale MeSH Analyzer](https://mesh.med.yale.edu/) to a list of medical subject heading (MeSH) terms in .csv format.

## *litsearchr* analysis
To establish the set of studies for keyword analysis, a "naive search" in Web of Science Social Science Citation Index (SSCI) and Science Citation Index-Expanded (SCI-EXPANDED) was combined with 94 benchmark studies identified from previous systematic reviews and other methods. 

Naive search:
TS=(abortion AND "mental health")
Date: August 14, 2023
n=605

List of files:

**amh_litsearchr.R**: R script for litsearchr analysis

**naive_search/**: Directory containing .ris file exports of naive search and benchmark studies from Medline (PubMed)
* pubmed_94.ris
* wos_naive_605.ris

## Yale MeSH Analyzer cleanup
Yale MeSH Analyzer takes a list of PubMed IDs and provides a summary of associated MeSH terms and other metadata in a wide format spreadsheet. A short script was developed to facilitate deduplication of MeSH terms across studies and screening for relevant terms.

**yale_mesh_cleanup.R**:
R script to convert Yale MeSH Analyzer output into a simple list of MeSH terms in .csv format.

**mesh_terms/**: Directory containing output files from Yale MeSH Analyzer search for 94 benchmark studies.



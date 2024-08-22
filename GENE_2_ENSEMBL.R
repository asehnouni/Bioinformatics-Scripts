library(biomaRt)
library(tximport)
library(ggplot2)
library(DESeq2)
library(openxlsx)
library(rhdf5)
library(data.table)
library(argparse)
library(dplyr)

if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install(version = "3.14")
BiocManager::install("edgeR")
install.packages("argparse")
BiocManager::install(c("GenomicFeatures", "AnnotationDbi"), force = TRUE)
BiocManager::install("sva")
install.packages("Rtsne")
install.packages("tibble")
install.packages("dplyr")
install.packages("pbapply")

df_new <- read.table('GENE_ID_ENSEMBL.txt', header=TRUE)
df_new 
genes <-  df_new$target_id 
genes 
mart <- useMart('ensembl', dataset = 'hsapiens_gene_ensembl') 
gene_IDs <- getBM(   attributes = c(     'ensembl_gene_id',
                                         'ensembl_transcript_id',
                                         'entrezgene_id',
                                         'hgnc_symbol'),   
                     filters = 'hgnc_symbol',   values = genes,   mart = mart) 
df1 <- full_join(df_new, gene_IDs, by = c("target_id"="hgnc_symbol")) 
write.table(df1, file = ".tsv", row.names=FALSE,sep = "\t")

# make col
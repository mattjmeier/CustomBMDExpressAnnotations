# For the creation of tables used in Defined Category Analysis
# Use for species that have a Biomart or ord.db available
# Author: Matt Meier

source("https://bioconductor.org/biocLite.R")
biocLite("org.Dr.eg.db")
biocLite("biomaRt")
library("biomaRt")
library("org.Dr.eg.db")

# Define which biomart to use
listMarts()
ensembl=useMart("ensembl")
listDatasets(ensembl)
ensembl = useDataset("drerio_gene_ensembl",mart=ensembl)

# This is just to get a sense of what the IDs are: only necessary if you need to hunt for the right format
# first.200.names <-head(attributes, n=200)$name
# for (myName in first.200.names) { print(head(getBM(attributes=c('ensembl_gene_id',myName), mart=ensembl), n=5)) }

# Create the probe map table
bmdexpressProbeMap <- getBM(attributes=c('agilent_g2519f','ensembl_gene_id'), mart=ensembl) # The first attribute will vary depending on the experiment and organism

# Rename columns...
colnames(bmdexpressProbeMap)[1] = 'Array Probe'
colnames(bmdexpressProbeMap)[2] = 'Category Component'
# Write file...
write.table(bmdexpressProbeMap, file = "bmdexpressProbeMap.txt", quote = F, sep = "\t", row.names = F, col.names = T)

# Create the category map table
bmdexpressCategoryMap <- getBM(attributes=c('go_id','name_1006','ensembl_gene_id'), mart=ensembl)
# Rename columns...
colnames(bmdexpressCategoryMap)[1] = 'Category ID'
colnames(bmdexpressCategoryMap)[2] = 'Category Name'
colnames(bmdexpressCategoryMap)[3] = 'Category Component'
# May need to remove empty transcript lines...
# Write file...
write.table(bmdexpressCategoryMap, file = "bmdexpressCategoryMap.txt", quote = F, sep = "\t", row.names = F, col.names = T)

# These are the names of some attributes of interest: you could substitute some of these in the Category Map table.

#                       go_id                          GO term accession
#                   name_1006                               GO term name
#             definition_1006                         GO term definition
#             go_linkage_type                      GO term evidence code
#              namespace_1003                                  GO domain


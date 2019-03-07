# Get a GEO Platform and convert columns of interest into BMDExpress Compatible Annotations
# Author: Matt Meier
#source("https://bioconductor.org/biocLite.R")
#biocLite("GEOquery")
library("tidyverse")
library("GEOquery")

getGEO(GEO = "GPL9248" , filename = NULL, destdir = "./" )

# NOTE: This part is easier to do in bash... Could probably be done in R, but this seems simpler.
#
# Output some information about the file, for curiosity:
#
# cat  GPL9248.soft  | grep -v "^!" | grep -v "^#" | awk -F'\t' '{print $1}' | wc -l
# 15746
# 
# cat  GPL9248.soft  | grep -v "^!" | grep -v "^#" | awk -F'\t' '{print $18 }' | grep GO | wc -l # biological process
# 9832
# 
# cat  GPL9248.soft  | grep -v "^!" | grep -v "^#" | awk -F'\t' '{print $19 }' | grep GO | wc -l # cellular component
# 10159
# 
# cat  GPL9248.soft  | grep -v "^!" | grep -v "^#" | awk -F'\t' '{print $20 }' | grep GO | wc -l # molecular function
# 10704
# 
# cat  GPL9248.soft  | grep -v "^!" | grep -v "^#" |  grep -v "^^" | less
#
##############################
# ### Create Probe file ######
# cat  GPL9248.soft  | grep -v "^!" | grep -v "^#" |  grep -v "^^" | awk -F'\t' '{print $8"\t"$7}' | sed 's/PROBE_NAME/Array Probe/' |  sed 's/Query Name/Category Component/' > probe_file.txt
# ### Create Category file ###
# cat  GPL9248.soft  | grep -v "^!" | grep -v "^#" |  grep -v "^^" | awk -F'\t' '{print $18"\t"$7}' |  sed 's/Query Name/Category Component/' | grep "GO" | sed 's/ GO/,GO/g' > category_component.txt
##############################

categorycomponent <- read.delim("./category_component.txt", sep='\t', header=T, encoding="UTF-8")

categorycomponent.multiple_lines <- separate_rows(categorycomponent,
                                                  GO..Biological_Process,
                                                  sep=",delim")
categorycomponent.multiple_rows <- separate(data=categorycomponent.multiple_lines,
                                            col = GO..Biological_Process,
                                            into = c('Category ID', 'Category Name'),
                                            sep = "\\;")

colnames(categorycomponent.multiple_rows)[3]="Category Component"

write.table(categorycomponent.multiple_rows,
            file = "bmdexpressCategoryMap.txt",
            quote = F,
            sep = "\t",
            row.names = F,
            col.names = T)

# Example of the required format...
# 
# Array Probe     Category Component
# A_15_P100609    ENSDARG00000063344
# ENSDARG00000097685
# A_15_P188361    ENSDARG00000036008
# A_15_P115328    ENSDARG00000036008
# A_15_P115946    ENSDARG00000069301
# ENSDARG00000069301
# A_15_P120498    ENSDARG00000104901
# A_15_P195241    ENSDARG00000031836
# A_15_P112323    ENSDARG00000031836
# 
# Category ID     Category Name   Category Component
# GO:0016020      membrane        ENSDARG00000063344
# GO:0016021      integral component of membrane  ENSDARG00000063344
# GO:0003676      nucleic acid binding    ENSDARG00000097685
# GO:0016020      membrane        ENSDARG00000036008
# GO:0016021      integral component of membrane  ENSDARG00000036008
# GO:0048268      clathrin coat assembly  ENSDARG00000036008
# GO:0032051      clathrin light chain binding    ENSDARG00000036008
# GO:0007212      dopamine receptor signaling pathway     ENSDARG00000036008
# GO:0016020      membrane        ENSDARG00000069301

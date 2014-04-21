cleaningdata
============

This repo contains the data acquisition script and reduction script that I used to create tidyData.csv, which is a reduction of the dataset that can be [found here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

The files in this repo: 
  * `get_data.sh` - a bash script to download and unzip the data. This also runs some command line commands to convert some of the data from fixed width to csv.
  * `run_analysis.R` - a R script that combines the data, trims to the desired variables, and reduces data subsets to mean values.
  * ` CodeBook.md` - a document describing the reduction process in more detail than this README.
  

#!/bin/bash

# acquire and unzip data
curl -O https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
unzip  getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

# remove whitespace from data directory
mv UCI\ HAR\ Dataset/ UCI-HAR-Dataset

testDir="UCI-HAR-Dataset/test"
trainDir="UCI-HAR-Dataset/train"

# convert the X_*.txt files to csv. this makes using fread possible, which is
# much much faster than read.table
sed 's/^[ \t]*//' $testDir/X_test.txt > $testDir/X_test.tmp.txt
tr -s ' ' < $testDir/X_test.tmp.txt | tr ' ' ',' > $testDir/X_test.csv
rm $testDir/X_test.tmp.txt 

sed 's/^[ \t]*//' $trainDir/X_train.txt > $trainDir/X_train.tmp.txt
tr -s ' ' < $trainDir/X_train.tmp.txt | tr ' ' ',' > $trainDir/X_train.csv
rm $trainDir/X_train.tmp.txt 

#!/bin/bash
# analyze the distribution of directories and files

basedir=$1
for dir in $(find $basedir -mindepth 1 -maxdepth 1 -type d); do
 files=$(find $basedir -mindepth 1 -maxdepth 1 -type f);
 dirs=$(find $basedir -mindepth 1 -maxdepth 1 -type d);
 echo $dir $files $dirs;
 $0 $dir;
done

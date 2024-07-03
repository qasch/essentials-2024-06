#!/usr/bin/env bash

# Alle Dateien umbenennen (Endung .txt hinzufügen)

#set -x

# ohne Kommandosubstitution
#directory="$HOME/scripts/files"  # Kommandosubstitution
#
#for file in "$directory"/*; do
#  mv $file ${file}.txt                 # Variablensubstitution
#done

# mit Kommandosubstitution
path_to_files="$HOME/scripts/files"
directory="$(ls $path_to_files)"  # Kommandosubstitution

for file in "$directory"; do
  mv $path_to_files/$file $path_to_files/${file}.txt                 # Variablensubstitution
done


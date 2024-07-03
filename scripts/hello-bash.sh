#!/bin/bash

# Variablen

# echo erstes dem Skript übergebenes Argument: $1
# echo zweites dem Skript übergebenes Argument: $2
# echo drittes dem Skript übergebenes Argument: $3
# echo dem Skript wurden $# Argumente Übergeben
# echo alle dem Skript übergebenen Argumente: $*
# echo alle dem Skript übergebenen Argumente: $@

userconfig="$HOME/.bashrc"
rootconfig="/etc/bash.bashrc"

# If-Verzweigungen (Kommando test: man test)
if test $# -ge 1; then
  username=$1      # Zuweisung, keine Leerzeichen um =
  echo Hallo $username   # Substitution
else
  echo Bitte dem Skript einen Namen als Argument übergeben
fi

if [ $username = "tux" ]; then   # Vergleich, hier müssen Leerzeichen stehen

  echo Du bist der reguläre Benutzer tux

  # Datei ~/.bashrc zum Editieren öffnen  

  # existiert die Datei überhaupt?
  if [ -f $userconfig ]; then
    nano $userconfig
  else
    echo Die Datei $userconfig existiert nicht
  fi

elif [ $username = "root" ]; then

  echo Du bist der Superuser root
  # Datei /etc/bash.bashrc zum Editieren öffnen  
  # existiert die Datei überhaupt?
  if [ -f $rootconfig ]; then
    sudo nano $rootconfig
  else
    echo Die Datei $rootconfig existiert nicht
  fi
  

else 
  echo Du bist NICHT tux
fi





# For-Loop

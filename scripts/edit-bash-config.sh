#!/bin/bash

# "Debugging" einschalten
set -x

# Variablen

userconfig="$HOME/.bashrc"
rootconfig="/etc/bash.bashrc"

# If-Verzweigungen (Kommando test: man test)
if test $# -ge 1; then
  echo Das Skript akzeptiert keine Argumente
fi

# Ist der aufrufende Benutzer root?
if [ $UID -eq 0 ]; then

  echo Du bist der Superuser root
  # Datei /etc/bash.bashrc zum Editieren öffnen  
  # existiert die Datei überhaupt?
  if [ -f $rootconfig ]; then
    nano $rootconfig
  else
    echo Die Datei $rootconfig existiert nicht
  fi

#elif [ $USER = "tux" ]; then   # Vergleich, hier müssen Leerzeichen stehen
#elif [ $UID -ge 1000 ]; then   # Vergleich, hier müssen Leerzeichen stehen
elif [[ $UID =~ [0-9]{4} ]]; then   # Vergleich, hier müssen Leerzeichen stehen

  echo Du bist der reguläre Benutzer tux

  # Datei ~/.bashrc zum Editieren öffnen  

  # existiert die Datei überhaupt?
  if [ -f $userconfig ]; then
    nano $userconfig
  else
    echo Die Datei $userconfig existiert nicht
  fi

else 
  echo Du bist weder root noch tux
fi






# For-Loop

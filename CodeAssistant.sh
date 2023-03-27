#!/bin/bash
    RED='\033[1;31m'
    GREEN='\033[1;32m'
    PURPLE='\033[1;35m'

    NC='\033[0m' # No Color
show_menu() {
  echo "Select an option:"
  echo "a) Edit source file"
  echo "b) ${PURPLE}Compile source file${NC}"
  echo "c) ${RED}Show errors${NC}"
  echo "d) ${GREEN}Run program${NC}"
  echo "e) ${RED}Exit${NC}"
  read option
}
edit_source_file() {
  vim "$1"
}

compile_source_file() {
  # Stergem fisierul cu erori si executabilul
  rm -f "${1%.*}.err" "${1%.*}" 

  # Compilam fisierul
  g++ -o "${1%.*}" "$1" 2> "${1%.*}.err"

  # Verificam statusul ultimei comenzi executate
  if [ $? -eq 0 ]; then
    echo "Compilare cu succes!"
  else
    echo "${RED}A aparut o eroare!\n${NC}Verifica fisierul cu erori!\n"
  fi
}

show_errors() {
  # Verificam daca fisierul .err exista
  # si are dimensiune mai mare de 0
  if [ -s "${1%.*}.err" ]; then
    cat "${1%.*}.err"
  else
    echo "Nu exista errori!"
  fi
}

run_program() {
  #Verificam daca fisierul este executabil de catre utilizator
  if [ -x "${1%.*}" ]; then     # -x este o optiune a comenzii test ('[')
    ./"${1%.*}"
  else
    if [ -s "${1%.*}" ]; then
      echo "Error: Utilizatorul nu are voie sa execute acest fisier!"
    else
      echo "Error: Fisierul nu exista!"
    fi
  fi
}


main(){
while true; do
  show_menu

case $option in
    a)
      edit_source_file "$1"
      ;;
    b)
      compile_source_file "$1"
      ;;
    c)
      show_errors "$1"
      ;;
    d)
      run_program "$1"
      ;;
    e)
      exit 0
      ;;
    *)
      echo "Invalid option. Please try again."
      ;;
  esac
done
}

if [ $# -lt 1 ]; then
  echo "Scriptul se foloseste in felul urmator:\nsh CodeHelper.sh {Nume_Fisier.c} \nsau:\nsh CodeHelper.sh {Nume_Fisier.cpp}\n"
  exit 1
fi


# CODUL DE MAI JOS NU E BUN PENTRU A VERIFICA DIN CAUZA CA ACESTA CONSIDERA '' (NULL) CA FIIND EXISTENT IN DIRECTOR 
#
#if [ ! -e "./$1" ]; then                   
#  echo "Fisierul nu exista in director."
#  exit 2
#fi



ls "${1}" >/dev/null 2>&1  #facem ls si outputul il aruncam in gol
if [ ! $? -eq 0 ]; then
    echo "Fisierul nu exista in director."
    exit 
fi

main "$1"


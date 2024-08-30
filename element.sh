#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"


if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
else
  # if input is not a number
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
    TEST_IF_SYMBOL=$($PSQL "SELECT * FROM elements WHERE symbol='$1'")
    TEST_IF_NAME=$($PSQL "SELECT * FROM elements WHERE name='$1'")
      # if symbol
      if [[ ! -z $TEST_IF_SYMBOL ]]
      then
        SYMBOL_QUERY=$($PSQL "SELECT atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE symbol='$1'")
        # read variables
        echo $SYMBOL_QUERY | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING_POINT BOILING_POINT
        do
          echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
        done
      else
        # if name
        if [[ ! -z $TEST_IF_NAME ]]
        then
          NAME_QUERY=$($PSQL "SELECT atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE name='$1'")
          # read variables
          echo $NAME_QUERY | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING_POINT BOILING_POINT
          do
            echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
          done
        else 
          echo -e "I could not find that element in the database."
        fi
      fi
  else
    TEST_IF_ATOMIC_NUMBER=$($PSQL "SELECT * FROM elements WHERE atomic_number=$1")
    # if number
    if [[ ! -z $TEST_IF_ATOMIC_NUMBER ]]
    then
      ATOMIC_NUMBER_QUERY=$($PSQL "SELECT atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number=$1")
      # read variables
      echo $ATOMIC_NUMBER_QUERY | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING_POINT BOILING_POINT
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    else
      echo -e "I could not find that element in the database."
    fi
  fi
fi
#!/bin/bash

# Define the PSQL command for querying the database
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if an argument is provided
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit
fi

# Query database based on argument type (atomic number, symbol, or name)
if [[ $1 =~ ^[0-9]+$ ]]; then
  QUERY_RESULT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
                        FROM elements 
                        JOIN properties USING(atomic_number) 
                        JOIN types USING(type_id) 
                        WHERE atomic_number=$1")
else
  QUERY_RESULT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
                        FROM elements 
                        JOIN properties USING(atomic_number) 
                        JOIN types USING(type_id) 
                        WHERE symbol='$1' OR name='$1'")
fi

# Check if the element exists in the database
if [[ -z $QUERY_RESULT ]]; then
  echo "I could not find that element in the database."
else
  # Format and display the query result
  echo "$QUERY_RESULT" | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  done
fi

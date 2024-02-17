#!/bin/bash

PSQL="psql -U freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"


function MAIN_MENU {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  
  echo -e "\nWelcome to My Salon, how can I help you?\n"

  SERVICE_LIST=$($PSQL "SELECT service_id,name FROM services ORDER BY service_id")
  echo "$SERVICE_LIST" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo -e "$SERVICE_ID) $SERVICE_NAME"
  done
  read SERVICE_ID_SELECTED
  
  case $SERVICE_ID_SELECTED in
    1) service 1 ;;
    2) service 2 ;;
    3) service 3 ;;
    4) service 4 ;;
    5) service 5 ;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac
}

service() {
  # set service id
  SERVICE_ID=$1
  # echo "service id $SERVICE_ID"

  # get service name
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID")

  # get customer info
  echo -e "\nWhat's your phone number?"
  read PHONE_NUMBER
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$PHONE_NUMBER'")
  
  # if not found
  if [[ -z $CUSTOMER_ID ]]
  then
    # get customer name
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME

    # insert new customer
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers (phone,name) VALUES ('$PHONE_NUMBER','$CUSTOMER_NAME')")
  fi

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$PHONE_NUMBER'")
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$PHONE_NUMBER'")

  # get service time
  echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
  read SERVICE_TIME

  # insert new appointments
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments (customer_id,service_id,time) VALUES ($CUSTOMER_ID,$SERVICE_ID,'$SERVICE_TIME')")

  # send to main menu
  MAIN_MENU "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

function SERVICE_LIST_FUNC {
  SERVICE_LIST=$($PSQL "SELECT service_id,name FROM services ORDER BY service_id")
  echo "$SERVICE_LIST" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo -e "$SERVICE_ID) $SERVICE_NAME"
  done
}

MAIN_MENU
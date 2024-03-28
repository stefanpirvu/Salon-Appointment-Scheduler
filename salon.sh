#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

# TRUNCATE TABLE ppointments, customers;

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "\nWelcome to 'My Rentals', select one of the options:\n"

  echo '1) Boat Rental'
  echo '2) Video Game Rental'
  echo '3) Book Rental'

  read SERVICE_ID_SELECTED

case $SERVICE_ID_SELECTED in
[1-3]) CREATE_APPOINTMENT ;;
*) MAIN_MENU "Sorry, select a valid option :/" ;;
esac
}

CREATE_APPOINTMENT() {

SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

echo -e "\nWhat's your phone number?\n"
read CUSTOMER_PHONE
FIND_NUMBER=$($PSQL "SELECT phone FROM customers WHERE phone = '$CUSTOMER_PHONE'")
# if phone number not found
if [[ -z $FIND_NUMBER ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    CREATE_NEW_CUSTOMER=$($PSQL "INSERT INTO customers (phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
else
# phone number found
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
fi

echo -e "\nWhat time would you like your$SERVICE_NAME, $CUSTOMER_NAME?"
read SERVICE_TIME
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name = '$CUSTOMER_NAME'")
SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")
INSERT_NEW_APPOINTMENT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID, '$SERVICE_TIME')")

echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU
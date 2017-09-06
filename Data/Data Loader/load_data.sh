#!/bin/bash
# Script for loading csv files into tables.
# Params username password.

if [ "$#" -ne 2 ]; then
    echo "ERROR: Usage load_data.sh user password"
    exit 1
fi

clear

echo "Loading continents..."
sqlldr $1/$2 control=continents.ctl silent=feedback header
echo "Table CONTINENT ready"

echo "Loading countries..."
sqlldr $1/$2 control=countries.ctl silent=feedback header
echo "Table COUNTRY ready"

echo "Loading cities..."
sqlldr $1/$2 control=cities.ctl silent=feedback header
echo "Table CITY ready"

echo "Loading aiports..."
sqlldr $1/$2 control=airports.ctl silent=feedback header
echo "Table AIRPORT ready"

echo "Loading routes..."
sqlldr $1/$2 control=routes.ctl silent=feedback header
echo "Table ROUTE ready"

echo "Loading schedules..."
sqlldr $1/$2 control=schedules.ctl silent=feedback header
echo "Table SCHEDULETIME ready"

echo "Loading airplanes..."
sqlldr $1/$2 control=airplanes.ctl silent=feedback header
echo "Table AIRPLANE ready"

echo "Loading passengers..."
sqlldr $1/$2 control=passengers.ctl silent=feedback header
echo "Table PASSENGER ready"

echo "Loading flights..."
sqlldr $1/$2 control=flights.ctl silent=feedback header
echo "Table FLIGHT ready"

echo "Loading tickets..."
sqlldr $1/$2 control=tickets.ctl silent=feedback header
echo "Table TICKET ready"
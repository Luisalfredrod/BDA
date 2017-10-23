#!/bin/bash
# Brief: Script for creating the Data Warehouse.
# Params: username password.
# Author: Eduardo Vaca.

if [ "$#" -ne 2 ]; then
    echo "ERROR: Usage dwh_creation.sh user password"
    exit 1
fi

echo "Creating and loading DWH..."

# Connect to sqlplus safely hidding credentials.
# Creates DWH.
# Loads DWH.
sqlplus /nolog << EOF
connect $1/$2
set sqlblanklines on
@create_dhw.sql
@load_dwh.sql
exit
EOF

echo "Finished"
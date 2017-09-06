#!/bin/bash
# Brief: Script for creating a DB fragmented schema based on a continent.
# Params: username password continentID dbName.
# Author: Eduardo Vaca.

if [ "$#" -ne 4 ]; then
    echo "ERROR: Usage schema_creation.sh user password [1 | 2 | 3 | 4] db"
    exit 1
fi

if [ $3 -gt 4 ]; then
    echo "ERROR: Invalid continent ID. Valid ids: [1, 2, 3, 4]"
    exit 1
fi

# Set ORACLE_SID.
ORACLE_SID = $4; EXPORT ORACLE_SID

# Connect to sqlplus safely hidding credentials.
# Drop tables.
# Create tables.
sqlplus /nolog << EOF
connect $1/$2
set sqlblanklines on
@tables_drop.sql
@tables_create.sql
exit
EOF

echo "Loading data"
# Load data with additional script.
sh ./load_data.sh $1 $2

# Connect to sqlplus safely hidding credentials.
# Fragment tables.
sqlplus /nolog << EOF
connect $1/$2
set sqlblanklines on
@tables_fragment.sql $3
exit
EOF

echo "Finished"
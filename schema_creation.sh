#!/bin/bash

if [ "$#" -ne 4 ]; then
    echo "ERROR: Usage schema_creation.sh user password [1 | 2 | 3 | 4] db"
    exit 1
fi

ORACLE_SID = $4; EXPORT ORACLE_SID

sqlplus /nolog << EOF
connect $1/$2
set sqlblanklines on
@tables_drop.sql
@tables_create.sql
exit
EOF

echo "Loading data"
sh ./load_data.sh

sqlplus /nolog << EOF
connect $1/$2
set sqlblanklines on
@tables_fragment.sql $3
exit
EOF

echo "Finished"
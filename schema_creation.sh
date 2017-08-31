#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "ERROR: Usage schema_creation.sh user password [1 | 2 | 3 | 4]"
    exit 1
fi

sqlplus /nolog << EOF
connect $1/$2
exit
EOF

echo "Finished!"
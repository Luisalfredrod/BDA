# Airline
Distributed Data Bases schema simulating an airline.

### How to create schema:

1. In a server running Oracle DB insert the .sh, .sql, .csv and .ctl files.
2. Run `sh schema_creation.sh username password continent_id db_name`.

### How to create DWH:
1. In a server running Oracle DB insert the .sh, .sql, .csv and .ctl files.
2. Set Oracle SID to a different instance other than the ones for the contients DBs.
3. Run `sh dwh_creation.sh username password`.

### How to generate DB data:

1. Create new virtual env with Python 3.
2. Run `pip install requirements.txt`

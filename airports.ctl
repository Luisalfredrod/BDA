load infile airports.csv stream
replace into table Airport
fields terminated by ','
(id_airport,name,id_city)
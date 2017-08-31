load infile airports.csv stream
replace into table AirportFull
fields terminated by ','
(id_airport,name,id_city)
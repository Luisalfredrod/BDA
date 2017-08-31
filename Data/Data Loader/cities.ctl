load infile cities.csv stream
replace into table CityFull
fields terminated by ','
(id_city,name,id_country)
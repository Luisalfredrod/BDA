load infile cities.csv stream
replace into table City
fields terminated by ','
(id_city,name,id_continent)
load infile continents.csv stream
replace into table ContinentFull
fields terminated by ','
(id_continent,name)
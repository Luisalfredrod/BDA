load infile continents.csv stream
replace into table Continent
fields terminated by ','
(id_continent,name)
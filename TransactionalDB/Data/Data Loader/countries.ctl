load infile countries.csv stream
replace into table CountryFull
fields terminated by ','
(id_country,name,id_continent)
load infile countries.csv stream
replace into table Country
fields terminated by ','
(id_country,name,id_continent)
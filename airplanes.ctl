load infile airplanes.csv stream
replace into table Airplane
fields terminated by ','
(id_plane,name,capacity)


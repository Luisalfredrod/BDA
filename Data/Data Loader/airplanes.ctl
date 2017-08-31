load infile airplanes.csv stream
replace into table AirplaneFull
fields terminated by ','
(id_plane,name,capacity)


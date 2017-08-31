load infile routes.csv stream
replace into table Route
fields terminated by ','
(id_route,id_airport_departure,id_airport_arrival,route_duration)


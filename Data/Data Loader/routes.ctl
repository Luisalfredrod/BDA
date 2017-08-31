load infile routes.csv stream
replace into table RouteFull
fields terminated by ','
(id_route,id_airport_departure,id_airport_arrival,route_duration)


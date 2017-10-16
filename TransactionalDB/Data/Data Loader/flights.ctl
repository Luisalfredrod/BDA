load infile flights.csv stream
replace into table FlightFull
fields terminated by ','
(id_flight, id_route, id_schedule, id_plane, price, flight_date, on_time, delay_time)
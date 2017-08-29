load infile passengers.csv stream
replace into table Passenger
fields terminated by ','
(id_passenger,first_name,last_name,email)
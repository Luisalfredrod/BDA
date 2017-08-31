load infile passengers.csv stream
replace into table PassengerFull
fields terminated by ','
(id_passenger,first_name,last_name,email)
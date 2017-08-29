load infile tickets.csv stream
replace into table Ticket
fields terminated by ','
(id_flight,id_passenger,seat,date_purchase)
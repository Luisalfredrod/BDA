load infile tickets.csv stream
replace into table TicketFull
fields terminated by ','
(id_flight,id_passenger,seat,date_purchase)
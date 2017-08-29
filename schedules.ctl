load infile schedules.csv stream
replace into table Schedule_Time
fields terminated by ','
(id_schedule,schedule_time)
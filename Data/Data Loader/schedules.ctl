load infile schedules.csv stream
replace into table ScheduleTime
fields terminated by ','
(id_schedule,schedule_time)
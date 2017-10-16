load infile schedules.csv stream
replace into table ScheduleTimeFull
fields terminated by ','
(id_schedule,schedule_time)
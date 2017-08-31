#!/bin/bash

clear

sqlldr a1207563@qro/DTAPfRtO control=continents.ctl
echo "Tabla Continent cargada"

sqlldr a1207563@qro/DTAPfRtO control=countries.ctl
echo "Tabla Country cargada"

sqlldr a1207563@qro/DTAPfRtO control=cities.ctl
echo "Tabla Cities cargada"

sqlldr a1207563@qro/DTAPfRtO control=airports.ctl
echo "Tabla Airport cargada"

sqlldr a1207563@qro/DTAPfRtO control=routes.ctl
echo "Tabla Route cargada"

sqlldr a1207563@qro/DTAPfRtO control=schedules.ctl
echo "Tabla ScheduleTime cargada"

sqlldr a1207563@qro/DTAPfRtO control=aiplanes.ctl
echo "Tabla Airplane cargada"

sqlldr a1207563@qro/DTAPfRtO control=passengers.ctl
echo "Tabla Passenger cargada"


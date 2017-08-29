#!/bin/bash

clear

sqlldr a1360926@qro/Mqq7bJxc control=airplanes.ctl
echo "Tabla Airplane cargada"

sqlldr a1360926@qro/Mqq7bJxc control=airports.ctl
echo "Tabla Airport cargada"

sqlldr a1360926@qro/Mqq7bJxc control=cities.ctl
echo "Tabla Cities cargada"

sqlldr a1360926@qro/Mqq7bJxc control=continents.ctl
echo "Tabla Continent cargada"

sqlldr a1360926@qro/Mqq7bJxc control=countries.ctl
echo "Tabla Country cargada"

sqlldr a1360926@qro/Mqq7bJxc control=passengers.ctl
echo "Tabla Passenger cargada"

sqlldr a1360926@qro/Mqq7bJxc control=routes.ctl
echo "Tabla Route cargada"

sqlldr a1360926@qro/Mqq7bJxc control=schedule.ctl
echo "Tabla Schedule_Time cargada"

sqlldr a1360926@qro/Mqq7bJxc control=tickets.ctl
echo "Tabla Ticket cargada"


#!/bin/bash

clear

echo "Loading continents..."
sqlldr a1207563@qro/DTAPfRtO control=continents.ctl silent=feedback
echo "Table CONTINENT ready"

echo "Loading countries..."
sqlldr a1207563@qro/DTAPfRtO control=countries.ctl silent=feedback
echo "Table COUNTRY ready"

echo "Loading cities..."
sqlldr a1207563@qro/DTAPfRtO control=cities.ctl silent=feedback
echo "Table CITY ready"

echo "Loading aiports..."
sqlldr a1207563@qro/DTAPfRtO control=airports.ctl silent=feedback
echo "Table AIRPORT ready"

echo "Loading routes..."
sqlldr a1207563@qro/DTAPfRtO control=routes.ctl silent=feedback
echo "Table ROUTE ready"

echo "Loading schedules..."
sqlldr a1207563@qro/DTAPfRtO control=schedules.ctl silent=feedback
echo "Table SCHEDULETIME ready"

echo "Loading airplanes..."
sqlldr a1207563@qro/DTAPfRtO control=airplanes.ctl silent=feedback
echo "Table AIRPLANE ready"

echo "Loading passengers..."
sqlldr a1207563@qro/DTAPfRtO control=passengers.ctl silent=feedback
echo "Table PASSENGER ready"

echo "Loading flights..."
sqlldr a1207563@qro/DTAPfRtO control=flights.ctl silent=feedback
echo "Table FLIGHT ready"

echo "Loading tickets..."
sqlldr a1207563@qro/DTAPfRtO control=tickets.ctl silent=feedback
echo "Table TICKET ready"



from datetime import datetime
import calendar
import itertools
import names
import random

CONTINENT_COUNTRY = {
    'Europe': [
            'Austria', 'Belgium', 'Denmark', 'Finland', 'France', 'Germany',
            'Italy', 'Netherlands', 'Norway', 'Spain', 'Sweden', 'UK'
        ],
    'America': [
        'Argentina', 'Brazil', 'Canada', 'Chile', 'Colombia', 'Mexico', 'Uruguay', 'USA', 
    ],
    'Asia': [
        'China', 'India', 'Japan', 'Russia', 'Singapore',
        'South Korea', 'Thailand', 'United Arab Emirates', 'Vietnam'
    ],
    'Oceania': [
        'Australia', 'Fiji', 'New Zealand'
    ]
}

COUNTRY_CITY = {
    'Austria': ['Vienna'], 'Belgium': ['Brussels'], 'Denmark': ['Copenhagen'], 'Finland': ['Helsinki'],
    'France': ['Paris', 'Lyon'], 'Germany': ['Frankfurt', 'Hambourg'], 'Italy': ['Rome', 'Florence'],
    'Netherlands': ['Amsterdam'], 'Norway': ['Oslo'], 'Spain': ['Madrid'], 'Sweden': ['Stockholm'], 'UK': ['London'],
    'Argentina': ['Buenos Aires'], 'Brazil': ['Sao Paolo'], 'Canada': ['Vancouver', 'Quebec', 'Alberta'], 
    'Chile': ['Santiago'], 'Colombia': ['Medellin'], 'Mexico': ['Mexico City', 'Monterrey', 'Queretaro'],
    'Uruguay': ['Montevideo'], 'USA': ['San Francisco', 'New York', 'Seattle', 'Miami', 'Chicago'],
    'China': ['Hong Kong', 'Beijing'], 'India': ['Mumbai'], 'Japan': ['Tokio'], 'Russia': ['Moscow'],
    'Singapore': ['Tampines'], 'South Korea': ['Seul'], 'Thailand': ['Bangkok'], 'United Arab Emirates': ['Dubai'],
    'Vietnam': ['Hanoi'], 'Australia': ['Melbourne', 'Sydney'], 'Fiji': ['Suva'], 'New Zealand': ['Wellignton']
}

PLANES = [
    'Rocket', 'Flash', 'Rabbit', 'Galaxy', 'Star', 'Sunset', 'BlackPearl', 'Lighting McQueen', 'Voldemort',
    'Waterfall', 'Snow', 'Strong Wind', 'Eter', 'Socrates', 'Spell', 'Crow', 'Night King', 'Dragon', 'Wish', 'DeathStar',
]


def create_continent_data():
    print('Creating continents...')
    continent_file = open('continents.csv', 'w')
    continents = ['Europe', 'America', 'Asia', 'Oceania']
    continents_dic = {key: index+1 for index, key in enumerate(continents)}
    for key, i in continents_dic.items():
        continent_file.write('{},{}\n'.format(i, key))
    continent_file.close()
    return continents_dic


def create_country_data(continents):
    print('Creating countries...')
    country_file = open('countries.csv', 'w')
    all_countries = {}
    for continent, i in continents.items():
        countries_dic = {country: index+1+len(all_countries) for index, country in enumerate(CONTINENT_COUNTRY[continent])}
        all_countries.update(countries_dic)
        for country, index in countries_dic.items():
            country_file.write('{},{},{}\n'.format(index, country, i))
    country_file.close()
    return all_countries


def create_city_data(countries):
    print('Creating cities...')
    city_file = open('cities.csv', 'w')
    all_cities = {}
    for country, i in countries.items():
        cities_dic = {city: index+1+len(all_cities) for index, city in enumerate(COUNTRY_CITY[country])}
        all_cities.update(cities_dic)
        for city, index in cities_dic.items():
            city_file.write('{},{},{}\n'.format(index, city, i))
    city_file.close()
    return all_cities


def create_airport_data(cities):
    print('Creating airports...')
    airport_file = open('airports.csv', 'w')
    all_airports = {}
    index = 1
    for city, i in cities.items():
        all_airports[city+' airport'] = index
        airport_file.write('{},{},{}\n'.format(index, city+' airport', i))
        index += 1
    airport_file.close()
    return all_airports


def create_users_data():
    user_file = open('passengers.csv', 'w')
    num_of_users = int(input('How many users? '))
    print('Creating users...')
    users_id = [x+1 for x in range(num_of_users)]
    for user_id in users_id:
        first, last = names.get_first_name(), names.get_last_name()
        user_file.write('{},{},{},{}\n'.format(user_id, first, last, first.lower()+'.'+last.lower()+'@mail.com'))
    user_file.close()
    return users_id


def create_airplane_data():
    airplane_file = open('airplanes.csv', 'w')
    print('Creating airplanes...')
    planeID_capacity = {}
    for i in range(len(PLANES)):
        if i % 3 == 0:
            planeID_capacity[i+1] = 300
        elif i % 3 == 1:
            planeID_capacity[i+1] = 200
        else:
            planeID_capacity[i+1] = 100
        airplane_file.write('{},{},{}\n'.format(i+1, PLANES[i], planeID_capacity[i+1]))
    airplane_file.close()
    return planeID_capacity


def create_schedule_data():
    print('Creating schedules...')
    schedule_file = open('schedules.csv', 'w')
    scheduleID = [x for x in range(1,24)]
    for i in range(1,24):
        schedule_file.write('{},{}\n'.format(i, str(i)+':00'))
    schedule_file.close()
    return scheduleID


def create_routes_data(airports):
    print('Creating routes...')
    route_file = open('routes.csv', 'w')
    airportsID = [i for _,i in airports.items()]
    routes = list(itertools.combinations(airportsID, 2))
    airportsID.reverse()
    routes += list(itertools.combinations(airportsID, 2))
    routesID = [x+1 for x in range(len(routes))]
    for i, route in enumerate(routes):
        route_file.write('{},{},{},{}\n'.format(i+1, route[0], route[1], random.randint(60, 800)))
    route_file.close()
    return routesID


def create_flight_data(routes, schedules, airplanes_capacity):
    num_flights = int(input('How many flights? '))    
    print('Creating flights...')
    flight_file = open('flights.csv', 'w')
    flightsID_capacity = {}
    airplanes = [k for k,_ in airplanes_capacity.items()]
    for i in range(num_flights):
        current_date = datetime(2017, random.randint(1, 12), random.randint(1, 28))
        date_srt = str(current_date.day)+'-'+calendar.month_abbr[current_date.month]+'-'+str(current_date.year)
        current_route = routes[random.randint(0, len(routes)-1)]
        current_schedule = schedules[random.randint(0, len(schedules)-1)]
        current_airplane = airplanes[random.randint(0, len(airplanes)-1)]
        current_price, current_ontime = random.randint(100,2000), random.randint(0,1)
        flight_file.write('{},{},{},{},{},{},{}\n'.format(i+1, current_route, current_schedule, current_airplane, current_price, date_srt, current_ontime))
        flightsID_capacity[i+1] = airplanes_capacity[current_airplane]
    flight_file.close()
    return flightsID_capacity


def create_ticket_data(flights_capacity, users):
    num_tickets = int(input('How many tickets?'))
    flights_capacity_original = dict(flights_capacity)
    print('Creating tickets...')
    ticket_file = open('tickets.csv', 'w')
    flights = [k for k,_ in flights_capacity.items()]
    for i in range(num_tickets):
        current_flight = flights[random.randint(0, len(flights)-1)]
        flights_capacity[current_flight] -= 1
        if flights_capacity[current_flight] == 0:
            flights.remove(current_flight)
            if len(flights) < 1:
                return
        current_user = users[random.randint(0, len(users)-1)]
        current_date = datetime(2016, random.randint(1, 12), random.randint(1, 28))
        date_srt = str(current_date.day)+'-'+calendar.month_abbr[current_date.month]+'-'+str(current_date.year)
        current_seat = flights_capacity_original[current_flight] - flights_capacity[current_flight]
        ticket_file.write('{},{},{},{}\n'.format(current_flight, current_user, current_seat, date_srt))
    ticket_file.close()


def main():
    continents = create_continent_data()
    countries = create_country_data(continents)
    cities = create_city_data(countries)
    airports = create_airport_data(cities)
    users = create_users_data()
    airplanes_capacity = create_airplane_data()        
    schedules = create_schedule_data()
    routes = create_routes_data(airports)
    flights_capacity = create_flight_data(routes, schedules, airplanes_capacity)
    create_ticket_data(flights_capacity, users)

if __name__ == "__main__":
    main()
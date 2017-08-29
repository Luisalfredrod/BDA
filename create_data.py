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


def create_continent_data():
    print('Creating continents...')
    continent_file = open("continents.csv", "w")
    continents = ['Europe', 'America', 'Asia', 'Oceania']
    continents_dic = {key: index+1 for index, key in enumerate(continents)}
    for key, i in continents_dic.items():
        continent_file.write('{},{}\n'.format(i, key))
    continent_file.close()
    return continents_dic


def create_country_data(continents):
    print('Creating countries...')
    country_file = open("countries.csv", "w")
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
    city_file = open("cities.csv", "w")
    all_cities = {}
    for country, i in countries.items():
        cities_dic = {city: index+1+len(all_cities) for index, city in enumerate(COUNTRY_CITY[country])}
        all_cities.update(cities_dic)
        for city, index in cities_dic.items():
            city_file.write('{},{},{}\n'.format(index, city, i))
    city_file.close()
    return all_cities


def main():
    continents = create_continent_data()
    countries = create_country_data(continents)
    cities = create_city_data(countries)

if __name__ == "__main__":
    main()
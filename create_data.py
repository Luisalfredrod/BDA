


def create_continent_data():
    continent_file = open("continents.csv", "w")
    continents = ['Europe', 'America', 'Asia', 'Oceania']
    continents_dic = {key: index+1 for index, key in enumerate(continents)}
    for key, i in continents_dic.items():
        continent_file.write('{},{}\n'.format(i, key))
    continent_file.close()
    return continents_dic

def get_countries_by_continent(cont):
    countries = []
    if cont == 'Europe':
        countries = [
            'Austria', 'Belgium', 'Croatia', 'Denmark', 'Finland', 'France', 
            'Germany', 'Italy', 'Netherlands', 'Norway', 'Spain', 'Sweden', 'UK'
        ]
    elif cont == 'America':
        countries = [
            'Argentina', 'Brazil', 'Canada', 'Chile', 'Colombia', 'Mexico', 'Uruguay', 'USA', 
        ]
    elif cont == 'Asia':
        countries = [
            'China', 'India', 'Japan', 'Malaysia', 'Russia', 'Saudi Arabia', 'Singapore',
            'South Korea', 'Thailand', 'United Arab Emirates', 'Vietnam'
        ]
    elif cont == 'Oceania':
        countries = [
            'Australia', 'Fiji', 'New Zealand'
        ]
    return countries

def create_country_data(continents):
    country_file = open("countries.csv", "w")
    all_countries = {}
    for key, i in continents.items():
        countries_dic = {country: index+1 for index, country in enumerate(get_countries_by_continent(key))}
        all_countries.update(countries_dic)
        for country, index in countries_dic.items():
            country_file.write('{},{},{}\n'.format(index, country, i))
    country_file.close()
    return all_countries

def main():
    continents = create_continent_data()
    countries = create_country_data(continents)
    print(countries)

if __name__ == "__main__":
    main()
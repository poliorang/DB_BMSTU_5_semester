
class Songs():
    songid = int()
    namesong = str()
    authorsong = str()
    countryid = int()
    releasesong = str()
    genresong = str()
    durationsong = float()

    def __init__(self, songid, namesong, authorsong, countryid,
                    releasesong, genresong, durationsong):
        self.songid = songid
        self.namesong = namesong
        self.authorsong = authorsong
        self.countryid = countryid
        self.releasesong = releasesong
        self.genresong = genresong
        self.durationsong = durationsong

    def get(self):
        return {'songid': self.songid, 'namesong': self.namesong, 'authorsong': self.authorsong,
                'countryid': self.countryid, 'release_song': self.releasesong,
                'genresong': self.genresong, 'durationsong': self.durationsong}

    def __str__(self):
        return f"{self.songid:<2} {self.namesong:<30} {self.authorsong:<28} " \
               f"{self.countryid:<10} {self.releasesong:<13}" \
               f"{self.genresong:<12} {self.durationsong:<5}"


class Country():
    countryid = int()
    namecountry = str()

    def __init__(self, countryid, namecountry):
        self.countryid = countryid
        self.namecountry = namecountry

    def get(self):
        return {'countryid': self.countryid, 'namecountry': self.namecountry}

    def __str__(self):
        return f"{self.countryid:<6} {self.namecountry:<20}"


def create_song(file_name):
    file = open(file_name, 'r')
    songs = list()

    count = 0
    for line in file:
        arr = line.split(';')

        result = [count, arr[0], arr[1], int(arr[2]), arr[3], arr[4], float(arr[5])]
        count += 1
        songs.append(Songs(*result).get())

    return songs


def create_country(file_name):
    file = open(file_name, 'r')
    counties = list()
    count = 0
    for line in file:
        result = [int(count), line[:-2]]
        count += 1
        counties.append(Country(*result).get())

    return counties
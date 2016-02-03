#!/usr/bin/env python3

# TODO: Clean and comment code

import csv

def quoteescape(str):
    return str.replace("'", r"\'").replace("\n", '')

def stationtype2sql(name):
    return "INSERT INTO station_type(name)VALUES(E'%s');" \
        % (quoteescape(name))

def station2sql(name, address, p_lng, p_lat, source, remarks, type):
    if ('' == name):
        return ''
    return "INSERT INTO station(name,address,position,source,remarks,type)" \
        "VALUES(E'%s',E'%s',ST_GeographyFromText('SRID=4326;POINT(%f %f)')" \
        ",E'%s',E'%s',%d);" \
        % (quoteescape(name), quoteescape(address), float(p_lng), \
            float(p_lat), quoteescape(source), quoteescape(remarks), type)

print(stationtype2sql('Station Tesla'))
csvfile = open('../../data/raw/20160601_-_TESLA_-_CSV.csv', \
    encoding = 'latin-1')
csvreader = csv.reader(csvfile, delimiter=',', quotechar='"')
next(csvreader)
for row in csvreader:
    print(station2sql(row[1], row[2], row[4], row[3], 'Data.gouv.fr', row[10], \
        1))
csvfile.close()

print(stationtype2sql('Concession Nissan'))
csvfile = open( \
    '../../data/raw/BORNES_DE_RECHARGE_RAPIDE_CONCESSIONS_NISSAN.csv', \
    encoding = 'utf-8')
csvreader = csv.reader(csvfile, delimiter=',', quotechar='"')
next(csvreader)
for row in csvreader:
    print(station2sql(row[0], row[2] + ', ' + row[3] + ' ' + row[5], row[11], \
        row[10], 'Data.gouv.fr', row[12], 2))
csvfile.close()

print(stationtype2sql('Magasin E. Leclerc'))
csvfile = open( \
    '../../data/raw/BornesRecharge2014_1.csv', encoding = 'utf-8')
csvreader = csv.reader(csvfile, delimiter=',', quotechar='"')
next(csvreader)
for row in csvreader:
    print(station2sql(row[1], row[2], row[4], row[3], 'Data.gouv.fr', row[10], \
        3))
csvfile.close()

print(stationtype2sql('Parking EFFIA'))
csvfile = open( \
    '../../data/raw/Stations-recharge-VE-EFFIA.csv', encoding = 'utf-8')
csvreader = csv.reader(csvfile, delimiter=',', quotechar='"')
next(csvreader)
next(csvreader)
for row in csvreader:
    print(station2sql(row[1], row[2], row[4], row[3], 'Data.gouv.fr', row[10], \
        4))
csvfile.close()

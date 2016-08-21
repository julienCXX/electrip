import json
import psycopg2
from postgis import register, Point

import app_config

_db = psycopg2.connect(user=app_config.DB_USER,
                       password=app_config.DB_PASSWORD,
                       dbname=app_config.DB_NAME)
_cursor = _db.cursor()
register(_cursor)


def get_station_types():
    query = """
              SELECT id, name
                FROM station_type
            ORDER BY id;
            """
    _cursor.execute(query)
    result = []
    for row in _cursor:
        result.append({'id': row[0], 'name': row[1]})
    return result


def get_stations():
    query = """
            SELECT id, name, address, ST_AsGeoJSON(position), source, remarks
              FROM station
             WHERE type = %d;
            """
    result = {}
    for s_type in get_station_types():
        _cursor.execute(query % (s_type['id']))
        stations = []
        for row in _cursor:
            jsonRowCoords = json.loads(row[3])['coordinates']
            stations.append({
                'id': row[0],
                'name': row[1],
                'address': row[2],
                'position': [jsonRowCoords[1], jsonRowCoords[0]],
                'source': row[4],
                'remarks': row[5]
            })
        result[s_type['id']] = stations
    return result


def get_euclidean_distance(p1, p2):
    "Returns the distance (crow-fly) between 2 points (in meters)"

    query = """
            SELECT ST_Distance(ST_GeographyFromText('%s'),
                   ST_GeographyFromText('%s'));
            """ % (p1, p2)
    _cursor.execute(query)
    return int(next(_cursor)[0])


def get_candidate_charge_points(
            start, finish, max_dist_from_finish, station_types, drive_range):
    str_types = str(station_types)[1:-1]
    if '' == str_types:
        return []

    query = """
              SELECT ST_AsGeoJSON(position), address, station.id
                FROM station, station_type
               WHERE station_type.id = type
                 AND type IN (%s)
                 AND ST_Distance(position, ST_GeographyFromText('%s')) < %d
                 AND ST_Distance(position, ST_GeographyFromText('%s')) > %d
                 AND ST_Distance(position, ST_GeographyFromText('%s')) < %d
            ORDER BY ST_Distance(position, ST_GeographyFromText('%s'));
            """
    query = query % (
         str_types, start, drive_range, start, drive_range / 2,
         finish, max_dist_from_finish, finish)
    _cursor.execute(query)
    candidates = []
    for row in _cursor:
        jsonRowCoords = json.loads(row[0])['coordinates']
        candidates.append({
            'position': Point(x=jsonRowCoords[0], y=jsonRowCoords[1]),
            # 'address': row[1],
            'id': row[2]
        })
    return candidates

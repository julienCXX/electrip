#! /usr/bin/env python3

import sys

import psycopg2
from postgis import register, Point

import requests

import json

OSRM_URL = 'http://router.project-osrm.org/'

def getEuclideanDistance(p1, p2, cursor):
    "Returns the distance (crow-fly) between 2 points (in meters)"

    query = "SELECT ST_Distance(ST_GeographyFromText('%s'), " \
        "ST_GeographyFromText('%s'));" % (p1, p2)
    cursor.execute(query)
    return int(next(cursor)[0])

def getEffectiveDistance(p1, p2):
    "Returns the distance (using roads) between 2 points (in meters)"

    query = OSRM_URL + \
        'viaroute?loc=%f,%f&loc=%f,%f&alt=false&geometry=false' \
        % (p1.y, p1.x, p2.y, p2.x)
    response = requests.get(url = query)
    return response.json()['route_summary']['total_distance']

class RoutePlanner:
    "Computes a route using an optimized set of charging stations as viapoints"

    def __init__(self, start, finish, drive_range, station_types, cursor):
        self.start = start
        self.finish = finish
        self.drive_range = drive_range * 1000 # km -> m
        self.station_types = station_types
        self.cursor = cursor

    def getCandidateChargePoints(self, start, finish, max_dist_from_finish):
        str_types = str(self.station_types)[1:-1]
        query = "SELECT ST_AsGeoJSON(position), address, station.id " \
                "FROM station, station_type " \
                "WHERE station_type.id = type " \
                "AND type IN (%s) " \
                "AND ST_Distance(position, ST_GeographyFromText('%s')) " \
                "< %d " \
                "AND ST_Distance(position, ST_GeographyFromText('%s')) " \
                "> %d " \
                "AND ST_Distance(position, ST_GeographyFromText('%s')) < %d " \
                "ORDER BY ST_Distance(position, ST_GeographyFromText('%s'));"
        query = query % (str_types, start, self.drive_range, start,
                self.drive_range / 2, finish, max_dist_from_finish, finish)
        cursor.execute(query)
        candidates = []
        for row in cursor:
            jsonRowCoords = json.loads(row[0])['coordinates']
            candidates.append({
                'position': Point(x = jsonRowCoords[0], y = jsonRowCoords[1]),
                #'address': row[1],
                'id': row[2]
            })
        return candidates

    def plan(self):
        return self.findChargePoints(self.start, self.finish, #[],
            sys.maxsize)

    def findChargePoints(self, start, finish, #blacklisted_stations,
            previous_dist_from_finish):
        if getEuclideanDistance(start, finish, self.cursor) \
            < self.drive_range \
            and getEffectiveDistance(start, finish) < self.drive_range * 1000:
            # No need for intermediate charging station
            return {'route_found': True, 'stations': []}

        candidates = self.getCandidateChargePoints(start, finish,
            previous_dist_from_finish)
        #candidates_positions = []
        #for candidate in candidates:
        #    candidates_positions = candidates_positions + \
        #        [candidate['position']]
        for candidate in candidates:
            #print(candidate)
            #print(previous_stations)
            cand_pos = candidate['position']
            #if cand_pos not in blacklisted_stations \
            if getEffectiveDistance(start, cand_pos) \
                < self.drive_range:
                # Add this station to the trip and go on
                #curr_blacklisted_stations = blacklisted_stations + \
                #    candidates_positions
                curr_eucl_dist = getEuclideanDistance(cand_pos, finish,
                    self.cursor)
                next_stations = self.findChargePoints(cand_pos, self.finish,
                    #curr_blacklisted_stations,
                    curr_eucl_dist)
                if next_stations['route_found']:
                    return {'route_found': True,
                        'stations': [candidate] + next_stations['stations']}

        return {'route_found': False}

if __name__ == '__main__':
    db = psycopg2.connect(user = "cod", dbname = "cod")
    cursor = db.cursor()
    register(cursor)

    start = Point(x = 1.4442469, y = 43.6044622, srid = 4326) # Toulouse
    finish = Point(x = 5.7210773, y = 45.182478, srid = 4326) # Grenoble
    #finish = Point(x = -0.422919, y = 43.320557, srid = 4326) # 64
    drive_range = 153 # in km
    types = [2, 3, 4]
    planner = RoutePlanner(start, finish, drive_range, types, cursor)
    route = planner.plan()
    print("Route: ", route)
    #dist = getEffectiveDistance(start, finish)
    #print(dist)
    #dist = getEuclideanDistance(start, finish, cursor)
    #print(dist)
    #print(planner.getCandidateChargePoints(start, finish))

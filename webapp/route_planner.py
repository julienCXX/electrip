#! /usr/bin/env python3

import sys

import psycopg2
from postgis import register, Point
import json

import queries.db as db_queries
import queries.routing as routing_queries
import app_config

class RoutePlanner:
    "Computes a route using an optimized set of charging stations as viapoints"

    def __init__(self, start, finish, drive_range, station_types, cursor):
        self.start = start
        self.finish = finish
        self.drive_range = drive_range # in meters
        self.station_types = station_types
        self.cursor = cursor

    def plan(self, zoom_level = 0):
        result = self.findChargePoints(self.start, self.finish, #[],
                sys.maxsize)
        return routing_queries.get_routing_instructions(self.start, self.finish,
                result, zoom_level)

    def findChargePoints(self, start, finish, #blacklisted_stations,
            previous_dist_from_finish):
        if db_queries.get_euclidean_distance(start, finish) < self.drive_range \
                and routing_queries.get_effective_distance(start, finish) \
                < self.drive_range:
            # No need for intermediate charging station
            return {'route_found': True, 'stations': []}

        candidates = db_queries.get_candidate_charge_points(start, finish,
                previous_dist_from_finish, self.station_types, self.drive_range)
        #candidates_positions = []
        #for candidate in candidates:
        #    candidates_positions = candidates_positions + \
        #        [candidate['position']]
        for candidate in candidates:
            #print(candidate)

            #print(previous_stations)
            cand_pos = candidate['position']
            #if cand_pos not in blacklisted_stations \
            if routing_queries.get_effective_distance(start, cand_pos) \
                < self.drive_range:
                # Add this station to the trip and go on
                #curr_blacklisted_stations = blacklisted_stations + \
                #    candidates_positions
                curr_eucl_dist = db_queries.get_euclidean_distance(cand_pos,
                        finish)
                next_stations = self.findChargePoints(cand_pos, self.finish,
                    #curr_blacklisted_stations,
                    curr_eucl_dist)
                if next_stations['route_found']:
                    return {'route_found': True,
                        'stations': [candidate] + next_stations['stations']}

        return {'route_found': False, 'stations': []}

class CachedRoutePlanner:
    def __init__(self, cursor):
        self.cursor = cursor
        self.cached_queries = {}

    def strip_station_positions(self, result):
        light_stations = []
        for station in result['stations']:
            light_stations += [station['id']]
        result['stations'] = light_stations

    def plan(self, start, finish, drive_range, station_types, zoom):
        key = {'start_lng': start.x, 'start_lat': start.y, 'finish_lng':
            finish.x, 'finish_lat': finish.y, 'drive_range': drive_range,
            'station_types': station_types}
        key = json.dumps(key)
        if key in self.cached_queries:
            if zoom in self.cached_queries[key]:
                return self.cached_queries[key][zoom]
            else:
                # Stations are already present for this query
                planner = RoutePlanner(start, finish, drive_range,
                    station_types, self.cursor)
                charge_points = {}
                charge_points['stations'] = self.cached_queries[key]['stations']
                charge_points['route_found'] = (charge_points['stations'] != [])
                result = routing_queries.get_routing_instructions(start, finish,
                        charge_points, zoom)
                self.strip_station_positions(result)
                self.cached_queries[key][zoom] = result
                return result
        else:
            planner = RoutePlanner(start, finish, drive_range, station_types,
                self.cursor)
            result = planner.plan(zoom)
            self.cached_queries[key] = {}
            self.cached_queries[key]['stations'] = result['stations']
            self.strip_station_positions(result)
            self.cached_queries[key][zoom] = result
            return result

if __name__ == '__main__':
    db = psycopg2.connect(user = app_config.DB_USER,
        password = app_config.DB_PASSWORD, dbname = app_config.DB_NAME)
    cursor = db.cursor()
    register(cursor)

    start = Point(x = 1.4442469, y = 43.6044622, srid = 4326) # Toulouse
    finish = Point(x = 5.7210773, y = 45.182478, srid = 4326) # Grenoble
    #finish = Point(x = -0.422919, y = 43.320557, srid = 4326) # 64
    drive_range = 153 # in km
    types = [2, 3, 4]
    #planner = RoutePlanner(start, finish, drive_range, types, cursor)
    #route = planner.plan()
    #print("Route: ", route)
    #dist = getEffectiveDistance(start, finish)
    #print(dist)
    #dist = getEuclideanDistance(start, finish, cursor)
    #print(dist)
    #print(planner.getCandidateChargePoints(start, finish))

    # Needs extensive testing
    cache = CachedRoutePlanner(cursor)
    route = cache.plan(start, finish, drive_range, types, 0)
    print("Route 0: ", route)
    route = cache.plan(start, finish, drive_range, types, 11)
    print("Route 11: ", route)

import sys
import json

import queries.db as db_queries
import queries.routing as routing_queries
import utils


class RoutePlanner:
    "Computes a route using an optimized set of charging stations as viapoints"

    def __init__(self, start, finish, drive_range, station_types):
        self.start = start
        self.finish = finish
        self.drive_range = drive_range  # in meters
        self.station_types = station_types

    def plan(self, zoom_level=0):
        result = self.findChargePoints(self.start, self.finish, sys.maxsize)
        return routing_queries.get_routing_instructions(
            self.start, self.finish, result, zoom_level)

    def findChargePoints(self, start, finish, previous_dist_from_finish):
        if db_queries.get_euclidean_distance(start, finish) \
                < self.drive_range \
                and routing_queries.get_effective_distance(start, finish) \
                < self.drive_range:
            # No need for intermediate charging station
            return {'route_found': True, 'stations': []}

        candidates = db_queries.get_candidate_charge_points(
            start, finish, previous_dist_from_finish, self.station_types,
            self.drive_range)
        for cand_pos, cand_id in candidates:
            if routing_queries.get_effective_distance(start, cand_pos) \
                    < self.drive_range:
                # Add this station to the trip and go on
                curr_eucl_dist = db_queries.get_euclidean_distance(cand_pos,
                                                                   finish)
                next_stations = self.findChargePoints(cand_pos, self.finish,
                                                      curr_eucl_dist)
                if next_stations['route_found']:
                    return {'route_found': True,
                            'stations': [{'position': cand_pos, 'id': cand_id}]
                            + next_stations['stations']}

        return {'route_found': False, 'stations': []}


class CachedRoutePlanner:
    def __init__(self):
        self.cached_queries = {}

    def strip_station_positions(self, result):
        light_stations = []
        for station in result['stations']:
            light_stations += [station['id']]
        result['stations'] = light_stations

    def plan(self, start, finish, drive_range, station_types, zoom):
        t_start = utils.point_to_coords(start)
        t_finish = utils.point_to_coords(finish)
        key = {'start_lng': t_start[1], 'start_lat': t_start[0],
               'finish_lng': t_finish[1], 'finish_lat': t_finish[0],
               'drive_range': drive_range, 'station_types': station_types}
        key = json.dumps(key)
        if key in self.cached_queries:
            if zoom in self.cached_queries[key]:
                return self.cached_queries[key][zoom]
            else:
                # Stations are already present for this query
                planner = RoutePlanner(start, finish, drive_range,
                                       station_types)
                charge_pts = {}
                charge_pts['stations'] = self.cached_queries[key]['stations']
                charge_pts['route_found'] = \
                    self.cached_queries[key]['route_found']
                result = routing_queries.get_routing_instructions(
                    start, finish, charge_pts, zoom)
                self.strip_station_positions(result)
                self.cached_queries[key][zoom] = result
                return result
        else:
            planner = RoutePlanner(start, finish, drive_range, station_types)
            result = planner.plan(zoom)
            self.cached_queries[key] = {}
            self.cached_queries[key]['stations'] = result['stations']
            self.cached_queries[key]['route_found'] = result['route_found']
            self.strip_station_positions(result)
            self.cached_queries[key][zoom] = result
            return result

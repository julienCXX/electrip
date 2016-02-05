#! /usr/bin/env python3

import cherrypy
import os
from mako.template import Template

import psycopg2
from postgis import register, Point

import json

from route_planner import CachedRoutePlanner

PHOTON_URL = 'http://photon.komoot.de/'

class ElectripBackend(object):
    def __init__(self, cursor):
        self.cursor = cursor
        self.planner = CachedRoutePlanner(cursor)

    @cherrypy.expose
    def index(self):
        template = Template(filename = './frontend/index.html',
            input_encoding='utf-8')
        return template.render(PHOTON_URL = PHOTON_URL,
            station_types = self.getStationTypes(),
            stations = self.getStations())

    def getStationTypes(self):
        query = "SELECT id, name " \
                "FROM station_type " \
                "ORDER BY id;"
        self.cursor.execute(query)
        result = []
        for row in cursor:
            result.append({'id': row[0], 'name': row[1]})
        return result

    def getStations(self):
        query = "SELECT id, name, address, ST_AsGeoJSON(position), source, " \
                "remarks " \
                "FROM station " \
                "WHERE type = %d;"
        result = {}
        for s_type in self.getStationTypes():
            self.cursor.execute(query % (s_type['id']))
            stations = []
            for row in cursor:
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

    @cherrypy.expose
    def route(self, params):
        dec_params = json.loads(params)
        start = Point(x = dec_params['start']['lng'],
                y = dec_params['start']['lat'])
        finish = Point(x = dec_params['finish']['lng'],
                y = dec_params['finish']['lat'])
        drive_range = int(dec_params['range'])
        types = dec_params['types']
        zoom = int(dec_params['zoom'])
        route = self.planner.plan(start, finish, drive_range, types, zoom)
        return json.dumps(route)

if __name__ == '__main__':
    conf = {
        '/': {
            'tools.sessions.on': True,
            'tools.staticdir.root': os.path.abspath(os.getcwd())
        },
        '/leaflet': {
            'tools.staticdir.on': True,
            'tools.staticdir.dir': './frontend/leaflet'
        }
    }
    db = psycopg2.connect(user = "cod", dbname = "cod")
    cursor = db.cursor()
    register(cursor)
    backend = ElectripBackend(cursor)
    cherrypy.quickstart(backend, '/', conf)

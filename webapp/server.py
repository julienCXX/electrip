#! /usr/bin/env python3

from bottle import Bottle, request, static_file, view, template

import os
from mako.template import Template

import psycopg2
from postgis import register, Point

import json

from route_planner import CachedRoutePlanner

import app_config


if __name__ == '__main__':

    app = Bottle()

    APP_BASEDIR = os.path.dirname(os.path.realpath(__file__))

    db = psycopg2.connect(user = app_config.DB_USER,
        password = app_config.DB_PASSWORD, dbname = app_config.DB_NAME)
    cursor = db.cursor()
    register(cursor)

    planner = CachedRoutePlanner(cursor)

    def getStationTypes():
        query = "SELECT id, name " \
                "FROM station_type " \
                "ORDER BY id;"
        cursor.execute(query)
        result = []
        for row in cursor:
            result.append({'id': row[0], 'name': row[1]})
        return result

    def getStations():
        query = "SELECT id, name, address, ST_AsGeoJSON(position), source, " \
                "remarks " \
                "FROM station " \
                "WHERE type = %d;"
        result = {}
        for s_type in getStationTypes():
            cursor.execute(query % (s_type['id']))
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

    @app.route('/')
    @view('index')
    def index():
        return dict(tile_server=app_config.TILE_SERVER,
                photon_url=app_config.PHOTON_URL,
                station_types=getStationTypes(),
                stations=getStations())

    @app.route('/route')
    def route():
        dec_params = json.loads(request.query.params or '{}')
        start = Point(x = dec_params['start']['lng'],
                y = dec_params['start']['lat'])
        finish = Point(x = dec_params['finish']['lng'],
                y = dec_params['finish']['lat'])
        drive_range = int(dec_params['range'])
        types = dec_params['types']
        zoom = int(dec_params['zoom'])
        route = planner.plan(start, finish, drive_range, types, zoom)
        return json.dumps(route)

    @app.route('/leaflet/<filename:path>')
    def send_static(filename):
        return static_file(filename, root=os.path.join(APP_BASEDIR,
                'frontend/leaflet'))


    app.run()

#! /usr/bin/env python3

from bottle import Bottle, TEMPLATE_PATH, request, static_file, view, template

import os
from mako.template import Template

import psycopg2
from postgis import register, Point

import json

import queries.db as db_queries

from route_planner import CachedRoutePlanner

import app_config


if __name__ == '__main__':

    app = Bottle()

    APP_BASEDIR = os.path.dirname(os.path.realpath(__file__))

    # Finding templates from anywhere
    TEMPLATE_PATH.insert(0, os.path.join(APP_BASEDIR, 'views'))

    db = psycopg2.connect(user = app_config.DB_USER,
        password = app_config.DB_PASSWORD, dbname = app_config.DB_NAME)
    cursor = db.cursor()
    register(cursor)

    db_queries._cursor = cursor
    planner = CachedRoutePlanner(cursor)

    @app.route('/')
    @view('index')
    def index():
        return dict(tile_server=app_config.TILE_SERVER,
                photon_url=app_config.PHOTON_URL,
                station_types=db_queries.get_station_types(),
                stations=db_queries.get_stations())

    @app.route('/route')
    def route():
        dec_params = json.loads(request.query.params or '{}')
        start = Point(x = dec_params['start']['lng'],
                y = dec_params['start']['lat'])
        finish = Point(x = dec_params['finish']['lng'],
                y = dec_params['finish']['lat'])
        drive_range = int(dec_params['range']) * 1000 # km -> m
        types = dec_params['types']
        zoom = int(dec_params['zoom'])
        route = planner.plan(start, finish, drive_range, types, zoom)
        return json.dumps(route)

    @app.route('/leaflet/<filename:path>')
    def send_static(filename):
        return static_file(filename, root=os.path.join(APP_BASEDIR,
                'frontend/leaflet'))


    app.run()

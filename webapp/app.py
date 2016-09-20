#!/usr/bin/env python3

"""App entry point"""

import os
from bottle import Bottle, TEMPLATE_PATH, request, static_file, view
import json

import queries.db as db_queries
from route_planner import CachedRoutePlanner
import utils
import app_config

__version__ = '0.3'

application = Bottle()

APP_BASEDIR = os.path.dirname(os.path.realpath(__file__))

# Finding templates from anywhere
TEMPLATE_PATH.insert(0, os.path.join(APP_BASEDIR, 'views'))

planner = CachedRoutePlanner()


@application.route('/')
@view('index')
def index():
    return dict(tile_server=app_config.TILE_SERVER,
                photon_url=app_config.PHOTON_URL,
                map_def=app_config.INITIAL_MAP_SETTINGS,
                station_types=db_queries.get_station_types(),
                stations=db_queries.get_stations_json(), version=__version__)


@application.route('/route')
def find_route():
    dec_params = json.loads(request.query.params or '{}')
    start = utils.coords_to_point((dec_params['start']['lat'],
                                   dec_params['start']['lng']))
    finish = utils.coords_to_point((dec_params['finish']['lat'],
                                    dec_params['finish']['lng']))
    drive_range = int(dec_params['range']) * 1000  # km -> m
    types = dec_params['types']
    zoom = int(dec_params['zoom'])
    route = planner.plan(start, finish, drive_range, types, zoom)
    return json.dumps(route, default=utils.json_encoder)


@application.route('/static/<filename:path>')
def send_static(filename):
    return static_file(filename,
                       root=os.path.join(APP_BASEDIR, 'static'))


if __name__ == '__main__':
    application.run()

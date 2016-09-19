import sys
import requests

from utils import point_to_coords
import app_config


def get_effective_distance(p1, p2):
    "Returns the distance (using roads) between 2 points (in meters)"

    query = app_config.OSRM_URL + \
        'route/v1/driving/%f,%f;' % point_to_coords(p1, False) + \
        '%f,%f?overview=false' % point_to_coords(p2, False)
    response = requests.get(url=query)
    r_json = response.json()
    if 'Ok' == r_json['code']:
        return r_json['routes'][0]['distance']

    # No route available between points
    return sys.maxsize


def get_routing_instructions(start, finish, via_points, zoom_level):
    result = via_points
    if not result['route_found']:
        return result
    query = app_config.OSRM_URL + \
        'route/v1/driving/%f,%f;' % point_to_coords(start, False)
    for point in via_points['stations']:
        query = query + '%f,%f;' % point_to_coords(point['position'], False)
    query = query + \
        '%f,%f' % point_to_coords(finish, False) + \
        '?geometries=geojson&overview=full'
    response = requests.get(url=query)
    response = response.json()
    if 'Ok' != response['code']:
        # No route available between points (TODO: temporary workaround)
        result['route_found'] = False
        return result
    raw_route_geom = response['routes'][0]['geometry']['coordinates']
    result['route_geometry'] = []
    for coord in raw_route_geom:
        result['route_geometry'].append((coord[1], coord[0]))
    return result

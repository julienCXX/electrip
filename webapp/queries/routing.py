import sys
import requests

import app_config


def get_effective_distance(p1, p2):
    "Returns the distance (using roads) between 2 points (in meters)"

    query = app_config.OSRM_URL + \
        'viaroute?loc=%f,%f&loc=%f,%f&alt=false&geometry=false' \
        % (p1.y, p1.x, p2.y, p2.x)
    response = requests.get(url=query)
    r_json = response.json()
    if 'route_summary' in r_json:
        return r_json['route_summary']['total_distance']

    # No route available between points
    return sys.maxsize


def get_routing_instructions(start, finish, via_points, zoom_level):
    result = via_points
    if not result['route_found']:
        return result
    query = app_config.OSRM_URL + 'viaroute?loc=%f,%f' % (start.y, start.x)
    for point in via_points['stations']:
        query = query + '&loc=%f,%f' \
                % (point['position'].y, point['position'].x)
    query = query + \
        '&loc=%f,%f&z=%d&instructions=false&alt=false&compression=false' \
        % (finish.y, finish.x, zoom_level)
    response = requests.get(url=query)
    response = response.json()
    if 'route_geometry' not in response:
        # No route available between points (TODO: temporary workaround)
        result['route_found'] = False
        return result
    result['route_geometry'] = response['route_geometry']
    # result['route_instructions'] = response['route_instructions']
    result['route_summary'] = response['route_summary']
    return result

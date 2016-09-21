from shapely.geometry import mapping, Point
from geoalchemy2.shape import to_shape, from_shape
import geoalchemy2.elements

import model


def point_to_coords(point, reverse=True):
    """
        Converts a GeoAlchemy point WKBElement() to a tuple of coordinates:
        (lat, lng)
    """

    coords = mapping(to_shape(point))['coordinates']
    if reverse:
        return (coords[1], coords[0])
    else:
        return (coords[0], coords[1])


def coords_to_point(point):
    """
        Converts a tuple of coordinates: (lat, lng) to a GeoAlchemy point
        (WKBElement)
    """

    return from_shape(Point(point[1], point[0]), srid=4326)


def json_encoder(obj):
    if isinstance(obj, geoalchemy2.elements.WKBElement):
        return point_to_coords(obj)
    if isinstance(obj, model.Base):
        args = obj.__dict__.copy()
        del args['_sa_instance_state']
        if isinstance(obj, model.StationType):
            args['stations'] = obj.stations
        if isinstance(obj, model.Station):
            del args['type']
        return args

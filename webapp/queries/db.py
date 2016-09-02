import json
from urllib.parse import quote_plus as urlquote
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.sql.expression import func
from geoalchemy2.types import Geography

from model import StationType, Station
import utils
import app_config


_engine = create_engine('postgresql://%s:%s@localhost/%s' %
                        (app_config.DB_USER, urlquote(app_config.DB_PASSWORD),
                         app_config.DB_NAME))
_Session = sessionmaker(bind=_engine)


def get_station_types():
    sess = _Session()
    res = sess.query(StationType).order_by(StationType.id).all()
    sess.close()
    return res


def get_stations_json():
    sess = _Session()
    res = sess.query(StationType).order_by(StationType.id).all()
    res_json = json.dumps(res, default=utils.json_encoder)
    sess.close()
    return res_json


def get_euclidean_distance(p1, p2):
    "Returns the distance (crow-fly) between 2 points (in meters)"

    sess = _Session()
    res = sess.query(func.ST_Distance(p1.cast(Geography),
                     p2.cast(Geography))).one()
    sess.close()
    return res[0]


def get_candidate_charge_points(start, finish, max_dist_from_finish,
                                station_types, drive_range):
    sess = _Session()
    res = sess.query(Station.position, Station.id).\
        filter(Station.type.in_(station_types)).\
        filter(func.ST_Distance(Station.position, start.cast(Geography)) <
               drive_range).\
        filter(func.ST_Distance(Station.position, start.cast(Geography)) >
               drive_range / 2).\
        filter(func.ST_Distance(Station.position, finish.cast(Geography)) <
               max_dist_from_finish).\
        order_by(func.ST_Distance(Station.position,
                                  finish.cast(Geography))).all()
    sess.close()
    return res

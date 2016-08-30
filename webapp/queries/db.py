from contextlib import contextmanager
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


@contextmanager
def _session_scope():
    """Provide a transactional scope around a series of operations."""

    session = _Session()
    try:
        yield session
        session.commit()
    except:
        session.rollback()
        raise
    finally:
        session.close()


def get_station_types():
    with _session_scope() as session:
        return session.query(StationType).order_by(StationType.id)


def get_stations_json():
    return json.dumps(get_station_types().all(), default=utils.json_encoder)


def get_euclidean_distance(p1, p2):
    "Returns the distance (crow-fly) between 2 points (in meters)"

    with _session_scope() as session:
        res = session.query(func.ST_Distance(p1.cast(Geography),
                            p2.cast(Geography))).one()
    return res[0]


def get_candidate_charge_points(start, finish, max_dist_from_finish,
                                station_types, drive_range):
    with _session_scope() as session:
        return session.query(Station.position, Station.id).\
            filter(Station.type.in_(station_types)).\
            filter(func.ST_Distance(Station.position, start.cast(Geography)) <
                   drive_range).\
            filter(func.ST_Distance(Station.position, start.cast(Geography)) >
                   drive_range / 2).\
            filter(func.ST_Distance(Station.position, finish.cast(Geography)) <
                   max_dist_from_finish).\
            order_by(func.ST_Distance(Station.position,
                                      finish.cast(Geography)))

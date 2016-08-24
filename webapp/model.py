from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from sqlalchemy import Column, BigInteger, String, ForeignKey
from geoalchemy2 import Geography

Base = declarative_base()


class StationType(Base):
    __tablename__ = 'station_type'

    id = Column(BigInteger, primary_key=True)
    name = Column(String)
    stations = relationship('Station')


class Station(Base):
    __tablename__ = 'station'

    id = Column(BigInteger, primary_key=True)
    name = Column(String)
    address = Column(String)
    position = Column(Geography(geometry_type='POINT', srid=4326))
    source = Column(String)
    remarks = Column(String)
    type = Column(BigInteger, ForeignKey('station_type.id'))

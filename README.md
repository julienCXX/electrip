# electrip
A trip planning service for electric vehicle owners

Created for the Ensimag’s Open Data Challenge, year 2015-2016

# Prerequisites
* A PostgreSQL DB with PostGIS extension
* Python 3 and the following modules (install with
  `pip install --user <module>`):
    * psycopg2
    * psycopg-postgis
    * requests
    * json
    * cherrypy
    * mako
* A working Photon geocoding instance
* A working tile server instance
* A working OSRM instance

# Installation
* Execute the contents of `data/sql/create_structure.sql` and then, the output
  of `src/utils/importToDb.py`
* Copy the file `src/app/app_config.py.default` to `src/app/app_config.py` and
  edit it to fit your needs

# Execution
* Run the script located at `src/app/server.py`
* Open a Web browser at the URL `localhost:8080`

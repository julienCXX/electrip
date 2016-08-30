# electrip
A trip planning service for electric vehicle owners

Created for the Ensimag’s Open Data Challenge, year 2015-2016

# Changelog
* 0.2
  * Added support for running trough an application server
  * Using SQLAlchemy ORM: fixes potential SQL injections
  * Reorganized client code
  * Fixed start/finish marker display order
* 0.1
  * Refactoring and cleanup of backend code
  * Various bug fixes
  * Switch to Bottle framework
  * Better frontend usability
* COD defense
  * Basic data import
  * Geocoding and route computation
  * Car comparison (not fitted in)

# Prerequisites
* A PostgreSQL DB with PostGIS extension
* Python 3 and the modules described in `requirements.txt` (install with
  `pip install -r requirements.txt`)
* A working Photon geocoding instance
* A working tile server instance
* A working OSRM instance

# Installation
* Execute the contents of `data/sql/create_structure.sql` and then, the output
  of `src/utils/importToDb.py`
* Copy the file `webapp/app_config.py.default` to `webapp/app_config.py` and
  edit it to fit your needs

# Execution
* Run the script located at `webapp/app.py`
* Open a Web browser at the URL `localhost:8080`

# About the `src/challenge` directory
This is the car comparison part of the project.
To use it, you will need a PHP/MySql installation.
Please import data from `data/sql/vehicle.sql` into a database named `codata`.

#! /usr/bin/env python3

import cherrypy
import os
from mako.template import Template

class ElectripBackend(object):
    @cherrypy.expose
    def index(self):
        template = Template(filename = './frontend/index.html',
            input_encoding='utf-8')
        return template.render()

if __name__ == '__main__':
    conf = {
        '/': {
            'tools.sessions.on': True,
            'tools.staticdir.root': os.path.abspath(os.getcwd())
        },
        '/leaflet': {
            'tools.staticdir.on': True,
            'tools.staticdir.dir': './frontend/leaflet'
        }
    }
    cherrypy.quickstart(ElectripBackend(), '/', conf)

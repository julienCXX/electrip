<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8" />
        <title>Electrip − Electric Vehicle Trip Planning</title>
        <link rel="stylesheet" href="/static/css/leaflet.css" />
        <style type="text/css">
body {
    margin: 0;
}
#map {
    position: absolute;
    top: 0;
    bottom: 0;
    width: 100%;
}
#form {
    position: absolute;
    background-color: #ccc;
    border: 1px white solid;
    border-radius: 5px;
    box-shadow: 0 0 10px #444;
    margin: 15px;
    padding: 10px;
}
.input-container > label {
    display: inline-block;
    width: 80px;
    text-align: right;
    margin-right: 10px;
    margin-bottom: 10px;
}
/* See: http://www.w3schools.com/howto/howto_js_dropdown.asp */
.dropdown-container {
    position: relative;
    display: inline-block;
}
.dropdown {
    display: none;
    position: absolute;
    background-color: white;
    border: 1px #aaa solid;
    width: 100%;
    overflow-y: scroll;
    z-index: 100;
}
.dropdown > span {
    display: none;
    padding: 5px;
    color: #c33;
}
.dropdown > ul {
    display: none;
    margin: 0;
    padding: 0;
}
.dropdown li {
    display: block;
    padding: 2px 6px;
    text-decoration: none;
    border-bottom: 1px #aaa solid;
}
.dropdown li:last-child {
    border-bottom: none;
}
.dropdown li:hover {
    background-color: #f0f0f0;
}
.show {
    display: block !important;
}
        </style>
    </head>
    <body>
        <div id="map"></div>
        <form id="form">
            <div class="input-container">
                <label for="from">From</label>
                <div class="dropdown-container">
                    <input id="from" name="from" type="text" autocomplete="off" />
                    <div class="dropdown">
                        <span class="show">No result</span>
                        <ul></ul>
                    </div>
                </div>
                <!--<button>My position</button>-->
            </div>
            <div class="input-container">
                <label for="to">To</label>
                <div class="dropdown-container">
                    <input id="to" name="to" type="text" autocomplete="off" />
                    <div class="dropdown">
                        <span class="show">No result</span>
                        <ul></ul>
                    </div>
                </div>
                <!--<button>My position</button>-->
            </div>
            <div class="input-container">
                <label for="range">Range</label>
                <input id="range" name="range" type="number" min="0"
                value="200" autocomplete="off" onchange="invalidateTrip()"/>km
            </div>
            Charging station types:<br />
            <div id=station-types></div>
            <br />
            <input id="submit_btn" type="submit" value="Plan trip"/>
        </form>

        <script type="text/javascript" src="/static/js/leaflet.js"></script>
        <script type="text/javascript">

var tileParams = {{!tile_server['parameters']}};
tileParams['attribution'] =
    "<a href='https://github.com/julienCXX/electrip'>Electrip "
    + "v{{!version}}</a> | "
    + "Powered by <a href='http://photon.komoot.de/'>Photon</a> and "
    + "<a href='http://project-osrm.org/'>OSRM</a> | "
    + tileParams['attribution'];



var photonBaseUrl = '{{!photon_url}}';

/* Generated station list */
var stations = {{!stations}};

////////////////////
// Utilities
////////////////////

var Utils = (function() {
    var self = {};

    self.makeAjax = function(url, successCB, failureCB, timeout) {
        var xhr = new XMLHttpRequest();
        xhr.open('GET', encodeURI(url));
        xhr.onload = function() {
            if (200 === xhr.status) {
                successCB(xhr.responseText);
            }
            else {
                if (undefined === failureCB || null === failureCB) {
                    console.log('Ajax request failed for URL: ', url,
                        '. Status: ', xhr.status);
                } else {
                    failureCB(xhr.status);
                }
            }
        };
        xhr.send();
        setTimeout(function() {xhr.abort()}, timeout);
    };

    return self;
})();

////////////////////
// Geocoding
////////////////////

var Geocoder = (function() {
    var self = {};

    var geocoderUrl = '';

    var geocodeResponseToLocation = function(response) {
        var parsedResponse;
        try {
            parsedResponse = JSON.parse(response);
        } catch (e) {
            return [];
        }
        var results = [];
        var features = parsedResponse.features;
        var length = features.length;
        var separator = '';
        for (var i = 0; i < length; i++) {
            var element = {};
            element.coordinates = features[i].geometry.coordinates;
            element.text = '';
            separator = '';
            if (features[i].properties.name) {
                element.text += features[i].properties.name;
                separator = ', ';
            }
            if (features[i].properties.street) {
                if (features[i].properties.housenumber) {
                    element.text += separator 
                        + features[i].properties.housenumber;
                    separator = ' ';
                }
                element.text += separator + features[i].properties.street;
                separator = ', ';
            }
            if (features[i].properties.city) {
                element.text += separator + features[i].properties.city;
                separator = ', ';
            }
            if (features[i].properties.country && features[i].properties.name
                    !== features[i].properties.country) {
                element.text += separator + features[i].properties.country;
            }
            if ('' != element.text) {
                results.push(element);
            }
        }
        return results;
    };

    self.geocode = function(query, center, successCB, failureCB, timeout) {
        if (null === query || '' === query) {
            return null;
        }
        Utils.makeAjax(geocoderUrl + 'api/?limit=10&lang=fr&lat=' + center.lat
            + '&lon=' + center.lng + '&q=' + query, function(response) {
                successCB(geocodeResponseToLocation(response));
            }, failureCB, timeout);
    };

    self.init = function(baseUrl) {
        geocoderUrl = baseUrl;
    };

    return self;
})();

Geocoder.init(photonBaseUrl);

////////////////////
// Routing
////////////////////

var Router = (function() {
    var self = {};

    var isValidTrip = false;
    var params;
    var routeSuccessCB;
    var routeFailureCB;

    var localSuccessCallback = function(response) {
        var objResponse = JSON.parse(response);
        routeSuccessCB(objResponse);
    }

    self.setRouteSuccessCallback = function(callback) {
        routeSuccessCB = callback;
    };

    self.setRouteFailureCallback = function(callback) {
        routeFailureCB = callback;
    };

    self.invalidateTrip = function() {
        hasValidTrip = false;
    };

    self.getIsValidTrip = function() {
        return hasValidTrip;
    };

    self.setParameters = function(newParams) {
        params = newParams;
        hasValidTrip = true;
    };

    self.route = function(newZoom) {
        if (!hasValidTrip) {
            return;
        }
        if (undefined !== newZoom && null !== newZoom) {
            params['zoom'] = newZoom;
        }
        var jsonParams = JSON.stringify(params);
        Utils.makeAjax('/route?params=' + jsonParams, localSuccessCallback,
            routeFailureCB, 20000);
    };

    return self;
})();

////////////////////
// UI management
////////////////////

var Ui = (function() {
    var self = {};

    var map;
    var fromMarker;
    var isFromMarkerSet = false;
    var toMarker;
    var isToMarkerSet = false;
    var routePolyline;
    var stationMarkerLayers = [];
    var inputFrom;
    var inputTo;
    var hasValidTrip = false;

    var initStationType = function(stationType, parentElt, onChangeCB) {
        var inputElt = document.createElement('input');
        var tag = 't_' + stationType['id'];
        inputElt.id = tag;
        inputElt.name = tag;
        inputElt.type = 'checkbox';
        inputElt.checked = true;
        inputElt.onchange = function() {
            onChangeCB(stationType['id'], this.checked)
        };
        parentElt.appendChild(inputElt);
        var labelElt = document.createElement('label');
        labelElt.for = tag;
        labelElt.appendChild(document.createTextNode(stationType['name']));
        parentElt.appendChild(labelElt);
        var brElt = document.createElement('br');
        parentElt.appendChild(brElt);
    }

    var toggleStationLayer = function(sId, enable) {
        if (enable) {
            map.addLayer(stationMarkerLayers[sId]);
        } else {
            map.removeLayer(stationMarkerLayers[sId]);
        }
        Router.invalidateTrip();
        routePolyline.setLatLngs([]);
    }

    // See: http://stackoverflow.com/questions/1047210/how-do-i-wait-until-the-user-has-finished-writing-down-in-a-text-input-to-call-a
    var generateDelayer = function() {
        var timer = 0;
        return function(callback, delay) {
            clearTimeout(timer);
            timer = setTimeout(callback, delay);
        }
    }();

    var setTypeWatch = function(element, callback) {
        element.addEventListener('input', function() {
            generateDelayer(function() {callback(element);}, 500);
        });
        element.addEventListener('blur', function() {
            // Ugly hack to allow the dropdown list to receive click event before hiding
            setTimeout(function() {
                element.nextElementSibling.classList.remove('show');
            }, 100);
        });
    }

    var ddListCb = function(event) {
        var lat = event.target.getAttribute('lat');
        var lng = event.target.getAttribute('lng');
        var latLng = {lat: lat, lng: lng};
        var text = event.target.firstChild.nodeValue;
        var inputElt = event.target.parentNode.parentNode.previousElementSibling;
        var isFromInputElt = 'from' === inputElt.id;
        var markerElt = isFromInputElt ? fromMarker : toMarker;
        inputElt.value = text;
        markerElt.setLatLng(latLng);
        markerElt.addTo(map);
        if (isFromInputElt) {
            isFromMarkerSet = true;
        } else {
            isToMarkerSet = true;
        }

        Router.invalidateTrip();
        routePolyline.setLatLngs([]);

        if (isFromMarkerSet && isToMarkerSet) {
            map.fitBounds(L.latLngBounds(
                        fromMarker.getLatLng(), toMarker.getLatLng()));
        } else {
            map.panTo(latLng);
        }
    }

    var populateDDList = function(list, content) {
        var span = list.children[0];
        var ul = list.children[1];
        if (!content || 0 === content.length) {
            span.classList.add('show');
            ul.classList.remove('show');
        } else {
            while (ul.lastChild) {
                ul.removeChild(ul.lastChild);
            }
            var length = content.length;
            var li;
            for (i = 0; i < length; i++) {
                li = document.createElement('li');
                li.appendChild(document.createTextNode(content[i].text));
                li.setAttribute('lat', content[i].coordinates[1]);
                li.setAttribute('lng', content[i].coordinates[0]);
                li.addEventListener('click', ddListCb, false);
                ul.appendChild(li);
            }
            span.classList.remove('show');
            ul.classList.add('show');
        }
    }

    var geocodeCb = function(element, content) {
        //console.log('Geocode elements: ', content);
        var list = element.nextElementSibling;
        //console.log(list);
        populateDDList(list, content);
        list.classList.add('show');
    }

    var typeWatchCB = function(element) {
        Geocoder.geocode(element.value, map.getCenter(), function(result) {
            geocodeCb(element, result);
        }, undefined, 2000);
    }

    var getSelectedStationTypes = function() {
        var selectedS = [];
        for (var i in stations) {
            var id = stations[i].id;
            if (document.getElementById('t_' + id).checked) {
                selectedS.push(id);
            }
        }
        return selectedS;
    }

    var setRouteStatus = function(isComputingRoute) {
        // See: http://gis.stackexchange.com/questions/54454/disable-leaflet-interaction-temporary
        var inputs = document.getElementsByTagName('input');
        for (i = 0; i < inputs.length; i++) {
            inputs[i].disabled = isComputingRoute;
        }
        var submitBtn = document.getElementById('submit_btn');
        if (isComputingRoute) {
            map._handlers.forEach(function(handler) {
                handler.disable();
            });
            submitBtn.value = 'Please wait';
        } else {
            map._handlers.forEach(function(handler) {
                handler.enable();
            });
            submitBtn.value = 'Plan trip';
        }
    }

    var routeSuccessCb = function(response, isNewRoute) {
        setRouteStatus(false);
        if (!response['route_found']) {
            alert('No route found');
            Router.invalidateTrip();
            routePolyline.setLatLngs([]);
            return;
        }
        routePolyline.setLatLngs(response['route_geometry']);
        if (isNewRoute) {
            map.fitBounds(routePolyline.getBounds());
        }
    }

    var routeFailureCb = function(status) {
        setRouteStatus(false);
        alert('Failed to send route instructions. Status: ' + status);
    }
    var sendForm = function() {
        if (!isFromMarkerSet) {
            alert('Please set a start point');
            return;
        }
        if (!isToMarkerSet) {
            alert('Please set a finish point');
            return;
        }

        var params = {};
        params['start'] = fromMarker.getLatLng();
        params['finish'] = toMarker.getLatLng();
        params['range'] = document.getElementById('range').value;
        params['types'] = getSelectedStationTypes();
        params['zoom'] = map.getZoom();

        setRouteStatus(true);
        Router.setParameters(params);
        Router.route();
    }

    self.init = function(mapDivId, mapViewCoords, mapViewZoom, tileUrl,
                         tileParams, stationsTypes, stationsTypesFormId) {
        map = L.map(mapDivId, {zoomControl: false});
        map.setView(mapViewCoords, mapViewZoom);
        map.addControl(L.control.zoom({position: 'topright'}));
        var tileLayer = L.tileLayer(tileUrl, tileParams);
        tileLayer.addTo(map);

        var mapImgPath = '/static/img/map';
        var defMarkerSize = [27, 41];
        var defMarkerAnchorPos = [14, 40];
        var defMarkerPopupAnchorPos = [0, -26];
        //L.Icon.Default.imagePath = mapImgPath;
        var CustomIcon = L.Icon.extend({
            options: {
                iconSize: defMarkerSize,
                iconAnchor: defMarkerAnchorPos,
                popupAnchor: defMarkerPopupAnchorPos
            }
        });

        var blueMarkerIcon = new CustomIcon({
            iconUrl: mapImgPath + '/marker-icon-blue.png'});
        var greenMarkerIcon = new CustomIcon({
            iconUrl: mapImgPath + '/marker-icon-green.png'});
        var redMarkerIcon = new CustomIcon({
            iconUrl: mapImgPath + '/marker-icon-red.png'});

        fromMarker = L.marker([0, 0], {icon: greenMarkerIcon});
        fromMarker.setZIndexOffset(Math.pow(2, 53) - 1);
        toMarker = L.marker([0, 0], {icon: redMarkerIcon});
        toMarker.setZIndexOffset(Math.pow(2, 53));

        document.getElementById('range').onchange = function() {
            Router.invalidateTrip();
            routePolyline.setLatLngs([]);
        };

        routePolyline = L.polyline({color: 'blue'});
        routePolyline.addTo(map);

        var form = document.getElementById('form');
        form.onsubmit = function() {
            sendForm();
            return false;
        };

        var stationsTypesFormElt = document.getElementById(stationsTypesFormId);

        for (var i in stationsTypes) {
            var stationType = stationsTypes[i];
            initStationType(stationType, stationsTypesFormElt,
                            toggleStationLayer);
            var stationMarkerLayer = [];
            var stations = stationType['stations'];
            for (var j in stations) {
                var station = stations[j];
                stationMarkerLayer.push(L.marker(station.position,
                    {icon: blueMarkerIcon}).bindPopup(
                        '<b>' + station.name + '</b><br />'
                        + station.address + '<br />Source&nbsp;: '
                        + station.source + '<br /><em>' + station.remarks
                        + '</em>'));
            }
            stationMarkerLayers[stationType['id']] =
                L.layerGroup(stationMarkerLayer);
            stationMarkerLayers[stationType['id']].addTo(map);
        }

        inputFrom = document.getElementById('from');
        setTypeWatch(inputFrom, typeWatchCB);
        inputTo = document.getElementById('to');
        setTypeWatch(inputTo, typeWatchCB);

        Router.setRouteSuccessCallback(routeSuccessCb);
        Router.setRouteFailureCallback(routeFailureCb);
        map.on('zoomend', function(e) {
            if (Router.getIsValidTrip()) {
                generateDelayer(sendForm, 500);
            }
        });
    };

    return self;
})();

Ui.init('map', [{{map_def['lat']}}, {{map_def['lng']}}], {{map_def['zoom']}},
    "{{!tile_server['url']}}", tileParams, stations, 'station-types');

        </script>
    </body>
</html>

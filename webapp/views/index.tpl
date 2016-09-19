<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8" />
        <title>Electrip − Electric Vehicle Trip Planning</title>
        <link rel="stylesheet" href="/static/css/leaflet.css" />
        <link rel="stylesheet" href="/static/css/awesomplete.css" />
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
.awesomplete > input {
    display: inline;
}
        </style>
    </head>
    <body>
        <div id="map"></div>
        <form id="form">
            <div class="input-container">
                <label for="from">From</label>
                <input id="from" name="from" type="text" />
            </div>
            <div class="input-container">
                <label for="to">To</label>
                <input id="to" name="to" type="text" />
            </div>
            <div class="input-container">
                <label for="range">Range</label>
                <input id="range" name="range" type="number" min="0"
                value="200" autocomplete="off"/> km
            </div>
            Charging station types:<br />
            <div id=station-types></div>
            <br />
            <input id="submit" type="button" value="Plan trip"/>
        </form>

        <script type="text/javascript" src="/static/js/leaflet.js"></script>
        <script type="text/javascript" src="/static/js/awesomplete.js"></script>
        <script type="text/javascript">
/*
 * Application classes
 */

/*
 * parameters: callbacks (success, failure), timeout
 */
var HttpRequestSender = function (parameters) {
    "use strict";

    var self = {};

    var timeout = null;
    var successCB = null;
    var failureCB = null;
    var xhr = null;

    self.send = function (url, isJsonResponse) {
        var parsedResponse = null;
        xhr = new XMLHttpRequest();
        xhr.onload = function (event) {
            if (200 === event.target.status) {
                if (isJsonResponse) {
                    try {
                        parsedResponse = JSON.parse(event.target.responseText);
                    } catch (e) {
                        failureCB({
                            reason: "json",
                            rawString: event.target.responseText,
                            details: e.message,
                            line: e.lineNumber,
                            column: e.columnNumber
                        });
                        return;
                    }
                    successCB(parsedResponse);
                } else {
                    successCB(event.target.responseText);
                }
            } else {
                failureCB({reason: "httpCode", code: event.target.status});
            }
        };
        xhr.timeout = timeout;
        xhr.onerror = function () {
            failureCB({reason: "network"});
        };
        xhr.ontimeout = function () {
            failureCB({reason: "timeout"});
        };
        xhr.onabort = function () {
            failureCB({reason: "abort"});
        };
        xhr.open("GET", encodeURI(url), true);
        xhr.send();
    };

    self.abort = function () {
        if (null !== xhr) {
            xhr.abort();
            xhr = null;
        }
    };

    (function constructor() {
        parameters = parameters || {};
        parameters.callbacks = parameters.callbacks || {};

        timeout = parameters.timeout || 5000;
        successCB = parameters.callbacks.success || function () {
            console.log("Request success");
        };
        failureCB = parameters.callbacks.failure || function () {
            console.log("Request failure");
        };
    }());

    return self;
};


/*
 * parameters: same as HttpRequestSender, url
 */
var Geocoder = function (parameters) {
    "use strict";

    var self = {};

    var hrs = null;
    var geocodingUrl = null;
    var successCB = null;

    var geocodeResponseToLocations = function (jsonResponse) {
        var results = [];

        jsonResponse.features.forEach(function (feature) {
            var name = "";
            var coordinates = feature.geometry.coordinates || [0.0, 0.0];
            var separator = "";

            coordinates = {lat: coordinates[1], lng: coordinates[0]};
            if (feature.properties.name) {
                name += feature.properties.name;
                separator = ", ";
            }
            if (feature.properties.street) {
                if (feature.properties.housenumber) {
                    name += separator + feature.properties.housenumber;
                    separator = " ";
                }
                name += separator + feature.properties.street;
                separator = ", ";
            }
            if (feature.properties.city) {
                name += separator + feature.properties.city;
                separator = ", ";
            }
            if (feature.properties.country && feature.properties.name
                    !== feature.properties.country) {
                name += separator + feature.properties.country;
            }
            if ("" !== name) {
                results.push({name: name, coordinates: coordinates});
            }
        });

        successCB(results);
    };

    self.geocode = function (query, center) {
        center = center || {};
        center.lat = center.lat || 0.0;
        center.lng = center.lng || 0.0;
        hrs.send(geocodingUrl + "api/?limit=10&lang=fr&lat=" + center.lat
                + "&lon=" + center.lng + "&q=" + query, true);
    };

    (function constructor() {
        parameters = parameters || {};
        parameters.callbacks = parameters.callbacks || {};
        successCB = parameters.callbacks.success || function () {
            console.log("Geocoding success");
        };
        parameters.callbacks.success = geocodeResponseToLocations;
        hrs = HttpRequestSender(parameters);
        geocodingUrl = parameters.url || "";
    }());

    return self;
};


/*
 * parameters: same as HttpRequestSender, url
 */
var Router = function (parameters) {
    "use strict";

    var self = {};

    var hrs = null;
    var routingUrl = null;
    var successCB = null;

    var onRequestSuccess = function (jsonResponse) {
        if (!jsonResponse.route_found) {
            parameters.callbacks.failure({reason: "noRoute"});
            return;
        }
        successCB(jsonResponse);
    };

    self.route = function (params) {
        var jsonParams = JSON.stringify(params);
        hrs.send(routingUrl + "route?params=" + jsonParams, true);
    };

    self.abort = function () {
        hrs.abort();
    };

    (function constructor() {
        parameters = parameters || {};
        parameters.callbacks = parameters.callbacks || {};
        successCB = parameters.callbacks.success || function () {
            console.log("Routing success");
        };
        parameters.callbacks.failure
                = parameters.callbacks.failure || function () {
            console.log("Routing failure");
        };
        parameters.callbacks.success = onRequestSuccess;
        hrs = HttpRequestSender(parameters);
        routingUrl = parameters.url || "";
    }());

    return self;
};


/*
 * parameters: divElement, coordinates, zoom, tileUrl, attribution,
 * stationTypes, callbacks (zoomChanged, centerChanged)
 */
var Map = function (parameters) {
    "use strict";

    var self = {};

    var map = null;
    var zoomControl = null;
    var fromMarker = null;
    var isFromMarkerSet = false;
    var toMarker = null;
    var isToMarkerSet = false;
    var routePolyline = null;
    var stationMarkerLayers = [];
    var isEnabled = true;

    self.setMarker = function (isStartMarker, coordinates) {
        var markerElt = null;

        if (isStartMarker) {
            markerElt = fromMarker;
            if (!isFromMarkerSet) {
                markerElt.addTo(map);
                isFromMarkerSet = true;
            }
        } else {
            markerElt = toMarker;
            if (!isToMarkerSet) {
                markerElt.addTo(map);
                isToMarkerSet = true;
            }
        }
        markerElt.setLatLng(coordinates);

        if (isFromMarkerSet && isToMarkerSet) {
            map.fitBounds(L.latLngBounds(
                fromMarker.getLatLng(),
                toMarker.getLatLng()
            ));
        } else {
            map.panTo(coordinates);
        }
    };

    self.setRoutePolyline = function (polyline) {
        routePolyline.setLatLngs(polyline);
    };

    self.toggleStationLayer = function (sId, enable) {
        if (enable) {
            map.addLayer(stationMarkerLayers[sId]);
        } else {
            map.removeLayer(stationMarkerLayers[sId]);
        }
    };

    self.setEnabled = function (enabled) {
        if (isEnabled === enabled) {
            return;
        }

        map._handlers.forEach(function (handler) {
            if (enabled) {
                handler.enable();
            } else {
                handler.disable();
            }
        });
        if (enabled) {
            map.addControl(zoomControl);
        } else {
            map.removeControl(zoomControl);
        }
        isEnabled = enabled;
    };

    (function constructor() {
        var maxInt = Math.pow(2, 53);
        var mapImgPath = "/static/img/map";
        var CustomIcon = L.Icon.extend({
            options: {
                iconSize: [27, 41],
                iconAnchor: [14, 40],
                popupAnchor: [0, -26]
            }
        });

        var blueMarkerIcon = new CustomIcon({
            iconUrl: mapImgPath + "/marker-icon-blue.png"
        });
        var greenMarkerIcon = new CustomIcon({
            iconUrl: mapImgPath + "/marker-icon-green.png"
        });
        var redMarkerIcon = new CustomIcon({
            iconUrl: mapImgPath + "/marker-icon-red.png"
        });

        parameters = parameters || {};
        parameters.zoom = parameters.zoom || 0;
        parameters.coordinates = parameters.coordinates || {lat: 0.0, lng: 0.0};
        parameters.attribution = parameters.attribution || "";
        parameters.tileUrl = parameters.tileUrl || "";
        parameters.stationTypes = parameters.stationTypes || [];
        parameters.callbacks = parameters.callbacks || {};
        parameters.callbacks.zoomChanged
                = parameters.callbacks.zoomChanged || function () {
            console.log("Zoom changed");
        };
        parameters.callbacks.centerChanged
                = parameters.callbacks.centerChanged || function () {
            console.log("Center changed");
        };

        map = L.map(parameters.divElement, {zoomControl: false});
        map.setView(parameters.coordinates, parameters.zoom);
        zoomControl = L.control.zoom({position: "topright"});
        map.addControl(zoomControl);
        L.tileLayer(parameters.tileUrl,
                {attribution: parameters.attribution}).addTo(map);

        fromMarker = L.marker([0, 0], {icon: greenMarkerIcon});
        fromMarker.setZIndexOffset(maxInt - 1);
        toMarker = L.marker([0, 0], {icon: redMarkerIcon});
        toMarker.setZIndexOffset(maxInt);

        routePolyline = L.polyline({color: "blue"});
        routePolyline.addTo(map);

        parameters.stationTypes.forEach(function (stationType) {
            var stationMarkerLayer = [];
            stationType.stations.forEach(function (station) {
                stationMarkerLayer.push(L.marker(
                    station.position,
                    {icon: blueMarkerIcon}
                ).bindPopup(
                    "<b>" + station.name + "</b><br />"
                    + station.address + "<br />Source&nbsp;: "
                    + station.source + "<br /><em>" + station.remarks
                    + "</em>"
                ));
            });
            stationMarkerLayers[stationType.id] =
                    L.layerGroup(stationMarkerLayer);
            stationMarkerLayers[stationType.id].addTo(map);
        });

        map.on("zoomend", function () {
            parameters.callbacks.zoomChanged(map.getZoom());
        });
        map.on("moveend", function () {
            parameters.callbacks.centerChanged(map.getCenter());
        });
    }());

    return self;
};


/*
 * parameters: textField, inputDelay, locationChangedCB, geocodingUrl
 */
var LocationTextField = function (parameters) {
    "use strict";

    var self = {};

    var autocompleteTextField = null;
    var geocoder = null;
    var mapCenter = {lat: 0.0, lng: 0.0};

    var geocodeSuccessCB = function (response) {
        var list = [];
        response.forEach(function (element) {
            list.push({
                label: element.name,
                value: JSON.stringify(element.coordinates)
            });
        });
        autocompleteTextField.list = list;
        autocompleteTextField.evaluate();
    };

    var geocodeFailureCB = function (args) {
        console.log("Geocoding failed, status: " + args);
    };

    var generateDelayer = (function () {
        var timer = 0;
        return function (callback, delay) {
            clearTimeout(timer);
            timer = setTimeout(callback, delay);
        };
    }());

    self.setMapCenter = function (center) {
        mapCenter = center;
    };

    (function constructor() {
        parameters.textField = parameters.textField || {};
        parameters.locationChangedCB
                = parameters.locationChangedCB || function () {
            console.log("Location changed");
        };

        parameters.textField.value = "";
        autocompleteTextField = new Awesomplete(parameters.textField, {
            filter: function () {
                return true;
            },
            sort: function () {
                return 0; // Keep original order
            },
            replace: function (text) {
                var coordinates = JSON.parse(text.value);
                parameters.textField.value = text.label;
                parameters.locationChangedCB(coordinates, text.label);
            }
        });
        geocoder = Geocoder({
            timeout: 5000,
            url: parameters.geocodingUrl,
            callbacks: {
                success: geocodeSuccessCB,
                failure: geocodeFailureCB
            }
        });
        parameters.textField.addEventListener("input", function () {
            generateDelayer(function () {
                geocoder.geocode(parameters.textField.value, mapCenter);
            }, parameters.inputDelay);
        });
    }());

    return self;
};


/*
 * parameters: stationTypes, geocodingUrl,
 * formElements (start, finish, stationTypes, range, submit),
 * callbacks (valueChanged, submit, abort)
 */
var Form = function (parameters) {
    "use strict";

    var self = {};

    var formElements = {};
    var inputFromDD = null;
    var isFromLocationSet = false;
    var inputToDD = null;
    var isToLocationSet = false;
    var formEnabled = true;
    var callbacks = {};

    var initStationType = function (stationType, parentElt, onChangeCB) {
        var inputElt = document.createElement("input");
        var tag = "t_" + stationType.id;
        var labelElt = null;
        var brElt = null;

        inputElt.id = tag;
        inputElt.name = tag;
        inputElt.type = "checkbox";
        inputElt.checked = true;
        inputElt.onchange = function (event) {
            onChangeCB(stationType.id, event.target.checked);
        };
        parentElt.appendChild(inputElt);

        labelElt = document.createElement("label");
        labelElt.for = tag;
        labelElt.appendChild(document.createTextNode(stationType.name));
        parentElt.appendChild(labelElt);

        brElt = document.createElement("br");
        parentElt.appendChild(brElt);
        formElements.types[stationType.id] = inputElt;
    };

    self.setEnabled = function (enabled) {
        Object.keys(formElements).forEach(function (key) {
            if (undefined !== formElements[key].disabled) {
                formElements[key].disabled = !enabled;
            }
        });
        Object.keys(formElements.types).forEach(function (key) {
            formElements.types[key].disabled = !enabled;
        });
        var submitBtn = formElements.submit;
        if (enabled) {
            submitBtn.value = "Plan trip";
        } else {
            submitBtn.value = "Cancel";
        }
        submitBtn.disabled = false;
        formEnabled = enabled;
    };

    var sendForm = function () {
        if (!formEnabled) {
            callbacks.abort();
            return;
        }

        if (!isFromLocationSet) {
            alert("Please set a start point");
            return;
        }
        if (!isToLocationSet) {
            alert("Please set a finish point");
            return;
        }

        callbacks.submit();
    };

    self.setMapCenter = function (center) {
        inputFromDD.setMapCenter(center);
        inputToDD.setMapCenter(center);
    };

    (function constructor() {
        callbacks = parameters.callbacks;
        formElements = parameters.formElements || {};

        inputFromDD = LocationTextField({
            textField: formElements.start,
            inputDelay: 500,
            geocodingUrl: parameters.geocodingUrl,
            locationChangedCB: function (coordinates) {
                callbacks.valueChanged("start", coordinates);
                isFromLocationSet = true;
            }
        });
        inputToDD = LocationTextField({
            textField: formElements.finish,
            inputDelay: 500,
            geocodingUrl: parameters.geocodingUrl,
            locationChangedCB: function (coordinates) {
                callbacks.valueChanged("finish", coordinates);
                isToLocationSet = true;
            }
        });

        formElements.range.onchange = function (event) {
            callbacks.valueChanged("range", parseInt(event.target.value));
        };

        formElements.types = {};
        parameters.stationTypes.forEach(function (stationType) {
            initStationType(stationType, formElements.stationTypes,
                    function (typeId, checked) {
                callbacks.valueChanged("type", {id: typeId, checked: checked});
            });
        });

        formElements.submit.onclick = sendForm;
    }());

    return self;
};


/*
 * Application entry point
 */
(function App() {
    "use strict";

    var tileParams = {{!tile_server['parameters']}};
    tileParams.attribution =
            "<a href='https://github.com/julienCXX/electrip'>Electrip "
            + "v{{!version}}</a> | "
            + "Powered by <a href='http://photon.komoot.de/'>Photon</a> and "
            + "<a href='http://project-osrm.org/'>OSRM</a> | "
            + tileParams.attribution;

    var photonBaseUrl = '{{!photon_url}}';

    /* Generated station list */
    var stations = {{!stations}};

    var router = null;
    var map = null;
    var form = null;

    var routeParameters = {
        start: null,
        finish: null,
        range: 200,
        types: [],
        zoom: {{map_def['zoom']}}
    };

    var hasValidRoute = false;

    var initialMapCenter = {lat: {{map_def['lat']}}, lng: {{map_def['lng']}}};

    var onSubmit = null;

    stations.forEach(function (station) {
        routeParameters.types.push(station.id);
    });

    var onZoomChanged = function (zoom) {
        routeParameters.zoom = zoom;
        if (hasValidRoute) {
            onSubmit();
        }
    };

    var onCenterChanged = function (center) {
        form.setMapCenter(center);
    };

    var onValueChanged = function (element, args) {
        if ("type" === element) {
            var index = routeParameters.types.indexOf(args.id);
            if (index > -1 && !args.checked) {
                routeParameters.types.splice(index, 1);
            } else if (index <= -1 && args.checked) {
                routeParameters.types.push(args.id);
            }
            map.toggleStationLayer(args.id, args.checked);
        } else {
            routeParameters[element] = args;
            if ("start" === element) {
                map.setMarker(true, args);
            }
            if ("finish" === element) {
                map.setMarker(false, args);
            }
        }
        map.setRoutePolyline([]);
        hasValidRoute = false;
    };

    var onRoutingSuccess = function (response) {
        map.setEnabled(true);
        form.setEnabled(true);
        map.setRoutePolyline(response.route_geometry);
        hasValidRoute = true;
    };

    var onRoutingFailure = function (args) {
        switch (args.reason) {
        case "abort":
            break;
        case "noRoute":
            alert("No route found");
            break;
        case "network":
            alert("An issue with network occured");
            break;
        case "timeout":
            alert("Request timed out");
            break;
        case "httpCode":
            alert("Request responded with HTTP code: " + args.code);
            break;
        default:
            alert("Unknown error: " + args.reason);
        }
        map.setEnabled(true);
        form.setEnabled(true);
        hasValidRoute = false;
    };

    onSubmit = function () {
        map.setEnabled(false);
        form.setEnabled(false);
        router.route(routeParameters);
    };

    var onAbort = function () {
        router.abort();
    };

    router = Router({
        callbacks: {
            success: onRoutingSuccess,
            failure: onRoutingFailure
        },
        timeout: 42000
    });

    map = Map({
        divElement: document.getElementById("map"),
        coordinates: initialMapCenter,
        zoom: {{map_def['zoom']}},
        tileUrl: "{{!tile_server['url']}}",
        attribution: tileParams.attribution,
        stationTypes: stations,
        callbacks: {
            zoomChanged: onZoomChanged,
            centerChanged: onCenterChanged
        }
    });

    form = Form({
        stationTypes: stations,
        formElements: {
            start: document.getElementById("from"),
            finish: document.getElementById("to"),
            stationTypes: document.getElementById("station-types"),
            range: document.getElementById("range"),
            submit: document.getElementById("submit")
        },
        callbacks: {
            valueChanged: onValueChanged,
            submit: onSubmit,
            abort: onAbort
        },
        geocodingUrl: photonBaseUrl
    });
    form.setMapCenter(initialMapCenter);
}());
        </script>
    </body>
</html>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8" />
        <title>Electrip − Calculateur d’itinéraires pour véhicules électriques</title>
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
                <label for="from">De</label>
                <div class="dropdown-container">
                    <input id="from" name="from" type="text" autocomplete="off" />
                    <div class="dropdown">
                        <span class="show">Aucun résultat</span>
                        <ul></ul>
                    </div>
                </div>
                <button>Ma position</button>
            </div>
            <div class="input-container">
                <label for="to">À</label>
                <div class="dropdown-container">
                    <input id="to" name="to" type="text" autocomplete="off" />
                    <div class="dropdown">
                        <span class="show">Aucun résultat</span>
                        <ul></ul>
                    </div>
                </div>
                <button>Ma position</button>
            </div>
            <div class="input-container">
                <label for="range">Autonomie</label>
                <input id="range" name="range" type="number" min="0"
                value="200"/>&nbsp;km
            </div>
            Types de bornes de recharge&nbsp;:<br />
            % for s_type in station_types:
                <input id="t_{{s_type['id']}}" name="t_{{s_type['id']}}"
                type="checkbox" checked
                onchange="toggleStationLayer({{s_type['id']}}, this.checked)"/>
                <label for="t_{{s_type['id']}}">{{s_type['name']}}</label><br />
            % end
            <input type="button" value="Calculer l’itinéraire"
            onclick="sendForm()"/>
        </form>

        <script type="text/javascript" src="/static/js/leaflet.js"></script>
        <script type="text/javascript">
var map = L.map('map', {zoomControl: false});
map.setView([45.19329, 5.76798], 15);
map.addControl(L.control.zoom({position: 'topright'}));
// See: http://harrywood.co.uk/maps/examples/leaflet/mapquest.view.html
var mqLayer = L.tileLayer("{{!tile_server['url']}}",
    {{!tile_server['parameters']}});

mqLayer.addTo(map);

L.Icon.Default.imagePath = '/static/img/map';

var fromMarker = L.marker([0, 0]);
var isFromMarkerSet = false;
var toMarker = L.marker([0, 0]);
var isToMarkerSet = false;

var routePolyline = L.polyline({color: 'blue'});
routePolyline.addTo(map);

var photonBaseUrl = '{{!photon_url}}';

var makeAjax = function(url, success, failure) {
    var xhr = new XMLHttpRequest();
    xhr.open('GET', encodeURI(url));
    xhr.onload = function() {
        if (200 === xhr.status) {
            success(xhr.responseText);
        }
        else {
            if (undefined === failure || null === failure) {
                console.log('Ajax request failed for URL: ', url,
                    '. Status: ', xhr.status);
            } else {
                failure(xhr.status);
            }
        }
    };
    xhr.send();
};

var geocodeResponseToLocation = function(response) {
    var parsedResponse;
    try {
        parsedResponse = JSON.parse(response);
    } catch (e) {
        return null;
    }
    var results = [];
    var features = parsedResponse.features;
    var length = features.length;
    var separator = '';
    for (var i = 0; i < length; i++) {
        var element = {};
        element.lng = features[i].geometry.coordinates[0];
        element.lat = features[i].geometry.coordinates[1];
        element.text = '';
        separator = '';
        if (features[i].properties.name) {
            element.text += features[i].properties.name;
            separator = ', ';
        }
        if (features[i].properties.street) {
            if (features[i].properties.housenumber) {
                element.text += separator + features[i].properties.housenumber;
                separator = ' ';
            }
            element.text += separator + features[i].properties.street;
            separator = ', ';
        }
        if (features[i].properties.city) {
            element.text += separator + features[i].properties.city;
            separator = ', ';
        }
        if (features[i].properties.country
            && features[i].properties.name !== features[i].properties.country) {
            element.text += separator + features[i].properties.country;
        }
        if ('' != element.text) {
            results.push(element);
        }
    }
    return results;
};

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
    map.panTo(latLng);
};

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
            li.setAttribute('lat', content[i].lat);
            li.setAttribute('lng', content[i].lng);
            li.addEventListener('click', ddListCb, false);
            ul.appendChild(li);
        }
        span.classList.remove('show');
        ul.classList.add('show');
    }
};

var geocodeCb = function(element, content) {
    console.log('Geocode elements: ', content);
    var list = element.nextElementSibling;
    console.log(list);
    populateDDList(list, content);
    list.classList.add('show');
};

var geocode = function(query, element) {
    if (null === query || '' === query) {
        return null;
    }
    var mapCenter = map.getCenter();
    makeAjax(photonBaseUrl + 'api/?limit=10&lang=fr&lat=' + mapCenter.lat
        + '&lon=' + mapCenter.lng + '&q=' + query, function(response) {
        geocodeCb(element, geocodeResponseToLocation(response));
    });
};

// See: http://stackoverflow.com/questions/1047210/how-do-i-wait-until-the-user-has-finished-writing-down-in-a-text-input-to-call-a
var typeWatch = function() {
    var typeWatchTimer = 0;
    return function(callback, delay) {
        clearTimeout(typeWatchTimer);
        typeWatchTimer = setTimeout(callback, delay);
    }
}();

var inputFrom = document.getElementById('from');
var geocodeInputFrom = function() {
    geocode(inputFrom.value, inputFrom);
};
inputFrom.addEventListener('input', function() {
    typeWatch(geocodeInputFrom, 500);
});
inputFrom.addEventListener('blur', function() {
    // Ugly hack to allow the dropdown list to receive click event before hiding
    setTimeout(function() {
        inputFrom.nextElementSibling.classList.remove('show');
    }, 100);
});

var inputTo = document.getElementById('to');
var geocodeInputTo = function() {
    geocode(inputTo.value, inputTo);
};
inputTo.addEventListener('input', function() {
    typeWatch(geocodeInputTo, 500);
});
inputTo.addEventListener('blur', function() {
    // Ugly hack to allow the dropdown list to receive click event before hiding
    setTimeout(function() {
        inputTo.nextElementSibling.classList.remove('show');
    }, 100);
});

/* Generated station list */
var stations = {{!stations}};
var stationMarkerLayers = {};
for (var sType in stations) {
    var typedStations = stations[sType];
    var stationMarkerLayer = [];
    for (var s in typedStations) {
        stationMarkerLayer.push(L.marker(typedStations[s].position).bindPopup(
            '<b>' + typedStations[s].name + '</b><br />'
            + typedStations[s].address + '<br />Source&nbsp;: '
            + typedStations[s].source + '<br /><em>' + typedStations[s].remarks
            + '</em>'));
    }
    stationMarkerLayers[sType] = L.layerGroup(stationMarkerLayer);
    stationMarkerLayers[sType].addTo(map);
}

var toggleStationLayer = function(sId, enable) {
    if (enable) {
        map.addLayer(stationMarkerLayers[sId]);
    } else {
        map.removeLayer(stationMarkerLayers[sId]);
    }
}

var getSelectedStationTypes = function() {
    var selectedS = [];
    for (var sType in stations) {
        if (document.getElementById('t_' + sType).checked) {
            selectedS.push(sType);
        }
    }
    return selectedS;
}

var routeSuccessCb = function(response) {
    var objResponse = JSON.parse(response);
    console.log(objResponse);
    if (!objResponse['route_found']) {
        alert('Pas d’itinéraire trouvé');
        return;
    }
    routePolyline.setLatLngs(objResponse['route_geometry']);
}

var routeFailureCb = function(status) {
    alert('Failed to send route instructions. Status: ' + status);
}

var sendForm = function() {
    if (!isFromMarkerSet) {
        alert('Veuillez spécifier un point de départ');
        return;
    }
    if (!isToMarkerSet) {
        alert('Veuillez spécifier un point d’arrivée');
        return;
    }

    var params = {};
    params['start'] = fromMarker.getLatLng();
    params['finish'] = toMarker.getLatLng();
    params['range'] = document.getElementById('range').value;
    params['types'] = getSelectedStationTypes();
    params['zoom'] = map.getZoom();

    jsonParams = JSON.stringify(params);
    makeAjax('/route?params=' + jsonParams, routeSuccessCb, routeFailureCb);
}

map.on('zoomend', function(e) {
    if (isFromMarkerSet && isToMarkerSet) {
        sendForm();
    }
});
        </script>
    </body>
</html>

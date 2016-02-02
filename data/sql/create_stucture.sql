CREATE TABLE IF NOT EXISTS station_type (
    id      serial PRIMARY KEY,
    name    text
);

CREATE TABLE IF NOT EXISTS station (
    id          serial PRIMARY KEY,
    name        text,
    address     text,                   -- human-readable address
    position    geography(POINT, 4326), -- coordinates
    source      text,
    remarks     text,
    type        serial REFERENCES station_type
);

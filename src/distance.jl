const EARTH_RADIUS_EQUATORIAL = 6378137.0
const EARTH_RADIUS_POLAR = 6356752.3

"""
`CoordinateDistance(lat1, lon1, lat2, lon2; calcfunc, radius)`

Description
===========

Calculates distance between (lat1, lon1) and (lat2, lon2).
The provided `calcfunc` functions assume the earth is spherical
and has a fixed radius.

Usage
=====

  CoordinateDistance(latStart, longStart, latEnd, longEnd)

  CoordinateDistance(latStart, longStart, latEnd, longEnd, calcfunc=haversine)

  CoordinateDistance(latStart, longStart, latEnd, longEnd, radius=EARTH_RADIUS_POLAR)

  CoordinateDistance((latStart, longStart), (latEnd, longEnd))

Arguments
=========

- **`lat1`** : Latitude of the first point. Must be a float.

- **`lon1`** : Longitude of the first point. Must be a float.

- **`lat2`** : Latitude of the second point. Must be a float.

- **`lon2`** : Longitude of the second point. Must be a float.

- **`calcfunc`** : Function that calculates distance between point 1 and 2. Defaults to
  Vincenty. Haversine is also available.

- **`radius`** : Radius of the Earth. Defaults to EARTH_RADIUS_EQUATORIAL - about 6378.137KM.
  EARTH_RADIUS_POLAR is also available.
"""
function coord_distance(
          lat1::AbstractFloat,
          lon1::AbstractFloat,
          lat2::AbstractFloat,
          lon2::AbstractFloat;
          calcfunc::Function=vincenty,
          radius::AbstractFloat=EARTH_RADIUS_EQUATORIAL)::AbstractFloat
  calcfunc(lat1, lon1, lat2, lon2, radius)
end

function coord_distance(
          coord1::Tuple{AbstractFloat,AbstractFloat},
          coord2::Tuple{AbstractFloat,AbstractFloat};
          calcfunc::Function=vincenty,
          radius::AbstractFloat=EARTH_RADIUS_EQUATORIAL)::AbstractFloat
  coord_distance(coord1[1], coord1[2], coord2[1], coord2[2], calcfunc=calcfunc, radius=radius)
end

function haversine(
          lat1::AbstractFloat,
          lon1::AbstractFloat,
          lat2::AbstractFloat,
          lon2::AbstractFloat,
          radius::AbstractFloat)::AbstractFloat
  lat1 = deg2rad(lat1)
  lon1 = deg2rad(lon1)
  lat2 = deg2rad(lat2)
  lon2 = deg2rad(lon2)

  latDelta = lat2 - lat1
  lonDelta = lon2 - lon1

  ang = 2asin(sqrt(sin(.5latDelta)^2)+cos(lat1)*cos(lat2)*sin(.5lonDelta)^2)
  return ang * radius
end

function vincenty(
          lat1::AbstractFloat,
          lon1::AbstractFloat,
          lat2::AbstractFloat,
          lon2::AbstractFloat,
          radius::AbstractFloat)::AbstractFloat
  lat1 = deg2rad(lat1)
  lon1 = deg2rad(lon1)
  lat2 = deg2rad(lat2)
  lon2 = deg2rad(lon2)

  lonDelta = lon2 - lon1

  a = (cos(lat2)*sin(lonDelta))^2
  a += (cos(lat1)*sin(lat2) - sin(lat1)*cos(lat2)*cos(lonDelta))^2
  b = sin(lat1)*sin(lat2) + cos(lat1)*cos(lat2)*cos(lonDelta)

  ang = atan2(sqrt(a), b)
  return ang * radius
end

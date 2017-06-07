# http://www.movable-type.co.uk/scripts/gis-faq-5.1.html
# https://github.com/Turfjs/turf-vincenty-inverse/blob/master/index.js


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

"""
`haversine(
  lat1::AbstractFloat,
  lon1::AbstractFloat,
  lat2::AbstractFloat,
  lon2::AbstractFloat,
  radius::AbstractFloat
)`


Haversine Formula for Great Circle Distance
========================
The Haversine formula presides on spherical trigonometry to calculate
straight distance between two points on a unit sphere; that is to say
"how the crow flies" across a perfect sphere.

It is important to note that if the ratio of the distance between the points
and Earth's radius becomes too large there will be an adverse loss of precision
due to a floating point error. This issue arises between antipodal coordinates
(opposite sides of the globe) and thus is not a major concern for calculations
within the U.S.

"""
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

  latΔ = lat2 - lat1
  lonΔ = lon2 - lon1

  a = sin(.5latΔ)^2 + cos(lat1)*cos(lat2)*sin(.5lonΔ)^2
  c = 2asin(min(1, sqrt(a)))

  return radius * c
end



"""
flatpythagorean

"""
function flatpythagorean(
          lat1::AbstractFloat,
          lon1::AbstractFloat,
          lat2::AbstractFloat,
          lon2::AbstractFloat,
          radius::AbstractFloat)::AbstractFloat
  lat1 = deg2rad(lat1)
  lon1 = deg2rad(lon1)
  lat2 = deg2rad(lat2)
  lon2 = deg2rad(lon2)

  a = π/2 - lat1
  b = π/2 - lat2
  c = sqrt(a^2 + b^2 - 2*a*b*cos(lon2-lon1))

  return radius * c
end


"""
`vincenty(
  lat1::AbstractFloat,
  lon1::AbstractFloat,
  lat2::AbstractFloat,
  lon2::AbstractFloat;
  tol::AbstractFloat=1e-9,
  maxiter::Int=1000,
  verbose::Bool=true
)`

Vincenty's Formula for Great Circle Distance
========================
The Vincenty formula provides improved accuracy over the Haversine implementation
at the expense of some added complexity. Unlike the Haversine formula, Vincenty's
solution assumes the sphere is oblate (flattened) - a more appropriate shape for
the Earth's actual curvature.

It is important to note that if the ratio of the distance between the points
and Earth's radius becomes too large there will be an adverse loss of precision
due to a floating point error. This issue arises between antipodal coordinates
(opposite sides of the globe) and thus is not a major concern for calculations
within the U.S.
"""
function vincenty(
          lat1::AbstractFloat,
          lon1::AbstractFloat,
          lat2::AbstractFloat,
          lon2::AbstractFloat;
          tol::AbstractFloat=1e-9,
          maxiter::Int=1000,
          verbose::Bool=true)::AbstractFloat
  lat1 = deg2rad(lat1)
  lon1 = deg2rad(lon1)
  lat2 = deg2rad(lat2)
  lon2 = deg2rad(lon2)

  a = EARTH_RADIUS_EQUATORIAL
  b = EARTH_RADIUS_POLAR
  ƒ = (a - b) / a
  b = (1 - ƒ)*a

  u1 = atan((1-ƒ)*tan(lat1))
  u2 = atan((1-ƒ)*tan(lat2))
  L = lon2 - lon1
  sinσ = 0.
  cosσ = 0.
  cos2α = 0.
  cos2σm = 0.
  σ = 0.

  λ = copy(L)
  λ2 = λ
  δ = 1.
  n = 0

  while δ > tol || n == maxiter
    n += 1
    sinσ = sqrt( (cos(u2)*sin(λ))^2 + (cos(u1)*sin(u2)-sin(u1)*cos(u2)*cos(λ))^2 )
    cosσ = sin(u1)*sin(u2) + cos(u1)*cos(u2)*cos(λ)
    σ = atan(sinσ/cosσ)
    sinα = (cos(u1)*cos(u2)*sin(λ))/sin(σ)
    cos2α = 1 - sinα^2
    cos2σm = cos(σ) - (2*sin(u1)*sin(u2))/cos2α
    C = ƒ/16 * cos2α*(4 + ƒ*(4-3cos2α))

    x1 = cos2σm + C*cosσ*(-1+2cos2σm^2)
    x2 = σ + C*sinσ*x1
    λ = L + (1-C)*ƒ*sinα*x2
    δ = abs(λ-λ2)
    λ2 = copy(λ)
  end

  if n == maxiter && δ > tol && verbose
    println("Warning: vincenty formula did not converge to desired tolerance.")
  end

  μ2 = cos2α * (a^2 - b^2)/(b^2)
  A = 1 + μ2/16384*(4096 + μ2*(-768+μ2*(320-175μ2)))
  B = (μ2/1024)*(256 + μ2*(-128+μ2*(74-47μ2)))

  x3 = cos2σm + .25B*(cosσ*(-1+2cos2σm^2))
  x4 = (1/6)*B*cos2σm*(-3+4sinσ^2)*(-3+4cos2σm^2)
  Δσ = B*sinσ*(x3-x4)
  s = b*A*(σ-Δσ)

  return s
end

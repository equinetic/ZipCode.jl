const EARTH_RADIUS_EQUATORIAL = 6378137.0
const EARTH_RADIUS_POLAR = 6356752.3

"""
`CoordinateDistance(lat1, lon1, lat2, lon2; calcfunc, radius)`

Description
===========

Calculates distance between (lat1, lon1) and (lat2, lon2).

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
  Vincenty. Haversine and Flat Pythagorean is also available.
- **`radius`** : Radius of the Earth. Defaults to EARTH_RADIUS_EQUATORIAL - about 6378.137KM.
  EARTH_RADIUS_POLAR is also available.
"""
function coord_distance(
          lat1::AbstractFloat,
          lon1::AbstractFloat,
          lat2::AbstractFloat,
          lon2::AbstractFloat;
          calcfunc::Function=vincenty,
          radius::AbstractFloat=EARTH_RADIUS_EQUATORIAL,
          units::Unitful.FreeUnits=u"m",
          returntype::Type=AbstractFloat, args...)
  v = calcfunc(lat1, lon1, lat2, lon2, radius; args...)
  v = isnan(v) ? 0. : v
  units !== u"m" ? dist_convert(v, units, returntype) : v
end

function coord_distance(
          coord1::Coordinate,
          coord2::Coordinate;
          args...)
  v = coord_distance(coord1[1], coord1[2], coord2[1], coord2[2]; args...)
end

"""
```julia
haversine(
  lat1::AbstractFloat,
  lon1::AbstractFloat,
  lat2::AbstractFloat,
  lon2::AbstractFloat,
  radius::AbstractFloat
)
```


Haversine Formula for Great Circle Distance
========================
The Haversine formula presides on spherical trigonometry to calculate
straight distance between two points on a unit sphere; that is to say
"how the crow flies" across a perfect sphere.
"""
function haversine(
          lat1::AbstractFloat,
          lon1::AbstractFloat,
          lat2::AbstractFloat,
          lon2::AbstractFloat,
          radius::AbstractFloat; args...)::AbstractFloat
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
```julia
flatpythagorean(
  lat1::AbstractFloat,
  lon1::AbstractFloat,
  lat2::AbstractFloat,
  lon2::AbstractFloat,
  radius::AbstractFloat
)
```

Pythagorean Theorem for Coordinate Distance
========================
Utilizing Pythagorean's Theorem to calculate coordinate distance
assumes that the Earth is flat. While erroneous, when the distance
between the points is less than 20 kilometers the expected error
for the majority of the United States will be less than 20 meters.
Latitudes above 50 degrees (Alaska) will be less than 30 meters, and
latitudes below 30 degrees (Southern US / Hawaii) will be less than
9 meters.

"""
function flatpythagorean(
          lat1::AbstractFloat,
          lon1::AbstractFloat,
          lat2::AbstractFloat,
          lon2::AbstractFloat,
          radius::AbstractFloat; args...)::AbstractFloat
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
```julia
vincenty(
  lat1::AbstractFloat,
  lon1::AbstractFloat,
  lat2::AbstractFloat,
  lon2::AbstractFloat
  radiusA::AbstractFloat=EARTH_RADIUS_EQUATORIAL;
  radiusB::AbstractFloat=EARTH_RADIUS_POLAR,
  tol::AbstractFloat=1e-12,     # Error tolerance
  maxiter::Int=1000,            # Maximum iterations before convergence
  verbose::Bool=true            # Print out warnings
)
```

Vincenty's Formula for Great Circle Distance
========================
The Vincenty formula provides improved accuracy over the Haversine implementation
at the expense of some added complexity and diminished computational performance.
Unlike the Haversine formula, Vincenty's solution assumes the sphere is oblate (flattened)
which is a more appropriate shape for the Earth's actual curvature.
"""
function vincenty(
          lat1::AbstractFloat,
          lon1::AbstractFloat,
          lat2::AbstractFloat,
          lon2::AbstractFloat,
          radiusA::AbstractFloat=EARTH_RADIUS_EQUATORIAL;
          radiusB::AbstractFloat=EARTH_RADIUS_POLAR,
          tol::AbstractFloat=1e-12,
          maxiter::Int=1000,
          verbose::Bool=true, args...)::AbstractFloat
  lat1 = deg2rad(lat1)
  lon1 = deg2rad(lon1)
  lat2 = deg2rad(lat2)
  lon2 = deg2rad(lon2)

  a = radiusA
  b = radiusB
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
  δ = 1. + tol
  n = 0

  while δ > tol && n < maxiter
    n += 1
    sinσ = sqrt( (cos(u2)*sin(λ))^2 + (cos(u1)*sin(u2)-sin(u1)*cos(u2)*cos(λ))^2 )
    cosσ = sin(u1)*sin(u2) + cos(u1)*cos(u2)*cos(λ)
    σ = atan(sinσ/cosσ)
    sinα = (cos(u1)*cos(u2)*sin(λ))/sinσ
    cos2α = 1 - sinα^2
    cos2σm = cosσ - (2*sin(u1)*sin(u2))/cos2α
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

  return b*A*(σ - Δσ)
end

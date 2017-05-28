@test coord_distance(1.0, -1.0, 2.0, -2.0) > 0
@test coord_distance(1.0, -1.0, 2.0, -2.0, calcfunc=vincenty, radius=EARTH_RADIUS_EQUATORIAL) > 0
@test coord_distance(1.0, -1.0, 2.0, -2.0, calcfunc=haversine) > 0
@test coord_distance((1., -1.),(2.,-2.), calcfunc=vincenty) > 0

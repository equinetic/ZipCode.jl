@test coord_distance(1.0, -1.0, 2.0, -2.0) > 0
@test coord_distance(1.0, -1.0, 2.0, -2.0, calcfunc=vincenty, radius=EARTH_RADIUS_EQUATORIAL) > 0
@test coord_distance(1.0, -1.0, 2.0, -2.0, calcfunc=haversine) > 0
@test coord_distance((1., -1.),(2.,-2.), calcfunc=vincenty) > 0
@test haversine(1., -1., 2., -2., EARTH_RADIUS_POLAR) > 0
@test flatpythagorean(1., -1., 2., -2., EARTH_RADIUS_EQUATORIAL) > 0
@test vincenty(1., -1., 2., -2., EARTH_RADIUS_POLAR) > 0
@test coord_distance(1.0, -1.0, 2.0, -2.0, units=u"mi") > 0
@test coord_distance(1.0, -1.0, 2.0, -2.0, units=u"mi", returntype=Rational{Int64}) > 0

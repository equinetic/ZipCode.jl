@test CoordinateDistance(1.0, -1.0, 2.0, -2.0) > 0
@test CoordinateDistance(1.0, -1.0, 2.0, -2.0, calcfunc=Vincenty, radius=EARTH_RADIUS_EQUATORIAL) > 0
@test CoordinateDistance(1.0, -1.0, 2.0, -2.0, calcfunc=Haversine) > 0
@test CoordinateDistance((1., -1.),(2.,-2.), calcfunc=Vincenty) > 0

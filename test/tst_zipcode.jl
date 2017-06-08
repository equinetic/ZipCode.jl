@test rowcoord(ZIPCODES[1, :]) == (43.005895,-71.013202)
@test length(rowcoord(ZIPCODES)) == nrow(ZIPCODES)

module ZipCodes

using   DataFrames

export  ZIPCODES,                     # Constant DataFrame
        ZipCodeCleaner,               # Pattern-Function type
        CleanZipCode,                 # Apply ZipCodeCleaner to Zip
        CoordinateDistance,           # Calculate distance between lat/lon
        Haversine,                    # Haversine distance calculation
        Vincenty,                     # Vincenty distance calculation
        EARTH_RADIUS_EQUATORIAL,      # Equatorial radius (meters)
        EARTH_RADIUS_POLAR,           # Polar radius (meters)
        RowCoord                      # (lat, long) for dataframe row

const ZIPCODES = readtable("./src/data/zipcode.csv", eltypes=[String,String,String,Float64,Float64,Int64,Int64])

include("./cleanzips.jl")
include("./distance.jl")

function RowCoord(df::DataFrame)::Tuple{Float64, Float64}
  return(df[:latitude][1], df[:longitude][1])
end

end

module ZipCode

using   DataFrames,
        Unitful

export  ZIPCODES,                     # Constant DataFrame

        cleanzipcode,                 # Applies multiple cleaning functions
             removewhitespace,        # Trailing and leading whitespace
             removezipsuffix,         # ZIP+4 suffix
             padleftzeros,            # Pads leading zeros

        coord_distance,               # Calculate distance between lat/lon
        haversine,                    # Haversine distance calculation
        vincenty,                     # Vincenty distance calculation
        flatpythagorean,              # Flat Earth distance calculation
        EARTH_RADIUS_EQUATORIAL,      # Equatorial radius (meters)
        EARTH_RADIUS_POLAR,           # Polar radius (meters)

        rowcoord                      # (lat, long) for dataframe row

const ZIPCODES = readtable(joinpath(dirname(@__FILE__), "data", "zipcode.csv"),
        eltypes=[String,String,String,Float64,Float64,Int64,Int64])
const PATTERN_ZIPCODE= r"^[0-9]{5}$"
# const PATTERN_CITY = r"^[A-Za-z]{3,}"
# const PATTERN_STATE = r"^[A-Z]{2}"

# Type unions
const StringNA = Union{AbstractString, DataArrays.NAtype}
const Coordinate = Tuple{AbstractFloat, AbstractFloat}

include("./cleanzips.jl")
include("./distance.jl")
include("./utils.jl")

end

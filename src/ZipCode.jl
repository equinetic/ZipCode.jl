"""
ZipCode package

Copyright 2017 Matthew Amos, portions copyright 2021 Gandalf Software, Inc., Scott P. Jones

Licensed under MIT License, see LICENSE
"""
module ZipCode

using CSV, DataFrames, Unitful

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

const ZIPCODES = CSV.File(joinpath(dirname(@__FILE__), "..", "data", "zipcode.csv")) |> DataFrame

const PATTERN_ZIPCODE= r"^[0-9]{5}$"
# const PATTERN_CITY = r"^[A-Za-z]{3,}"
# const PATTERN_STATE = r"^[A-Z]{2}"

# Type unions
const StringNA = Union{String, Missing}
const Coordinate = Tuple{Float64, Float64}

include("cleanzips.jl")
include("distance.jl")
include("utils.jl")

end

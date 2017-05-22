# ZipCodes.jl
<<<<<<< HEAD

[![Build Status](https://travis-ci.org/equinetic/ZipCodes.jl.svg?branch=master)](https://travis-ci.org/equinetic/ZipCodes.jl)

[![Coverage Status](https://coveralls.io/repos/equinetic/ZipCodes.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/equinetic/ZipCodes.jl?branch=master)

[![codecov.io](http://codecov.io/github/equinetic/ZipCodes.jl/coverage.svg?branch=master)](http://codecov.io/github/equinetic/ZipCodes.jl?branch=master)

Package for accessing latitude/longitude by U.S. ZIP Code. This is currently in development.

ZipCodes.jl is inspired by Jeffrey Breen's [zipcode](https://cran.r-project.org/web/packages/zipcode/zipcode.pdf) R package.
Data is sourced from [CivicSpace US ZIP Code Database by Schuyler Erle, August 2004.](https://boutell.com/zipcodes/)

# Installation

This package is not currently registered. To install it, run the following command
in the Julia REPL:

```Julia
Pkg.clone("https://github.com/equinetic/ZipCodes.jl")
using ZipCodes
```


# Features

##### ZIPCODES Global Constant DataFrame

`using ZipCodes` will load a constant dataframe "ZIPCODES" into the global environment. This
data set, compiled by CivicSpace Labs, Inc. (2004), contains 43,191 ZIP codes with the following
columns:
1. ***zip***
2. ***city***
3. ***state*** : abbreviated format
4. ***latitude***
5. ***longitude***
6. ***timezone***
7. ***dst*** : indicator for daylight savings time

Please see the disclaimer section at the bottom of this page for more information.

##### Clean ZIP Codes

Correct zip code for:
  * Leading zeros missing
  * Additional whitespace
  * ZIP+4 suffix (99999-1234)

  ```julia
  CleanZipCode(" 1234-9999")
  ```

  `"01234"`

##### Distance Calculations
```julia
CoordinateDistance(lat1, lon1, lat2, lon2; calcfunc=Vincenty, radius=EARTH_RADIUS_EQUATORIAL)
```

Pass the lat/lon coordinates between two points to get the distance
in meters between them. By default this is calculated using the Vincenty
formula using the Earth's equatorial radius. You may change either of these
by specifying the optional named parameters `calcfunc` and `radius`. This package
currently supports the Haversine (Great Distance) formula as well as EARTH_RADIUS_POLAR.

# Example

```julia
using ZipCodes
using DataFrames
using DataFramesMeta

# Acquire ZIP Codes
dirtyZIPs = ["609", 610, " 00748-1234"]
branch_offices = CleanZipCode.(dirtyZIPs)
headquarters = @where(ZIPCODES, :zip .== "00979")

# Grab coordinates
hq_coord = RowCoord(headquarters)
branch_coords = [RowCoord(@where(ZIPCODES, :zip .== x)) for x in branch_offices]

# Distance from HQ
for i in eachindex(branch_offices)
  dist = CoordinateDistance(hq_coord, branch_coords[i])/1000
  println(branch_offices[i], " : ", @sprintf("%.1fkm", dist))
end
```

# Disclaimer (copied from CivicSpace Labs)

>  This database was composed using ZIP code gazetteers from the US Census Bureau from 1999 and 2000, augmented with additional ZIP code information The database is believed to contain over 98% of the ZIP Codes in current use in the United States. The remaining ZIP Codes absent from this database are entirely PO Box or Firm ZIP codes added in the last five years, which are no longer published by the Census Bureau, but in any event serve a very small minority of the population (probably on the order of .1% or less). Although every attempt has been made to filter them out, this data set may contain up to .5% false positives, that is, ZIP codes that do not exist or are no longer in use but are included due to erroneous data sources. The latitude and longitude given for each ZIP code is typically (though not always) the geographic centroid of the ZIP code; in any event, the location given can generally be expected to lie somewhere within the ZIP code's "boundaries".
=======
Package for accessing latitude/longitude by U.S. ZIP Code
>>>>>>> 3d9d83eda867c6a38aebc54f5bb12c25ba58ac19

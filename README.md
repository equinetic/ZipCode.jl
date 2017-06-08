# ZipCode.jl

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![License](http://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](LICENSE.md)
[![Coverage Status](https://coveralls.io/repos/github/equinetic/ZipCode.jl/badge.svg?branch=master)](https://coveralls.io/github/equinetic/ZipCode.jl?branch=master)
[![Build Status](https://travis-ci.org/equinetic/ZipCode.jl.svg?branch=master)](https://travis-ci.org/equinetic/ZipCode.jl)

Package for accessing latitude/longitude by U.S. ZIP Code.

ZipCode.jl is inspired by Jeffrey Breen's [zipcode](https://cran.r-project.org/web/packages/zipcode/zipcode.pdf) R package.
Data is sourced from [CivicSpace US ZIP Code Database by Schuyler Erle, August 2004.](https://boutell.com/zipcodes/)

# Installation

Run the following command in the Julia REPL:

```Julia
Pkg.add("ZipCode")
using ZipCode
```


# Overview

## ZIPCODES Global Constant DataFrame

`using ZipCode` will load a constant dataframe "ZIPCODES" into the global environment. This
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

## Filter & Extract Information

This package resides on DataFrames.jl to manage and manipulate the data set. A helper
function `roowcord` is provided to quickly extract a tuple of (latitude, longitude)
coordinates from a single row.

**Example**

```julia
# All Ohio ZIP codes
oh_zips = ZIPCODES[ZIPCODES[:state] .== "OH", :]

# Lat/long in a timezone
tgt_zone = ZIPCODES[ZIPCODES[:timezone] .== -4, [:latitude, :longitude]]

# Get vector of (lat, long) tuples
coords = rowcoord(tgt_zone)
```


## Clean ZIP Codes

Correct a zip code for:
  * Leading zeros missing
  * Additional whitespace
  * ZIP+4 suffix (99999-1234)

For vector operations it is recommended to use dot syntax: `cleanzipcode.(zips)`.

Examples:
  ```julia
  cleanzipcode(" 1234-9999")
  cleanzipcode("01234-9999", returnNA=false))
  cleanzipcode("not a zip")
  cleanzipcode("not a zip", enforcestring=true)
  ```

  `"01234"`

  `"01234-9999"`

  `NA`

  `"NA"`

## Distance Calculations
```julia
coord_distance(lat1, lon1, lat2, lon2; calcfunc=vincenty, radius=EARTH_RADIUS_EQUATORIAL)
coord_distance((lat1, lon1), (lat2, lon2); calcfunc=vincenty, radius=EARTH_RADIUS_EQUATORIAL)
```

Pass the lat/lon coordinates between two points to get the distance
in meters between them. By default this is calculated using Vincenty's formula. A default parameter is specified for the Earth's radius and is set to the equatorial radius. The polar radius is also available (see constants below). It is not necessary to adjust this parameter when using the default Vincenty algorithm as both the equatorial and polar radii are inherently built into it.

Further reading:
* [Earth fixed radius](https://en.wikipedia.org/wiki/Earth_radius#Fixed_radius)
* [Vincenty's formula](https://en.wikipedia.org/wiki/Vincenty's_formulae)
* [Haversine](https://en.wikipedia.org/wiki/Haversine_formula)


Available distance calculations:

* `vincenty()`
* `haversine()`
* `flatpythagorean()`

Available radii constants:

* EARTH_RADIUS_EQUATORIAL (6378.1km)
* EARTH_RADIUS_POLAR (6356.8km)

# Example

```julia
using ZipCode
using DataFrames
using DataFramesMeta

# Acquire ZIP Codes
dirtyZIPs = ["609", 610, " 00748-1234"]
branch_offices = cleanzipcode.(dirtyZIPs)
headquarters = @where(ZIPCODES, :zip .== "00979")

# Grab coordinates
hq_coord = rowcoord(headquarters)
branch_coords = [rowcoord(@where(ZIPCODES, :zip .== x)) for x in branch_offices]

# Distance from HQ
for i in eachindex(branch_offices)
  dist = coord_distance(hq_coord, branch_coords[i])/1000
  println(branch_offices[i], " : ", @sprintf("%.1fkm", dist))
end
```

# Disclaimer (copied from CivicSpace Labs)

>  This database was composed using ZIP code gazetteers from the US Census Bureau from 1999 and 2000, augmented with additional ZIP code information The database is believed to contain over 98% of the ZIP Codes in current use in the United States. The remaining ZIP Codes absent from this database are entirely PO Box or Firm ZIP codes added in the last five years, which are no longer published by the Census Bureau, but in any event serve a very small minority of the population (probably on the order of .1% or less). Although every attempt has been made to filter them out, this data set may contain up to .5% false positives, that is, ZIP codes that do not exist or are no longer in use but are included due to erroneous data sources. The latitude and longitude given for each ZIP code is typically (though not always) the geographic centroid of the ZIP code; in any event, the location given can generally be expected to lie somewhere within the ZIP code's "boundaries".

# Sources

* Primary Data Set: https://boutell.com/zipcodes/

* Distance calculations: http://www.movable-type.co.uk/scripts/gis-faq-5.1.html

* Vincenty inverse algorithm: https://en.wikipedia.org/wiki/Vincenty's_formulae

* Earth's equatorial and polar radii: http://topex.ucsd.edu/geodynamics/14gravity1_2.pdf

"""
`rowcoord(df::DataFrame)`

Returns the :latitude and :longitude columns of a dataframe
as a tuple of (latitude, longitude). If the dataframe has more
than 1 row a vector of these tuples is returned.
"""
function rowcoord(df::DataFrame)
  if nrow(df) == 1
    return singlerowcoord(df)
  else
    return [singlerowcoord(df[i, :]) for i=1:nrow(df)]
  end
end

# Returns Coordinate from a single dataframe row
function singlerowcoord(df::DataFrame)::Coordinate
  df[:latitude][1], df[:longitude][1]
end

# Convert distance from default meters
function dist_convert(distance::AbstractFloat,
                      newunit::Unitful.FreeUnits,
                      returntype::Type=AbstractFloat)
   v = 1.0u"m" * distance |> newunit
   return v.val |> returntype
end

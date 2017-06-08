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

function singlerowcoord(df::DataFrame)::Tuple{AbstractFloat, AbstractFloat}
  df[:latitude][1], df[:longitude][1]
end

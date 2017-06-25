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

function singlerowcoord(df::DataFrame)::Coordinate
  df[:latitude][1], df[:longitude][1]
end


macro distancesearch(f::Expr,
      df::DataFrame=ZIPCODES,
      tolerance::AbstractFloat=25.,
      returnclosest::Int=10)
  ex = Expr(:call, f.args[1], parse("df[$(Symbol(f.args[2]))]"), f.args[3])
  sub = df[eval(ex), [:latitude, :longitude]]

end

function rankcoords(c::Coordinate,
                    searchlist::Vector{Coordinate})
  coords = [collect(1:length(searchlist)) [[x[1] x[2]] for x in searchlist]]
  coords = [coords sum(abs(coords[:,[2,3]] .- [c[1] c[2]]), 2)]
end

function dist_convert(distance::AbstractFloat,
                      newunit::Unitful.FreeUnits,
                      returntype::Type=AbstractFloat)
   v = 1.0u"m" * distance |> newunit
   return v.val |> returntype
end

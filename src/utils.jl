"""
rowcoord
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

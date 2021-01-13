using ZipCode
using DataFrames, Unitful
using Test

@testset "cleanzipcode" begin include("tst_cleanzips.jl") end
@testset "distance"     begin include("tst_distance.jl") end
@testset "utils"        begin include("tst_utils.jl") end

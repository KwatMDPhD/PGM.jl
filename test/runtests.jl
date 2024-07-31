using Test: @test

using PGMs

# ----------------------------------------------------------------------------------------------- #

for jl in ("Nodes.jl", "Factors.jl", "Graphs.jl")

    @info "Testing $jl"

    run(`julia --project $jl`)

end

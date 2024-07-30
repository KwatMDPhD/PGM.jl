module PGM

include("PGMNodes.jl")

include("PGMFactors.jl")

include("PGMGraphs.jl")

using .PGMNodes: @node, get_values, set_index!

using .PGMFactors: @factor, p!

using .PGMGraphs: graph

macro ready()

    quote

        using PGM: @factor, @node, set_index!

        import PGM: p!, get_values

    end

end

end

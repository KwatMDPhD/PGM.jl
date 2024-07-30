module PGMs

include("Nodes.jl")

include("Factors.jl")

include("Graphs.jl")

using .Nodes: @node, get_values, set_index!

using .Factors: @factor, p!

using .Graphs: graph

macro ready()

    quote

        using PGMs: @factor, @node, set_index!

        import PGMs: p!, get_values

    end

end

end

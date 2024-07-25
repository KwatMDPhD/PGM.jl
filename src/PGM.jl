module PGM

using Graphs: DiGraph, add_edge!, add_vertex!, nv

# `gr`aph
# `no`de
# `pr`obability
# `sy`mbol

macro graph()

    quote

        const $(esc(:GR)) = DiGraph()

    end

end

abstract type Node end

function get_probability(no)

    no.pr

end

function set_probability!(no, pr)

    no.pr = pr

end

function Base.show(io::IO, no::Node)

    print(io, "$(rsplit(string(typeof(no)), '.'; limit = 2)[end]) = $(get_probability(no))")

end

macro node(sy)

    quote

        mutable struct $sy <: Node

            id::Any

            pr::$(esc(Float64))

        end

        add_vertex!($(esc(:GR)))

    end

end

using Graphs: DiGraph, add_vertex!, nv

using MetaGraphsNext: MetaGraph

# `gr`aph
# `no`de
# `pr`obability
# `sy`mbol

macro graph()

    esc(
        quote

            const GR =
                PGM.MetaGraph(PGM.DiGraph(); label_type = Symbol, vertex_data_type = Float64)

        end,
    )

end

macro node(sy)

    esc(quote

        GR[sy] = 0.0

    end)

end

macro factor(eq)

    pa_..., no = (ty.args[2] for ty in eq.args[1].args[2:end])

    esc(quote

        for pa in pa_

            add_edge!(GR, pa --> no)

        end

        eq

    end)

end


end

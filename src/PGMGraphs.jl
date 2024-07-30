module PGMGraphs

using Graphs: AbstractGraph, SimpleDiGraph, add_edge!, add_vertex!, nv

using ..PGMNodes: PGMNode

using ..PGMFactors: p!

struct PGMGraph

    gr::AbstractGraph

    no_::Vector{DataType}

    no_id::Dict{DataType, UInt16}

    function PGMGraph()

        new(SimpleDiGraph(), DataType[], Dict{DataType, UInt16}())

    end

end

function add_node!(gr, no)

    if haskey(gr.no_id, no)

        error("$no exists.")

    end

    add_vertex!(gr.gr)

    push!(gr.no_, no)

    gr.no_id[no] = nv(gr.gr)

end

function graph(mo)

    gr = PGMGraph()

    for na in names(mo; all = true)

        fi = getfield(mo, na)

        if fi isa DataType && fi <: PGMNode

            add_node!(gr, fi)

        end

    end

    for me in methods(p!)

        pa_ = me.sig.parameters

        if isone(lastindex(pa_))

            continue

        end

        ic = gr.no_id[pa_[2]]

        for pa in pa_[3:end]

            add_edge!(gr.gr, gr.no_id[pa] => ic)

        end

    end

    gr

end

end

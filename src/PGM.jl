module PGM

using Graphs: Graph, SimpleDiGraph, add_edge!, add_vertex!, nv

using MacroTools: combinedef, splitdef

import Base: show

macro ready()

    quote

        using PGM: @edge, @node, set_index!

        import PGM: p!, get_values

    end

end

abstract type PGMNode end

macro node(no, va_)

    quote

        mutable struct $no <: PGMNode

            index::UInt16

            function $no()

                new(0)

            end

            function $no(id)

                no = new()

                set_index!(no, id)

                no

            end

        end

        $(esc(:get_values))(::$(esc(no))) = $(esc(va_))

    end

end

function get_values() end

function set_index!(no, id)

    if !(0 <= id <= lastindex(get_values(no)))

        throw(DomainError(id))

    end

    no.index = id

end

function show(io::IO, no::PGMNode)

    ty = rsplit(string(typeof(no)), '.'; limit = 2)[end]

    va_ = get_values(no)

    id = no.index

    print(io, iszero(id) ? "$ty = $va_" : "$ty = $va_[$id] = $(va_[id])")

end

function p!() end

macro edge(fu)

    if !issorted(splitdef(fu)[:args][2:end]; by = ar -> ar.args[2])

        error("the second to last arguments are not sorted by type name.")

    end

    :($(esc(fu)))

end

struct PGMGraph

    gr::SimpleDiGraph

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

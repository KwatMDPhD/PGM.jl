module PGM

using Graphs: DiGraph, add_edge!, add_vertex!

macro ready()

    esc(quote

        using PGM: @node, get_index, graph, set_index!

        import PGM: get_values, p!

    end)

end

abstract type Node end

macro node(no, va_)

    quote

        mutable struct $no <: Node

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

function get_index(no)

    no.index

end

function Base.show(io::IO, no::Node)

    ty = typeof(no)

    va_ = get_values(no)

    id = get_index(no)

    va = iszero(id) ? "" : va_[id]

    print(io, "$ty $va_[$id] : $va")

end

function p!() end

function graph()

    gr = DiGraph()

    na_ = DataType[]

    for na in names(@__MODULE__)

        if getfield(@__MODULE__, na) isa DataType

            push!(na_, na)

        end

    end

    # TODO: Get edges.
    for me in methods(p!)

        pa_ = me.sig.parameters

        if 1 < lastindex(pa_)

            @info pa_

        end

    end

    na_, gr

end

end

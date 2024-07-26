module PGM

using Graphs: DiGraph, add_edge!, add_vertex!, nv

macro graph()

    quote

        const $(esc(:GR)) = DiGraph()

    end

end

abstract type Node end

macro node(vr, vl)

    vr = esc(vr)

    vl = esc(vl)

    sy = esc(Symbol)

    it = esc(UInt8)

    id = esc(:id)

    ze = esc(zero)

    quote

        mutable struct $vr <: Node

            value::$sy

            index::$it

        end

        $vr($id = $ze($it)) = $vr($vl, id)

    end

end

macro node(vr, vl_...)

    vr = esc(vr)

    vl_ = map(eval, vl_)

    nt = esc(Tuple{Vararg{Symbol}})

    it = esc(UInt8)

    id = esc(:id)

    ze = esc(zero)

    quote

        mutable struct $vr <: Node

            value::$nt

            index::$it

        end

        $vr($id = $ze($it)) = $vr($vl_, id)

    end

end

function _make_string(vl::Symbol, id)

    "@$id $vl"

end

function _make_string(vl_, id)

    st = ""

    for ie in eachindex(vl_)

        if !isone(ie)

            st *= " | "

        end

        if ie == id

            st *= "@$id "

        end

        st *= "$(vl_[ie])"

    end

    st

end

function Base.show(io::IO, no::Node)

    na = rsplit(string(typeof(no)), '.'; limit = 2)[end]

    print(io, "$na = $(_make_string(no.value, no.index))")

end

macro factor(ex)

    pa_..., no = (ty.args[2] for ty in eq.args[1].args[2:end])

    esc(quote

        for pa in pa_

            add_edge!(GR, pa --> no)

        end

        eq

    end)

end

end

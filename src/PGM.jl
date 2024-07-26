module PGM

abstract type Node end

abstract type ContinuousNode <: Node end

abstract type CategoricalNode <: Node end

macro node(no, va)

    ne = esc(no)

    quote

        mutable struct $no <: ContinuousNode

            index::UInt8

        end

        $ne(id = zero(UInt8)) = $ne(id)

        $(esc(:get_value))(::$ne) = $va

    end

end

macro node(no, va_...)

    ne = esc(no)

    quote

        mutable struct $no <: CategoricalNode

            index::UInt8

        end

        $ne(id = zero(UInt8)) = $ne(id)

        $(esc(:get_value))(::$ne) = ($(va_...),)

    end

end

function Base.show(io::IO, no::ContinuousNode)

    va = get_value(no)

    id = get_index(no)

    _show(io, no, iszero(id) ? string(va) : "@$id $va")

end

function Base.show(io::IO, no::CategoricalNode)

    va_ = get_value(no)

    id = get_index(no)

    st = ""

    for ie in eachindex(va_)

        if !isone(ie)

            st *= " | "

        end

        if ie == id

            st *= "@$id "

        end

        st *= string(va_[ie])

    end

    _show(io, no, st)

end

function _show(io, no, st)

    print(io, "$(rsplit(string(typeof(no)), '.'; limit = 2)[end]) = $st")

end

get_value(no) = error("no method for $(typeof(no)).")

get_index(no) = no.index

set_index!(no, id) = no.index = id

p!(ar_...) = error("no method for $(typeof.(ar_)).")

macro factor(fu)

    esc(quote

        $fu

    end)

end

end

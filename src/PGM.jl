module PGM

abstract type Node end

macro node(no, ra)

    ne = esc(no)

    # TODO: Pick UInt based on `ra`.

    quote

        mutable struct $no <: Node

            index::UInt8

        end

        $ne(id = zero(UInt8)) = $ne(id)

        $(esc(:get_value))(::$ne) = $(esc(ra))

    end

end

function Base.show(io::IO, no::Node)

    va_ = get_value(no)

    id = get_index(no)

    va = iszero(id) ? "" : va_[id]

    print(io, "$(typeof(no)) $va_[$id] : $va")

end

_error(ar_) = error("no method defined for $(typeof.(ar_)).")

get_value(ar_...) = _error(ar_)

get_index(no) = no.index

set_index!(no, id) = no.index = id

p!(ar_...) = _error(ar_)

macro factor(fu)

    quote

        $(esc(fu))

    end

end

end

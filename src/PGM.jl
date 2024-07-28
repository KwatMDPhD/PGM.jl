module PGM

abstract type Node end

macro node(no, va_)

    quote

        mutable struct $no <: Node

            index::UInt16

            $no(id) = new(id)

            $no() = $no(0)

        end

        $(esc(:get_values))(::$(esc(no))) = $(esc(va_))

    end

end

function Base.show(io::IO, no::Node)

    ty = typeof(no)

    va_ = get_values(no)

    id = get_index(no)

    va = iszero(id) ? "" : va_[id]

    print(io, "$ty $va_[$id] : $va")

end

get_values(ar_...) = throw(MethodError(get_values, ar_))

get_index(no) = no.index

set_index!(no, id) = no.index = id

p!(ar_...) = throw(MethodError(p!, ar_))

macro factor(fu)

    quote

        $(esc(fu))

    end

end

end

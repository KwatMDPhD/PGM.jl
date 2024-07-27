module PGM

abstract type Node end

macro node(no, va_)

    quote

        mutable struct $no <: Node

            index::UInt16

            $no() = new()

            $no() = $no(zero(UInt16))

        end

        $(esc(:get_values))(::$(esc(no))) = $(esc(va_))

    end

end

function Base.show(io::IO, no::Node)

    ty = typeof(no)

    va_ = get_values(no)

    id = get(no)

    va = iszero(id) ? "" : va_[id]

    print(io, "$ty $va_[$id] : $va")

end

get_values(ar_...) = throw(MethodError(get_values, ar_))

get(no) = no.index

set!(no, id) = no.index = id

p!(ar_...) = throw(MethodError(p!, ar_))

macro factor(fu)

    quote

        $(esc(fu))

    end

end

end

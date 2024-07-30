module PGMNodes

import Base: show

abstract type PGMNode end

function set_index!(no, id)

    if !(0 <= id <= lastindex(get_values(no)))

        throw(DomainError(id))

    end

    no.index = id

end

function get_values() end

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

        function $(esc(:get_values))(::$(esc(no)))

            $(esc(va_))

        end

    end

end

function show(io::IO, no::PGMNode)

    ty = rsplit(string(typeof(no)), '.'; limit = 2)[end]

    va_ = get_values(no)

    id = no.index

    print(io, iszero(id) ? "$ty = $va_" : "$ty = $va_[$id] = $(va_[id])")

end

end

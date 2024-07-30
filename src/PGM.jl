module PGM

using Graphs: SimpleDiGraph, add_edge!, add_vertex!, nv

using MacroTools: combinedef, splitdef

using OrderedCollections: OrderedDict

macro ready()

    quote

        using PGM: @edge, @node, get_index, set_index!

        import PGM: p!, get_values

    end

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

    print(io, iszero(id) ? "$ty $va_" : "$ty $va_[$id] : $(va_[id])")

end

function p!() end

macro edge(fu)

    if !issorted(splitdef(fu)[:args][2:end]; by = ar -> ar.args[2])

        error("the second to last arguments are not sorted by type name.")

    end

    :($(esc(fu)))

end

function graph(mo)

    gr = SimpleDiGraph()

    ty_id = OrderedDict{DataType, UInt16}()

    for na in names(mo; all = true)

        fi = getfield(mo, na)

        if fi isa DataType && fi <: Node

            add_vertex!(gr)

            ty_id[fi] = nv(gr)

        end

    end

    for me in methods(p!)

        pa_ = me.sig.parameters

        if isone(lastindex(pa_))

            continue

        end

        ic = ty_id[pa_[2]]

        for pa in pa_[3:end]

            add_edge!(gr, ty_id[pa] => ic)

        end

    end

    ty_id, gr

end

end

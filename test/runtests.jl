using Test: @test

using PGM: @factor, @node, Node, get_index, set_index!

import PGM: get_values, p!

# ----------------------------------------------------------------------------------------------- #

# ---- #

@macroexpand @node CategoricalNode (:category1, :category2)

# ---- #

@node CategoricalNode (:category1, :category2)

# ---- #

methods(get_values)

# ---- #

ca = CategoricalNode()

# ---- #

foreach(id -> @info(CategoricalNode(id)), eachindex(get_values(ca)))

# ---- #

get_values(ca)

# ---- #

get_index(ca)

# ---- #

set_index!(ca, 2)

# ---- #

@macroexpand @node ContinuousNode range(0, 1, 8)

# ---- #

@node ContinuousNode range(0, 1, 8)

# ---- #

methods(get_values)

# ---- #

co = ContinuousNode()

# ---- #

foreach(id -> @info(ContinuousNode(id)), eachindex(get_values(co)))

# ---- #

get_values(co)

# ---- #

get_index(co)

# ---- #

set_index!(co, 8)

# ---- #

@macroexpand @factor p!(no::Node) = begin

    set_index!(no, 0)

end

# ---- #

@factor p!(ca::CategoricalNode) = begin

    set_index!(ca, rand() < 0.5 ? 1 : 2)

end

# ---- #

p!(ca)

# ---- #

ca

# ---- #

@factor p!(co::ContinuousNode) = begin

    set_index!(co, rand(1:8))

end

# ---- #

p!(co)

# ---- #

co

# ---- #

@node Child (:odd, :even, :differ)

# ---- #

@factor p!(ch::Child; ca::CategoricalNode, co::ContinuousNode) = begin

    id_ = get_index(ca), get_index(co)

    set_index!(ch, if all(isodd, id_)

        1

    elseif all(iseven, id_)

        2

    else

        3

    end)

end

# ---- #

ch = Child()

# ---- #

begin

    p!(ca)

    p!(co)

    p!(ch; ca, co)

    @info "" ca co ch

end

# ---- #

include("NatureNurture.jl")

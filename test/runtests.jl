using Test: @test

using PGM

# ----------------------------------------------------------------------------------------------- #

# ---- #

@macroexpand @ready

# ---- #

@ready

# ---- #

@macroexpand @node CategoricalNode (:category1, :category2)

# ---- #

@node CategoricalNode (:category1, :category2)

# ---- #

foreach(id -> @info(CategoricalNode(id)), 0:2)

# ---- #

ca = CategoricalNode()

# ---- #

get_values(ca)

# ---- #

get_index(ca)

# ---- #

set_index!(ca, 2)

# ---- #

try

    set_index!(ca, 3)

catch er

    @test er isa DomainError

end

# ---- #

@macroexpand @node ContinuousNode range(0, 1, 8)

# ---- #

@node ContinuousNode range(0, 1, 8)

# ---- #

foreach(id -> @info(ContinuousNode(id)), 0:8)

# ---- #

co = ContinuousNode()

# ---- #

get_values(co)

# ---- #

get_index(co)

# ---- #

set_index!(co, 8)

# ---- #

try

    set_index!(co, 9)

catch er

    @test er isa DomainError

end

# ---- #

function p!(ca::CategoricalNode)

    set_index!(ca, rand() < 0.5 ? 1 : 2)

end

# ---- #

begin

    p!(ca)

    @info "" ca

end

# ---- #

function p!(co::ContinuousNode)

    set_index!(co, rand(1:8))

end

# ---- #

begin

    p!(co)

    @info "" co

end

# ---- #

@node Child (:odd, :even, :differ)

# ---- #

function p!(ch::Child; ca::CategoricalNode, co::ContinuousNode)

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

graph()

# ---- #

include("NatureNurture.jl")

using Test: @test

using PGM: @ready

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

ca.index

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

co.index

# ---- #

set_index!(co, 8)

# ---- #

try

    set_index!(co, 9)

catch er

    @test er isa DomainError

end

# ---- #

for sy in (:A, :B, :C)

    eval(:(struct $sy end))

end

# ---- #

@macroexpand @factor function fu(a::A, b::B, c::C) end

# ---- #

@factor function fu(a::A, b::B, c::C)

    @info "" a b c

end

# ---- #

@test isone(lastindex(methods(fu)))

# ---- #

@test hasmethod(fu, Tuple{A, B, C})

# ---- #

fu(A(), B(), C())

# ---- #

@factor function p!(ca::CategoricalNode)

    set_index!(ca, rand() < 0.5 ? 1 : 2)

end

# ---- #

begin

    p!(ca)

    @info "" ca

end

# ---- #

@factor function p!(co::ContinuousNode)

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

@factor function p!(ch::Child, ca::CategoricalNode, co::ContinuousNode)

    id_ = ca.index, co.index

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

    p!(ch, ca, co)

    @info "" ca co ch

end

# ---- #

using PGM: graph

gr = graph(Main)

gr.gr

gr.no_

gr.no_id

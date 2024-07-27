using Test: @test

using PGM

# ----------------------------------------------------------------------------------------------- #

struct S

    f::Any

    S() = new()

    S(f) = new(f)

end

a = S()

isdefined(a, :f)

b = S(1)

isdefined(b, :f)

# ---- #

@macroexpand @node ACategoricalNode (:category1, :category2)

# ---- #

@node ACategoricalNode (:category1, :category2)

# ---- #

supertype(ACategoricalNode)

# ---- #

methods(get_values)

# ---- #

ca = ACategoricalNode()

# ---- #

get_values(ca)

# ---- #

for id in eachindex(get_values(ca))

    @info ACategoricalNode(id)

end

# ---- #

get(ca)

# ---- #

set!(ca, 2)

# ---- #

@macroexpand @node AContinuousNode range(0, 1, 8)

# ---- #

@node AContinuousNode range(0, 1, 8)

# ---- #

supertype(AContinuousNode)

# ---- #

methods(get_values)

# ---- #

co = AContinuousNode()

# ---- #

get_values(co)

# ---- #

for id in eachindex(get_values(co))

    @info AContinuousNode(id)

end

# ---- #

get(co)

# ---- #

set!(co, 8)

# ---- #

@macroexpand @factor p!(ca::ACategoricalNode) = begin

    set!(ca, rand() < 0.5 ? 1 : 2)

end

# ---- #

@factor p!(ca::ACategoricalNode) = begin

    set!(ca, rand() < 0.5 ? 1 : 2)

end

# ---- #

p!(ca)

ca

# ---- #

@factor p!(co::AContinuousNode) = begin

    set!(co, rand(1:8))

end

# ---- #

p!(co)

co

# ---- #

@node Child (:odd, :even, :differ)

@factor p!(ch::Child; ca::ACategoricalNode, co::AContinuousNode) = begin

    id_ = get(ca), get(co)

    set!(ch, if all(isodd, id_)

        1

    elseif all(iseven, id_)

        2

    else

        3

    end)

end

# ---- #

ch = Child()

p!(ca)

p!(co)

p!(ch; ca, co)

[ca, co, ch]

# ---- #

module NatureNurtureNetwork

using PGM: @factor, @node, get, set!

import PGM: get_values, p!

@node Nature (:low, :high)

@node Nurture (:low, :medium, :high)

@node Person range(0, 1, 8)

@factor p!(na::Nature) = begin

    set!(na, rand() < 0.9 ? 1 : 2)

end

@factor p!(nu::Nurture) = begin

    ra = rand()

    set!(nu, if ra < 0.2

        1

    elseif 0.2 <= ra <= 0.8

        2

    elseif 0.8 < ra

        3

    end)

end

@factor p!(pe::Person; na::Nature, nu::Nurture) = begin

    id_ = (get(na), get(nu))

    set!(pe, if id_ == (1, 1) || id_ == (1, 2)

        rand(1:2)

    elseif id_ == (2, 2)

        rand(3:6)

    elseif id_ == (2, 1) || id_ == (1, 3) || id_ == (2, 3)

        rand(7:8)

    end)

end

end

# ---- #

na = NatureNurtureNetwork.Nature()

nu = NatureNurtureNetwork.Nurture()

pe = NatureNurtureNetwork.Person()

# ---- #

p!(na)

p!(nu)

p!(pe; na, nu)

[na, nu, pe]

using Test: @test

using PGM

# ----------------------------------------------------------------------------------------------- #

# ---- #

@macroexpand @node ACategoricalNode (:category1, :category2)

# ---- #

@node ACategoricalNode (:category1, :category2)

# ---- #

supertype(ACategoricalNode)

# ---- #

methods(get_value)

# ---- #

ca = ACategoricalNode()

# ---- #

get_value(ca)

# ---- #

get_index(ca)

# ---- #

set_index!(ca, 2)

# ---- #

@macroexpand @node AContinuousNode range(0, 1, 8)

# ---- #

@node AContinuousNode range(0, 1, 8)

# ---- #

supertype(AContinuousNode)

# ---- #

methods(get_value)

# ---- #

co = AContinuousNode()

# ---- #

get_value(co)

# ---- #

get_index(co)

# ---- #

set_index!(co, 8)

# ---- #

@macroexpand @factor p!(ca::ACategoricalNode) = begin

    set_index!(ca, rand() < 0.5 ? 1 : 2)

end

# ---- #

@factor p!(ca::ACategoricalNode) = begin

    set_index!(ca, rand() < 0.5 ? 1 : 2)

end

# ---- #

p!(ca)

ca

# ---- #

@factor p!(co::AContinuousNode) = begin

    set_index!(co, rand(1:8))

end

# ---- #

p!(co)

co

# ---- #

@node Child (:odd, :even, :differ)

@factor p!(ch::Child; ca::ACategoricalNode, co::AContinuousNode) = begin

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

p!(ca)

p!(co)

p!(ch; ca, co)

[ca, co, ch]

# ---- #

module NatureNurtureNetwork

using PGM: @factor, @node, get_index, set_index!

import PGM: get_value, p!

@node Nature (:low, :high)

@node Nurture (:low, :medium, :high)

@node Person range(0, 1, 8)

@factor p!(na::Nature) = begin

    set_index!(na, rand() < 0.9 ? 1 : 2)

end

@factor p!(nu::Nurture) = begin

    ra = rand()

    set_index!(nu, if ra < 0.2

        1

    elseif 0.2 <= ra <= 0.8

        2

    elseif 0.8 < ra

        3

    end)

end

@factor p!(pe::Person; na::Nature, nu::Nurture) = begin

    id_ = (get_index(na), get_index(nu))

    set_index!(pe, if id_ == (1, 1) || id_ == (1, 2)

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

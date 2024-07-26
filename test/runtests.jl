using Test: @test

using PGM: @factor, @graph, @node

# ----------------------------------------------------------------------------------------------- #

# ---- #

@macroexpand @graph

# ---- #

@graph

# ---- #

GR

# ---- #

@macroexpand @node Variable :value

# ---- #

@node AContinuousVariable :value

# ---- #

o0 = AContinuousVariable()

# ---- #

o1 = AContinuousVariable(255)

# ---- #

@macroexpand @node ACategoricalVariable :category1 :category2

# ---- #

@node ACategoricalVariable :category1 :category2

# ---- #

a0 = ACategoricalVariable()

# ---- #

a1 = ACategoricalVariable(1)

# ---- #

ACategoricalVariable(2)

# ---- #

@factor p!(na::Nature) = begin

    na.index = rand() < 0.9 ? 1 : 2

end

# ---- #

@node Nurture :lower :middle :upper

# ---- #

@factor p!(nu::Nurture) = begin

    ra = rand()

    nu.index = if ra <= 0.1

        1

    elseif 0.1 < ra < 0.9

        2

    elseif 0.9 <= ra

        3

    end

end

# ---- #

@node Person :bad :typical :good

# ---- #

@factor p!(pe::Person, na::Nature, nu::Nurture) = begin

    id_ = na.index, nu.index

    pe.index = if id_ == (1, 1)

        1

    elseif pa_ in ((1, 2), (1, 3), (2, 2))

        2

    elseif pa_ in ((2, 1), (2, 3))

        3

    end

end

# ---- #

@node Outcome :money

# ---- #

@factor p!(ou::Outcome, pe::Person) = begin

    id = pe.index

    ou.value = if isone(id)

        0.2

    elseif id == 2

        0.5

    elseif id == 3

        0.8

    end

end

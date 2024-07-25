using Test: @test

using PGM: factor, graph, node

# ----------------------------------------------------------------------------------------------- #

# ---- #

@graph

@node Nature :bad :good

@factor p!(na::Nature) = begin

    na.value = rand() < 0.9 ? :bad : :good

end

@node Nurture :lower :middle :upper

@factor p!(nu::Nurture) = begin

    ra = rand()

    nu.value = if ra <= 0.1

        :lower

    elseif 0.1 < ra < 0.9

        :middle

    elseif 0.9 <= ra

        :upper

    end

end

@node Person :bad :typical :good

@factor p!(pe::Person, na::Nature, nu::Nurture) = begin

    pa_ = (na, nu)
    
    pe.value = if pa_ == (:bad, :lower)

        :bad

    elseif pa_ in ((:bad, :middle),(:bad, :upper), (:good, :middle))

        :typical

    elseif pa_ in ((:good, :lower),(:good, :upper))

        :good

    end

end

@node Outcome :money

@factor p!(ou::Outcome, pe::Person, ) = begin

    ou.value = if pe == :bad

        0.2

    elseif pe == :typical

        0.5

    elseif pe == :good

        0.8

    end
    
end

module Network

using PGM: @factor, @node, get_index, set_index!

import PGM: p!

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

    id_ = get_index(na), get_index(nu)

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

using PGM: p!

# ---- #

na = Network.Nature()

nu = Network.Nurture()

pe = Network.Person()

# ---- #

p!(na)

p!(nu)

p!(pe; na, nu)

[na, nu, pe]

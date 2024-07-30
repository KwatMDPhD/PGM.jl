module Graph

using PGM: @ready

@ready

@node Nature (:low, :high)

@node Nurture (:low, :medium, :high)

@node Person range(0, 1, 8)

@edge function p!(na::Nature)

    set_index!(na, rand() < 0.9 ? 1 : 2)

end

@edge function p!(nu::Nurture)

    ra = rand()

    set_index!(nu, if ra < 0.2

        1

    elseif 0.2 <= ra <= 0.8

        2

    elseif 0.8 < ra

        3

    end)

end

@edge function p!(pe::Person, na::Nature, nu::Nurture)

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

na = Graph.Nature()

nu = Graph.Nurture()

pe = Graph.Person()

# ---- #

Graph.p!(na)

Graph.p!(nu)

Graph.p!(pe, na, nu)

@info "" na nu pe

module AGraph

using PGM: @ready

@ready

@node Nature (:low, :high)

@node Nurture (:low, :medium, :high)

@node Person range(0, 1, 8)

@factor function p!(na::Nature)

    set_index!(na, rand() < 0.9 ? 1 : 2)

end

@factor function p!(nu::Nurture)

    ra = rand()

    set_index!(nu, if ra < 0.2

        1

    elseif 0.2 <= ra <= 0.8

        2

    elseif 0.8 < ra

        3

    end)

end

@factor function p!(pe::Person, na::Nature, nu::Nurture)

    id_ = na.index, nu.index

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

begin

    na = AGraph.Nature()

    nu = AGraph.Nurture()

    pe = AGraph.Person()

    AGraph.p!(na)

    AGraph.p!(nu)

    AGraph.p!(pe, na, nu)

    @info "" na nu pe

end

# ---- #

using PGM: graph

gr = graph(AGraph)

gr.gr

gr.no_

gr.no_id

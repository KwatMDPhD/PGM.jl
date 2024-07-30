using Test: @test

using Graphs: nv

using PGMs

# ---- #

module Graph1

using PGMs

PGMs.@ready

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

#module Graph2
#
#using PGMs
#
#PGMs.@ready
#
#@node Father (:category1, :category2)
#
#@node Mother range(0, 1, 8)
#
#@node Child (:odd, :even, :differ)
#
#@factor function p!(fa::Father)
#
#    set_index!(fa, rand() < 0.5 ? 1 : 2)
#
#end
#
#@factor function p!(mo::Mother)
#
#    set_index!(mo, rand(1:8))
#
#end
#
#@factor function p!(ch::Child, fa::Father, mo::Mother)
#
#    id_ = fa.index, mo.index
#
#    set_index!(ch, if all(isodd, id_)
#
#        1
#
#    elseif all(iseven, id_)
#
#        2
#
#    else
#
#        3
#
#    end)
#
#end
#
#end

# ---- #

gr = PGMs.Graphs.graph(Graph1)

# ---- #

@test nv(gr.gr) == lastindex(gr.no_) == length(gr.no_id) == 3

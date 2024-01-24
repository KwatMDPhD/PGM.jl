using Test: @test

using Kumo

# ----------------------------------------------------------------------------------------------- #

using OrderedCollections: OrderedSet

using Nucleus

using Kumo: @st, <<, >>

# ---- #

const TE = mkdir(joinpath(Nucleus.TE, "Kumo"))

# ---- #

typeof(Kumo.NO_) === OrderedSet{String}

# ---- #

typeof(Kumo.CL___) === Vector{Tuple{Vararg{String}}}

# ---- #

typeof(Kumo.ED_) === OrderedSet{Tuple{String, String}}

# ---- #

function test_collection(no_, cl___, ed_, pl = true)

    @test Tuple(Kumo.NO_) == no_

    @test Kumo.CL___ == cl___

    @test Tuple(Kumo.ED_) == ed_

    if pl

        Kumo.plot("")

    end

end

# ---- #

test_collection((), [], ())

# ---- #

Kumo._add_node!("Luffy")

# ---- #

test_collection(("Luffy",), fill((), 1), ())

# ---- #

Kumo._add_node!("Zoro")

# ---- #

test_collection(("Luffy", "Zoro"), fill((), 2), ())

# ---- #

Kumo._add_node!("Nami")

# ---- #

Kumo._add_node!("Nami", ("Arlong Pirate",))

# ---- #

test_collection(("Luffy", "Zoro", "Nami"), fill((), 3), ())

# ---- #

for (so, ta) in (("Luffy", "Kaido"), ("BigMama", "Luffy"))

    @test Nucleus.Error.@is Kumo._add_edge!(so, ta)

end

# ---- #

for _ in 1:2

    Kumo._add_edge!("Nami", "Nami")

end

# ---- #

test_collection(("Luffy", "Zoro", "Nami"), fill((), 3), (("Nami", "Nami"),))

# ---- #

Kumo._add_edge!("Zoro", "Nami")

# ---- #

test_collection(("Luffy", "Zoro", "Nami"), fill((), 3), (("Nami", "Nami"), ("Zoro", "Nami")))

# ---- #

Kumo._add_node!("Crew")

# ---- #

Kumo._add_edge!(("Luffy", "Zoro", "Nami"), "Crew")

# ---- #

test_collection(
    ("Luffy", "Zoro", "Nami", "Crew"),
    fill((), 4),
    (("Nami", "Nami"), ("Zoro", "Nami"), ("Luffy", "Crew"), ("Zoro", "Crew"), ("Nami", "Crew")),
)

# ---- #

for no in ("和道一文字", "三代鬼徹", "閻魔")

    Kumo._add_node!(no)

end

# ---- #

Kumo._add_edge!("Zoro", ("和道一文字", "三代鬼徹", "閻魔"))

# ---- #

test_collection(
    ("Luffy", "Zoro", "Nami", "Crew", "和道一文字", "三代鬼徹", "閻魔"),
    fill((), 7),
    (
        ("Nami", "Nami"),
        ("Zoro", "Nami"),
        ("Luffy", "Crew"),
        ("Zoro", "Crew"),
        ("Nami", "Crew"),
        ("Zoro", "和道一文字"),
        ("Zoro", "三代鬼徹"),
        ("Zoro", "閻魔"),
    ),
)

# ---- #

for no in ("Sanji", "Respect", "Competitiveness")

    Kumo._add_node!(no)

end

# ---- #

Kumo._add_edge!(("Zoro", "Sanji"), ("Respect", "Competitiveness"))

# ---- #

test_collection(
    (
        "Luffy",
        "Zoro",
        "Nami",
        "Crew",
        "和道一文字",
        "三代鬼徹",
        "閻魔",
        "Sanji",
        "Respect",
        "Competitiveness",
    ),
    fill((), 10),
    (
        ("Nami", "Nami"),
        ("Zoro", "Nami"),
        ("Luffy", "Crew"),
        ("Zoro", "Crew"),
        ("Nami", "Crew"),
        ("Zoro", "和道一文字"),
        ("Zoro", "三代鬼徹"),
        ("Zoro", "閻魔"),
        ("Zoro", "Respect"),
        ("Zoro", "Competitiveness"),
        ("Sanji", "Respect"),
        ("Sanji", "Competitiveness"),
    ),
)

# ---- #

Kumo.clear!()

# ---- #

test_collection((), [], ())

# ---- #

for (so, ho, re) in (("A", "de", "A.de"), (("A", "B"), "in", "A_B.in"))

    @test Kumo._make_how_node(so, ho) === re

end

# ---- #

for no in ("Ka", "Kw", "Ay", "Zo", "Distraction", "Complexity", "Bad")

    Kumo._add_node!(no)

end

# ---- #

for (so, ho, ta) in (
    ("Ka", "de", "Distraction"),
    ("Kw", "de", ("Bad", "Complexity")),
    (("Ka", "Kw"), "in", "Ay"),
    (("Ka", "Kw"), "in", ("Ay", "Zo")),
)

    Kumo._add_edge!(so, ho, ta)

end

# ---- #

test_collection(
    ("Ka", "Kw", "Ay", "Zo", "Distraction", "Complexity", "Bad", "Ka.de", "Kw.de", "Ka_Kw.in"),
    fill((), 10),
    (
        ("Ka", "Ka.de"),
        ("Ka.de", "Distraction"),
        ("Kw", "Kw.de"),
        ("Kw.de", "Bad"),
        ("Kw.de", "Complexity"),
        ("Ka", "Ka_Kw.in"),
        ("Kw", "Ka_Kw.in"),
        ("Ka_Kw.in", "Ay"),
        ("Ka_Kw.in", "Zo"),
    ),
)

# ---- #

Kumo.clear!()

# ---- #

@macroexpand @st Node

# ---- #

@st Node

# ---- #

test_collection(("Node",), fill((), 1), ())

# ---- #

@macroexpand @st NodeWithClass Class1 Class2

# ---- #

@st NodeWithClass Class1 Class2

# ---- #

test_collection(("Node", "NodeWithClass"), [(), ("Class1", "Class2")], ())

# ---- #

function clear_st(an_)

    Kumo.clear!()

    for an in an_

        eval(:(@st $(Symbol(an))))

    end

end

# ---- #

clear_st('A':'Z')

# ---- #

A << B

# ---- #

(C, D) << E

# ---- #

F << (G, H)

# ---- #

(I, J) << (K, L)

# ---- #

Kumo.plot("")

# ---- #

clear_st('A':'Z')

# ---- #

A >> B

# ---- #

(C, D) >> E

# ---- #

F >> (G, H)

# ---- #

(I, J) >> (K, L)

# ---- #

Kumo.plot("")

# ---- #

const GP_ = ("Ligand", "GPCR", "GPCRLigand", "GP", "GPCRGP", "GOn", "GPCRDone", "Arrestin")

# ---- #

const N_GP = lastindex(GP_)

# ---- #

clear_st(GP_)

# ---- #

(Ligand, GPCR) >> GPCRLigand

# ---- #

(GPCRLigand, GP) >> GPCRGP

# ---- #

GPCRGP >> (GOn, GPCRDone)

# ---- #

Arrestin << GPCRDone

# ---- #

test_collection(
    (GP_..., "Ligand_GPCR.in", "GPCRLigand_GP.in", "GPCRGP.in", "Arrestin.de"),
    fill((), N_GP + 4),
    (
        ("Ligand", "Ligand_GPCR.in"),
        ("GPCR", "Ligand_GPCR.in"),
        ("Ligand_GPCR.in", "GPCRLigand"),
        ("GPCRLigand", "GPCRLigand_GP.in"),
        ("GP", "GPCRLigand_GP.in"),
        ("GPCRLigand_GP.in", "GPCRGP"),
        ("GPCRGP", "GPCRGP.in"),
        ("GPCRGP.in", "GOn"),
        ("GPCRGP.in", "GPCRDone"),
        ("Arrestin", "Arrestin.de"),
        ("Arrestin.de", "GPCRDone"),
    ),
    false,
)

# ---- #

const PR = "GPCR"

# ---- #

Kumo.plot(joinpath(TE, "$PR.html"); ex = "json")

# ---- #

const EL_ = Nucleus.Graph.read(joinpath(TE, "$PR.json"))

# ---- #

const SC_ = vcat(range(0, 1, N_GP), Inf)

# ---- #

const FE_SC = Dict(zip(GP_, SC_))

# ---- #

FE_SC["IMU"] = SC_[end]

# ---- #

const HE_ = Kumo.heat(FE_SC)

# ---- #

const RE = vcat(SC_[1:(end - 1)], zeros(4))

# ---- #

@test HE_ == RE

# ---- #

# 429.226 ns (7 allocations: 752 bytes)
#@btime Kumo.heat(FE_SC);

# ---- #

Kumo.plot(""; el_ = EL_, he_ = HE_)

# ---- #

const FE_X_SA_X_SC = hcat(SC_, 10SC_)

# ---- #

@test Nucleus.Error.@is Kumo.heat(GP_, FE_X_SA_X_SC)

# ---- #

const FE_ = vcat(collect(GP_), "IMU")

# ---- #

const NO_X_SA_X_HE = Kumo.heat(FE_, FE_X_SA_X_SC)

# ---- #

@test NO_X_SA_X_HE == hcat(RE, 10RE)

# ---- #

# 1.242 μs (19 allocations: 2.25 KiB)
#@btime Kumo.heat(FE_, FE_X_SA_X_SC);

# ---- #

const SO_X_TA_X_ED = Kumo.make_edge_matrix()

# ---- #

@test sum(SO_X_TA_X_ED) === length(Kumo.ED_)

# ---- #

# 709.835 ns (10 allocations: 2.08 KiB)
#@btime Kumo.make_edge_matrix();

# ---- #

const NO_X_ID_X_HE = Kumo.play(HE_, SO_X_TA_X_ED)

# ---- #

@test size(NO_X_ID_X_HE, 2) === 30

# ---- #

@test sum.(eachcol(NO_X_ID_X_HE)) == [
    4.0,
    3.928571428571428,
    4.361807614080452,
    4.841196736243137,
    5.204461981358573,
    5.451465133897608,
    5.611092068362889,
    5.711520312695818,
    5.7737610249366345,
    5.812000433388874,
    5.835373519146523,
    5.849616124665676,
    5.858279022978179,
    5.863542283746393,
    5.866737904314711,
    5.868677357056958,
    5.869854140070007,
    5.870568058923495,
    5.871001132883382,
    5.871263827696215,
    5.871423168313263,
    5.871519816284339,
    5.871578437346185,
    5.871613993223707,
    5.871635559102994,
    5.871648639524959,
    5.871656573222147,
    5.871661385260175,
    5.871664303911514,
    5.871666074164041,
]
# ---- #

const REA = [
    0.0,
    0.14285714285714285,
    0.2857142857142857,
    0.42857142857142855,
    1.1219617145500707,
    1.7894690854152187,
    0.62398814233751,
    1.0,
    0.0,
    0.3571428571428571,
    1.1219614175755281,
    -1.0,
]

# ---- #

@test NO_X_ID_X_HE[:, end] == REA

# ---- #

# 15.625 μs (264 allocations: 113.62 KiB)
#@btime Kumo.play(HE_, SO_X_TA_X_ED);

# ---- #

@test isapprox(Kumo.play(NO_X_SA_X_HE, SO_X_TA_X_ED), hcat(REA, 10REA); atol = 0.0001)

# ---- #

# 34.333 μs (574 allocations: 230.89 KiB)
#@btime Kumo.play(NO_X_SA_X_HE, SO_X_TA_X_ED);

# ---- #

for pe in (0, 0.5, 1)

    Kumo.animate(TE, EL_, NO_X_ID_X_HE; pe)

end

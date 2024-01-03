module Kumo

using LinearAlgebra: norm

using OrderedCollections: OrderedSet

using StatsBase: mean

using Nucleus

const NO_ = OrderedSet{String}()

const CL___ = Tuple{Vararg{String}}[]

const ED_ = OrderedSet{Tuple{String, String}}()

function _add_node!(an, cl_ = ())

    no = string(an)

    if no in NO_

        @warn "\"$no\" exists."

        return

    end

    push!(NO_, no)

    push!(CL___, cl_)

    nothing

end

function _add_edge!(an1, an2)

    ed = (string(an1), string(an2))

    for no in ed

        if !(no in NO_)

            error("\"$no\" is missing.")

        end

    end

    if ed in ED_

        @warn "`$ed` exists."

        return

    end

    push!(ED_, ed)

    nothing

end

function _add_edge!(so_::Tuple, ta)

    for so in so_

        _add_edge!(so, ta)

    end

end

function _add_edge!(so, ta_::Tuple)

    for ta in ta_

        _add_edge!(so, ta)

    end

end

function _add_edge!(so_::Tuple, ta_::Tuple)

    for so in so_, ta in ta_

        _add_edge!(so, ta)

    end

end

function _make_how_node(so, ho)

    "$so.$ho"

end

function _make_how_node(so_::Tuple, ho)

    _make_how_node(join(so_, '_'), ho)

end

function _add_edge!(so, ho, ta)

    no = _make_how_node(so, ho)

    _add_node!(no)

    _add_edge!(so, no)

    _add_edge!(no, ta)

end

macro st(sy, cl_...)

    sye = esc(sy)

    quote

        struct $sye end

        _add_node!($sye, $(string.(cl_)))

    end

end

function <<(so, ta)

    _add_edge!(so, "de", ta)

end

function >>(so, ta)

    _add_edge!(so, "in", ta)

end

function clear!()

    empty!(NO_)

    empty!(CL___)

    empty!(ED_)

    nothing

end

function report()

    n_de = n_in = 0

    for no in NO_

        if endswith(no, ".de")

            n_de += 1

        elseif endswith(no, ".in")

            n_in += 1

        end

    end

    @info "$(Nucleus.String.count(length(NO_), "node")) ($(sum(!isempty, CL___)) classed, $n_de decreasing, and $n_in increasing)." NO_

    @info "$(Nucleus.String.count(length(ED_), "edge"))." ED_

end

function _elementize(no, cl_)

    de = '.'

    Dict(
        "data" => Dict("id" => no, "weight" => 0),
        "classes" => if contains(no, de)
            ("ho", Nucleus.String.split_get(no, de, 2), cl_...)
        else
            ("no", cl_...)
        end,
    )

end

function _elementize(ed)

    Dict("data" => Dict("source" => ed[1], "target" => ed[2]))

end

function plot(
    ht;
    el_ = Dict{String, Any}[],
    he_ = Float64[],
    st_ = Dict{String, Any}[],
    nos = 24,
    coe = Nucleus.Color.HEGE,
    col1 = "#ffffff",
    col2 = "#171412",
    #hi = 800,
    #wi = 800,
    ex = "",
)

    if isempty(NO_)

        @warn "There is not any node to plot."

        return

    end

    no_ = _elementize.(NO_, CL___)

    if !isempty(el_)

        Nucleus.Graph.position!(no_, el_)

    end

    if !isempty(he_)

        if lastindex(no_) != lastindex(he_)

            error("Numbers of nodes differ.")

        end

        for (no, he) in zip(no_, he_)

            no["data"]["weight"] = he

            push!(
                st_,
                Dict(
                    "selector" => "#$(no["data"]["id"])",
                    "style" =>
                        Dict("background-color" => Nucleus.Color.color(he, Nucleus.Color.COBW)),
                ),
            )

        end

    end

    ed_ = _elementize.(ED_)

    tri_ = (0.866, 0.5, -0.866, 0.5, 0, -1)

    hos = nos * 0.64

    ga = nos * 0.16

    Nucleus.Graph.plot(
        ht,
        vcat(no_, ed_);
        st_ = append!(
            [
                Dict(
                    "selector" => "node",
                    "style" => Dict(
                        "border-width" => 1.6,
                        "border-color" => Nucleus.Color.HEFA,
                        "font-size" => nos * 0.64,
                    ),
                ),
                Dict(
                    "selector" => ".no",
                    "style" => Dict("height" => nos, "width" => nos, "label" => "data(id)"),
                ),
                Dict(
                    "selector" => ".ho",
                    "style" => Dict("shape" => "polygon", "height" => hos, "width" => hos),
                ),
                Dict(
                    "selector" => ".de",
                    "style" => Dict(
                        "shape-polygon-points" => .-tri_,
                        "background-color" => Nucleus.Color.HEAY,
                    ),
                ),
                Dict(
                    "selector" => ".in",
                    "style" => Dict(
                        "shape-polygon-points" => tri_,
                        "background-color" => Nucleus.Color.HEAG,
                    ),
                ),
                Dict(
                    "selector" => ".nodehover",
                    "style" => Dict(
                        "border-style" => "double",
                        "border-color" => coe,
                        "label" => "data(weight)",
                    ),
                ),
                Dict(
                    "selector" => "edge",
                    "style" => Dict(
                        "source-distance-from-node" => ga,
                        "target-distance-from-node" => ga,
                        "curve-style" => "bezier",
                        "width" => nos * 0.08,
                        "line-opacity" => 0.64,
                        "line-fill" => "linear-gradient",
                        "line-gradient-stop-colors" => (col1, col2),
                        "target-arrow-shape" => "triangle-backcurve",
                        "arrow-scale" => 1.6,
                        "target-arrow-color" => col2,
                    ),
                ),
                Dict(
                    "selector" => ".edgehover",
                    "style" => Dict(
                        "line-opacity" => 1,
                        "line-gradient-stop-colors" => (col1, coe),
                        "target-arrow-color" => coe,
                    ),
                ),
            ],
            st_,
        ),
        la = if isempty(el_)
            Dict(
                "name" => "cose",
                "padding" => 16,
                #"boundingBox" => Dict("y1" => 0, "x1" => 0, "h" => hi, "w" => wi),
                "componentSpacing" => 40,
                "nodeRepulsion" => 8000,
                "idealEdgeLength" => 16,
                "numIter" => 10000,
            )
        else
            Dict("name" => "preset")
        end,
        ex,
        #he = hi,
    )

end

# TODO: Improve.
function heat(fe_sc; no_al_ = Dict{String, Vector{String}}())

    he_ = zeros(length(NO_))

    for (id, no) in enumerate(NO_)

        if haskey(fe_sc, no)

            he_[id] = fe_sc[no]

        else

            sc_ = Float64[]

            for al in no_al_[no]

                if haskey(fe_sc, al)

                    push!(sc_, fe_sc[al])

                end

            end

            if !isempty(sc_)

                he_[id] = mean(sc_)

            end

        end

    end

    he_

end

function heat(fe_, fe_x_sa_x_sc; ke_ar...)

    no_x_sa_x_he = Matrix{Float64}(undef, length(NO_), size(fe_x_sa_x_sc, 2))

    if lastindex(fe_) != size(fe_x_sa_x_sc, 1)

        error("Numbers of features differ.")

    end

    for (id, sc_) in enumerate(eachcol(fe_x_sa_x_sc))

        no_x_sa_x_he[:, id] = heat(Dict(zip(fe_, sc_)); ke_ar...)

    end

    no_x_sa_x_he

end

function make_edge_matrix()

    n = length(NO_)

    so_x_ta_x_ed = falses(n, n)

    no_id = Dict(no => id for (id, no) in enumerate(NO_))

    for (so, ta) in ED_

        so_x_ta_x_ed[no_id[so], no_id[ta]] = true

    end

    so_x_ta_x_ed

end

function anneal(he_::AbstractVector, so_x_ta_x_ed; n_it = 1000, de = 0.5, ch = 0.000001)

    n_no = length(NO_)

    if !(n_no == lastindex(he_) == size(so_x_ta_x_ed, 1) == size(so_x_ta_x_ed, 2))

        error("Numbers of nodes differ.")

    end

    no_x_id_x_he = Matrix{Float64}(undef, n_no, 1 + n_it)

    no_x_id_x_he[:, 1] = he_

    en = enumerate(zip(eachcol(so_x_ta_x_ed), NO_))

    for id in 1:n_it

        id1 = id + 1

        ex = exp((1 - id) * de)

        for (idt, (ed_, ta)) in en

            cu = no_x_id_x_he[idt, id]

            if !any(ed_)

                no_x_id_x_he[idt, id1] = cu

                continue

            end

            he_ = no_x_id_x_he[ed_, id]

            me = mean(he_)

            if contains(ta, '.')

                if any(iszero, he_)

                    no_x_id_x_he[idt, id1] = 0.0

                    continue

                end

                n_ch = lastindex(ta)

                no_x_id_x_he[idt, id1] = view(ta, (n_ch - 1):n_ch) == "de" ? -me : me

            else

                no_x_id_x_he[idt, id1] = max(0.0, cu + me * ex)

            end

        end

        if abs(norm(view(no_x_id_x_he, :, id1)) - norm(view(no_x_id_x_he, :, id))) < ch

            return no_x_id_x_he[:, 1:id1]

        elseif id == n_it

            error("Failed to converge.")

        end

    end

end

function anneal(no_x_sa_x_he, so_x_ta_x_ed; ke_ar...)

    no_x_sa_x_an = similar(no_x_sa_x_he)

    for (id, he_) in enumerate(eachcol(no_x_sa_x_he))

        no_x_id_x_he = anneal(he_, so_x_ta_x_ed; ke_ar...)

        no_x_sa_x_an[:, id] = view(no_x_id_x_he, :, size(no_x_id_x_he, 2))

    end

    no_x_sa_x_an

end

function animate(di, el_, no_x_id_x_he; pe = 0, st_ = Dict{String, Any}[])

    Nucleus.Error.error_missing(di)

    n = size(no_x_id_x_he, 2)

    @info "Animating $(Nucleus.String.count(n, "set")) of heat"

    if iszero(pe)

        ch = true

        pe = 1

        st = "change"

    else

        ch = false

        if pe < 1

            pe = round(Int, n * pe)

        end

        st = "every $pe"

    end

    @info "Plotting $st"

    pn_ = String[]

    pr = joinpath(di, Nucleus.String.make())

    for id in 1:n

        tw = !isone(id)

        if tw && !iszero(id % pe) && id != n

            continue

        end

        pri = "$(pr)_$id"

        he_ = no_x_id_x_he[:, id]

        if ch && tw

            he_ .-= view(no_x_id_x_he, :, id - 1)

        end

        plot("$pri.html"; el_, he_, st_, ex = "png")

        push!(pn_, "$pri.png")

    end

    Nucleus.Plot.animate("$pr.gif", pn_)

end

end

using Test: @test

using PGMs

using PGMs.Factors: @factor

# ---- #

@test isone(lastindex(methods(PGMs.Factors.p!)))

# ---- #

for ch in 'A':'C'

    eval(:(struct $(Symbol(ch)) end))

end

# ---- #

@macroexpand @factor function p!(a::A, c::B, b::C) end

# ---- #

@factor function p!(a::A, c::B, b::C) end

@test hasmethod(p!, Tuple{A, B, C})

using Test: @test

using PGMs.Factors: @factor

import PGMs.Factors: p!

# ---- #

@test isone(lastindex(methods(p!)))

# ---- #

@macroexpand @factor function p!()

end

# ---- #

for ch in 'A':'C'

    eval(:(struct $(Symbol(ch)) end))

end

# ---- #

@factor function p!(a::A, c::B, b::C)

end

# ---- #

@test hasmethod(p!, Tuple{A, B, C})

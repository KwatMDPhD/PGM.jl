using Test: @test

using PGM: @factor, @node, Node, get_index, set_index!

import PGM: get_value

# ----------------------------------------------------------------------------------------------- #

# ---- #

struct ANode <: Node

    index::UInt8

end

no = ANode(0)

try

    get_value(no)

catch er

    er

end

# ---- #

@macroexpand @node AContinuousNode :value

# ---- #

@node AContinuousNode :value

# ---- #

supertype(AContinuousNode)

# ---- #

methods(get_value)

# ---- #

co = AContinuousNode()

# ---- #

get_value(co)

# ---- #

get_index(co)

# ---- #

set_index!(co, 0)

# ---- #

@macroexpand @node ACategoricalNode :category1 :category2

# ---- #

@node ACategoricalNode :category1 :category2

# ---- #

supertype(ACategoricalNode)

# ---- #

methods(get_value)

# ---- #

ca = ACategoricalNode()

# ---- #

get_value(ca)

# ---- #

get_index(ca)

# ---- #

set_index!(ca, 0)

# ---- #

@macroexpand @factor p!(no::ANode) = begin

    no.index = 0

end

# ---- #

@factor p!(no::AContinuousNode) = begin

    no.index = rand(1:255)

end

# ---- #

@factor p!(no::ACategoricalNode) = begin

    no.index = rand() < 0.9 ? 1 : 2

end

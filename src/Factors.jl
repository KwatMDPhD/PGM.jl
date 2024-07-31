module Factors

using MacroTools: splitdef

function p!() end

macro factor(fu)

    sp = splitdef(fu)

    if sp[:name] != :p!

        error("the function name is not `p!`.")

    end

    if !issorted(sp[:args][2:end]; by = ar -> ar.args[2])

        error("the second to last arguments are not sorted by their types.")

    end

    quote

        # TODO: Remove.
        import PGMs.Factors: p!

        # TODO: Refer to `PGMs.Factors.p!`.
        $(esc(fu))

    end

end

end

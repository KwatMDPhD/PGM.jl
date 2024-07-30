module PGMFactors

using MacroTools: splitdef

function p!() end

macro factor(fu)

    if !issorted(splitdef(fu)[:args][2:end]; by = ar -> ar.args[2])

        error("the second to last arguments are not sorted by their type names.")

    end

    esc(quote

        $fu

    end)

end

end

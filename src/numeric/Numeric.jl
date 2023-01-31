module Numeric

function unwrap!(x, period=2π)
    period = convert(eltype(x), period)
    current = first(x)
    @inbounds for k = eachindex(x)
        x[k] = current = current + rem(x[k] - current, period, RoundNearest)
    end
end

function delta_arg(z)
    a = angle.(z)
    unwrap!(a)
    return a[end] - a[1]
end

end # module Numeric
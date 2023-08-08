module Numeric

function unwrap!(x, period=2π)
    period = convert(eltype(x), period)
    current = first(x)
    @inbounds for k = eachindex(x)
        x[k] = current = current + rem(x[k] - current, period, RoundNearest)
    end
end

"""
    delta_arg(z)

The total change of argument of elements of `z`.
"""
function delta_arg(z::AbstractArray{T}) where {T<:Number}
    a = angle.(z)
    unwrap!(a)
    return a[end] - a[1]
end

#TODO: Adaptive step calculation!

#FIXME: Use linear scale here!!!!
# Caller can make it logarithmic.

# function delta_arg(f::Function;
#     x_init=0,
#     t_init=-6,
#     step_init=0.2,
#     step_gain=2,
#     target_interval=(π / 3, π / 6),
#     x_max=10^3)

#     Δϕ_total = 0
#     Δϕ_min, Δϕ_max = target_interval
#     x = x_init
#     ϕ = arg(f(x_init))
#     step = step_init
#     t = t_init
#     xx = []
#     while x < x_max
#         x_new = x_init + 10^t
#         ϕ_new = f(arg(x_new))
#         Δϕ = ϕ_new - ϕ
#         if Δϕ < Δϕ_min
#             step = step * step_gain
#             t += step
#             x, ϕ = x_new, ϕ_new
#             Δϕ_total += Δϕ
#             push!(xx, x)
#         elseif Δϕ > Δϕ_max
#             step = step / step_gain
#         else
#             x, ϕ = x_new, ϕ_new
#             Δϕ_total += Δϕ
#             push!(xx, x)
#         end
#     end
#     return Δϕ, xx
# end

end # module Numeric
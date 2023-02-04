using Revise

using Morana
using Morana.Numeric
using Plots

# %%

t = collect(0:0.1:100)
x = rem.(-25 * t, 2π)

plot(t, x)

xu = copy(x)
Morana.Numeric.unwrap!(xu)

plot!(t, xu)

z = exp.(1im * t)
Morana.Numeric.delta_arg(z)

# %%

F(s) = (s + 0.1)^3 / s^4 / (s + 1)^2 / (s + 100)
Fw(w) = F(1im * w)

w = [10^t for t in range(-3, 4, 1000)]

Mw = 20 .* log10.(abs.(Fw.(w)))

Aw = angle.(Fw.(w))
Morana.Numeric.unwrap!(Aw)

plot(w, Aw / π, xaxis=:log)

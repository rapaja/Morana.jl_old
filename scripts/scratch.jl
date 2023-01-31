using Revise

using Morana
using Morana.Numeric
using Plots

t = collect(0:0.1:100)
x = rem.(-25 * t, 2π)

plot(t, x)

xu = copy(x)
Morana.Numeric.unwrap!(xu)

plot!(t, xu)

z = exp.(1im * t)
Morana.Numeric.delta_arg(z)
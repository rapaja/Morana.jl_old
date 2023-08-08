#%%
import Plots

#%%

ones_like(x) = ones(eltype(x), size(x))

#%% 
Δt = 1e-3
tt = 0.0:Δt:2.0

#%%
ρ = 1

#%% 
xx = NaN * ones_like(tt)
uu = NaN * ones_like(tt)
dd = NaN * ones_like(tt)

dist(t) = 0.25 * sin(4 * 2 * pi * t) + 0.85 * (t > 1.5)

xx[1] = 1.0
for i in eachindex(t[2:end])
    uu[i] = -ρ * sign(xx[i])
    dd[i] = dist(i * Δt)
    xx[i+1] = xx[i] + Δt * (uu[i] + dd[i])
end

#%%
Plots.plot(tt, xx, label="x")
Plots.plot!(tt, dd, label="d")
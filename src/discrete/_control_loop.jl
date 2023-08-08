ones_like(x) = ones(eltype(x), size(x))

function control_loop(plant::DiscreteSystem, ctrl::DiscreteSystem, x0::Vector{T}, z0::Vector{T}, N::Number)
    xx = NaN * ones(eltype(x0), N, states_no(plant))
    yy = NaN * ones(eltype(x0), N, outputs_no(plant))
    zz = NaN * ones(eltype(z0), N, states_no(ctrl))
    uu = NaN * ones(eltype(x0), N, outputs_no(ctrl))
    dd = NaN * ones_like(uu)

    xx[1, :] = x0
    zz[1, :] = z0
    for i in 1:(N-1)
        yy[i, :] = output(plant, xx[i, :])
        uu[i, :] = output(ctrl, zz[i, :], yy[i, :])
        xx[i+1, :] = next_state(plant, xx[i+1, :], uu[i, :] + dd[i, :])
        zz[i+1, :] = next_state(ctrl, zz[i, :], yy[i, :])
    end
end
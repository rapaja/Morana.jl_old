export DiscreteSystem
export DiscreteIntegrator
export init_state, next_state, output

abstract type DiscreteSystem end


struct DiscreteIntegrator{T<:Number} <: DiscreteSystem
    gain::T
end

DiscreteIntegrator(gain::T) where {T<:Number} = DiscreteIntegrator{T}(gain)

init_state(::DiscreteIntegrator{T}) where {T} = zero(T)
next_state(sys::DiscreteIntegrator, state, input) = state + sys.gain * input
output(::DiscreteIntegrator, state) = state

# states_no(sys::DiscreteSystem)
# inputs_no(sys::DiscreteSystem)
# outputs_no(sys::DiscreteSystem)
# next_state(sys::DiscreteSystem, state::Vector{T}, input::Vector{T})
# output(sys::DiscreteSystem, state::Vector{T}, input::Vector{T})
# output(sys::DiscreteSystem, state::Vector{T})

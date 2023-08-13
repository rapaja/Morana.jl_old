export DiscreteIntegrator

struct DiscreteIntegrator{T<:Number} <: Morana.StateSpace.DiscreteStateSpaceSystem
    gain::T
end

# DiscreteIntegrator(gain::T) where {T<:Number} = DiscreteIntegrator{T}(gain)

Morana.StateSpace.default_initial_state(::DiscreteIntegrator{T}) where {T} = zero(T)
Morana.StateSpace.neutral_input(::DiscreteIntegrator{T}, N) where {T} = (zero(T) for _ in 1:N)
Morana.StateSpace.next_state(sys::DiscreteIntegrator, state, input) = state + sys.gain * input

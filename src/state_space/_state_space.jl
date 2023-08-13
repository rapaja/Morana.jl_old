export StateSpaceSystem, default_initial_state, neutral_input, simulate
export DiscreteStateSpaceSystem, next_state

"""
Common base for all state-space models (both discrete and continuous).
"""
abstract type StateSpaceSystem end

"""
    default_initial_state(system)

Returns the default initial state of the system.
"""
default_initial_state(::StateSpaceSystem) = error("Default initial state is not defined.")

"""
    neutral_input(system, interval)

Returns neutral (zero) input for the given `system` over the given `interval` of time.
"""
neutral_input(::StateSpaceSystem, interval) = error("Neutral input is not defined.")

"""
    simulate(system; kwargs...)

Simulates the given system.
"""
simulate(::StateSpaceSystem; kwargs...) = error("SIMULATE not defined.")

"""
Common base for all state-space models with discrete time representation.
"""
abstract type DiscreteStateSpaceSystem <: StateSpaceSystem end

"""
    next_state(system, state, [time, [input]])

Compute the next state of the discrete state-space `system` given the current
`state` and optionally `time` and `input`. The `time` is the discrete time instant
in which the transition is taking place (it is used for time-varying systems).

For user-defined systems, at least the version with state must be defined.
If the 4-parameter method is not defined, it reduces to the 3-parameter one.
If the 3-parameter method is not defined, it reduces to the 2-parameter one.
"""
next_state(::DiscreteStateSpaceSystem, state) = error("STATE → NEXT_STATE map is not defined.")
next_state(system::DiscreteStateSpaceSystem, state, time) = next_state(system, state)
next_state(system::DiscreteStateSpaceSystem, state, time, input) = next_state(system, state, time)

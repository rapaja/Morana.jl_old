export StateSpaceSystem, output, default_initial_state, simulate, forced_response
export DiscreteStateSpaceSystem, next_state

"""
Common base for all state-space models (both discrete and continuous).
"""
abstract type StateSpaceSystem end

"""
    default_initial_state(system)

Returns the default initial state of the system.
"""
default_initial_state(::StateSpaceSystem) = error("DEFAULT_INITIAL_STATE is not defined.")

"""
    output(system, state, [time, [input]])

Output of the state-space `system` with current `state` and optionally given
`input` and `time`. If the `input` is not given, it is assumed that the
output is only state-dependent (and time-dependent). If the `time` is also
not given, the output is assumed to be time-invariant.

For user-defined systems, at least the version with state must be defined.
If the 4-parameter method is not defined, it reduces to the 3-parameter one.
If the 3-parameter method is not defined, it reduces to the 2-parameter one.
"""
output(::StateSpaceSystem, state) = error("STATE  → OUTPUT map is not defined.")
output(system::StateSpaceSystem, state, _) = output(system, state)
output(system::StateSpaceSystem, state, time, _) = output(system, state, time)

"""
    simulate(system, [initial_state, [input]])

Simulates the `system`, optionally given the `input` and `initial_state`.
For autonomous systems, the input is not required. For those systems only the
method with 2 positional arguments need to be defined, and the input arguments
is ignored, even if given.
"""
simulate(::StateSpaceSystem, initial_state) = error("SIMULATE not defined.")
simulate(system::StateSpaceSystem, initial_state, _) = simulate(system, initial_state)

"""
    forced_response(system, input)

Simulate forced response of `system` to the given `input`, assuming default initial
state, as returned by `default_initial_state(system)`.
"""
forced_response(system::StateSpaceSystem, input) = simulate(system, default_initial_state(system), input)

"""
Common base for all state-space models with discrete time representation.
"""
abstract type DiscreteStateSpaceSystem end

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
next_state(system::DiscreteStateSpaceSystem, state, _) = next_state(system, state)
next_state(system::DiscreteStateSpaceSystem, state, time, input) = next_state(system, state, time)


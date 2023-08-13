export parse_initial_state

function parse_initial_state(system, kwargs)
    initial_state = get(kwargs, :initial_state, nothing)
    isnothing(initial_state) ? default_initial_state(system) : initial_state
end

function parse_inputs(system, kwargs)
    inputs = get(kwargs, :inputs, nothing)
    interval = get(kwargs, :interval, nothing)

    if isnothing(inputs) && isnothing(interval)
        error("Either time interval or external input must be specified in simulation. Cannot imply both.")
    end

    if !isnothing(inputs)
        if isnothing(interval)
            return enumerate(inputs)
        else
            return zip(interval, inputs)
        end
    else
        zip(interval, neutral_input(system, interval))
    end
end

function parse_observables(_, kwargs)
    get(kwargs, :observables, Vector{Tuple{Symbol,Function}}())
end

function Morana.StateSpace.simulate(system::Morana.StateSpace.DiscreteStateSpaceSystem; kwargs...)
    journal = Morana.Utils.Journal{Int64,Float64}()
    x = parse_initial_state(system, kwargs)
    observables = parse_observables(system, kwargs)
    for (t, u) in parse_inputs(system, kwargs)
        for (obs_name, obs_value) in observables
            push!(journal, obs_name, t, obs_value(x, t, u))
        end
        x = next_state(system, x, t, u)
    end
    return journal
end
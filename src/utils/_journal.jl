export instant, value
export Journal

using DataStructures: MutableLinkedList

struct Journal{T<:Number,V<:Number}
    entries::Dict{String,MutableLinkedList{Tuple{T,V}}}

    Journal{T,V}() where {T<:Number,V<:Number} = new(Dict{String,MutableLinkedList{Tuple{T,V}}}())
end

function Base.push!(journal::Journal{T,V}, name::String, instant::T, value::V) where {T<:Number,V<:Number}
    lst = get!(() -> MutableLinkedList{Tuple{T,V}}(), journal.entries, name)
    push!(lst, (instant, value))
end

function Base.collect(journal::Journal{T,V}, name::String) where {T<:Number,V<:Number}
    lst = journal.entries[name]
    arr = Array{V}(undef, length(lst), 2)
    for (i, (instant, value)) in enumerate(lst)
        arr[i, 1] = instant
        arr[i, 2] = value
    end
    arr
end
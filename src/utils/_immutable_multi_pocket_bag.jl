export ImmutableMultiPocketBag, insert, push

"""
Immutable dictionary-like collection of items. 
Each item is characterized by a non-zero cardinality.
"""
struct ImmutableMultiPocketBag{T,N}
    parent::ImmutableMultiPocketBag{T,N}
    item::T
    card::N

    ImmutableMultiPocketBag{T,N}() where {T,N} = new()
    ImmutableMultiPocketBag{T,N}(item, card) where {T,N} =
        (empty = new(); iszero(card) ? empty : new(empty, item, card))

    function ImmutableMultiPocketBag{T,N}(parent::ImmutableMultiPocketBag{T,N}, item, card) where {T,N}
        if iszero(card)
            parent
        elseif item ∈ parent
            throw(KeyError("Cannot instantiate a bag with a duplicate key."))
        else
            new(parent, item, card)
        end
    end
end

ImmutableMultiPocketBag(pair::Pair{T,N}) where {T,N} = ImmutableMultiPocketBag{T,N}(pair[1], pair[2])
ImmutableMultiPocketBag(parent::ImmutableMultiPocketBag{T,N}, pair::Pair) where {T,N} = ImmutableMultiPocketBag{T,N}(parent, pair[1], pair[2])
ImmutableMultiPocketBag(parent::ImmutableMultiPocketBag{T,N}, pair::Pair, others::Pair...) where {T,N} = ImmutableMultiPocketBag(ImmutableMultiPocketBag(parent, pair), others...)
ImmutableMultiPocketBag(pair::Pair{T,N}, others::Pair...) where {T,N} = ImmutableMultiPocketBag(ImmutableMultiPocketBag(pair), others...)

Base.isempty(bag::ImmutableMultiPocketBag) = !isdefined(bag, :parent)
Base.length(bag::ImmutableMultiPocketBag) = isempty(bag) ? 0 : 1 + length(bag.parent)
Base.get(bag::ImmutableMultiPocketBag{T,N}, item) where {T,N} = isempty(bag) ? zero(N) : (bag.item == item ? bag.card : get(bag.parent, item))
Base.in(item, bag::ImmutableMultiPocketBag) = !iszero(get(bag, item))
Base.haskey(bag::ImmutableMultiPocketBag, item) = !iszero(get(bag, item))

function Base.iterate(bag::ImmutableMultiPocketBag{K,V}, t=bag) where {K,V}
    isempty(t) && return nothing
    (Pair{K,V}(t.item, t.card), t.parent)
end

Base.Set(bag::ImmutableMultiPocketBag) = Set([(k, v) for (k, v) in bag])

Base.:(==)(first::ImmutableMultiPocketBag, second::ImmutableMultiPocketBag) = Set(first) == Set(second)

function insert(bag::ImmutableMultiPocketBag{T,N}, item, card, modifier) where {T,N}
    if isempty(bag)
        ImmutableMultiPocketBag{T,N}(item, modifier(0, card))
    elseif bag.item == item
        new_card = modifier(bag.card, card)
        if new_card == bag.card
            bag
        elseif iszero(new_card)
            bag.parent
        else
            ImmutableMultiPocketBag{T,N}(bag.parent, item, new_card)
        end
    else
        mod_parent = insert(bag.parent, item, card, modifier)
        if mod_parent == parent
            bag
        else
            ImmutableMultiPocketBag{T,N}(mod_parent, bag.item, bag.card)
        end
    end
end

push(bag::ImmutableMultiPocketBag{T,N}, pair::Pair) where {T,N} = insert(bag, pair[1], pair[2], (old_card, new_card) -> old_card + new_card)

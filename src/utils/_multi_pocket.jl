struct MultiPocket{T,N}
    parent::MultiPocket{T,N}
    item::T
    card::N

    MultiPocket{T,N}() where {T,N} = new()
    MultiPocket{T,N}(item, card) where {T,N} =
        (empty = new(); iszero(card) ? empty : new(empty, item, card))

    function MultiPocket{T,N}(parent::MultiPocket{T,N}, item, card) where {T,N}
        if iszero(card)
            parent
        elseif item ∈ parent
            throw(KeyError("Cannot instantiate a bag with a duplicate key."))
        else
            new(parent, item, card)
        end
    end
end

MultiPocket(pair::Pair{T,N}) where {T,N} = MultiPocket{T,N}(pair[1], pair[2])
MultiPocket(parent::MultiPocket{T,N}, pair::Pair) where {T,N} = MultiPocket{T,N}(parent, pair[1], pair[2])
MultiPocket(parent::MultiPocket{T,N}, pair::Pair, others::Pair...) where {T,N} = MultiPocket(MultiPocket(parent, pair), others...)
MultiPocket(pair::Pair{T,N}, others::Pair...) where {T,N} = MultiPocket(MultiPocket(pair), others...)

Base.isempty(bag::MultiPocket) = !isdefined(bag, :parent)
Base.length(bag::MultiPocket) = isempty(bag) ? 0 : 1 + length(bag.parent)
Base.in(item, bag::MultiPocket) = get(bag, item) != 0
Base.get(bag::MultiPocket{T,N}, item) where {T,N} = isempty(bag) ? zero(N) : (bag.item == item ? bag.card : get(bag.parent, item))
Base.haskey(bag::MultiPocket, item) = !isempty(bag) && (bag.item == item || haskey(bag.parent, item))

function insert(bag::MultiPocket{T,N}, item, card, modifier) where {T,N}
    if iszero(card)
        bag
    elseif !isdefined(bag, :parent)
        MultiPocket{T,N}(item, card)
    elseif bag.item == item
        new_card = modifier(bag.card, card)
        if new_card == bag.card
            bag
        elseif iszero(new_card)
            bag.parent
        else
            MultiPocket{T,N}(bag.parent, item, new_card)
        end
    else
        mod_parent = insert(bag.parent, item, card, modifier)
        if mod_parent == parent
            bag
        else
            MultiPocket{T,N}(mod_parent, bag.item, bag.card)
        end
    end
end

export MultiPocket, insert
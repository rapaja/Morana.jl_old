#TODO: prevent adding zero as cardinality to MultiPocket
struct MultiPocket{T,N}
    parent::MultiPocket{T,N}
    item::T
    card::N

    MultiPocket{T,N}() where {T,N} = new()
    MultiPocket{T,N}(item, card) where {T,N} = (empty = new(); new(empty, item, card))
    MultiPocket{T,N}(parent::MultiPocket{T,N}, item, card) where {T,N} = new(parent, item, card)
end

function cardinality_of(bag::MultiPocket{T,N}, item) where {T,N}
    if !isdefined(bag, :parent)
        zero(N)
    elseif bag.item == item
        bag.card
    else
        cardinality_of(bag.parent, item)
    end
end

# TODO: Handle the zero cardinality case
function modified_with(bag::MultiPocket{T,N}, item, card, modifier) where {T,N}
    if !isdefined(bag, :parent)
        MultiPocket{T,N}(item, card)
    elseif bag.item == item
        new_card = modifier(bag.card, card)
        if new_card == bag.card
            bag
        else
            MultiPocket{T,N}(bag.parent, item, new_card)
        end
    else
        mod_parent = modified_with(bag.parent, item, card, modifier)
        if mod_parent == parent
            bag
        else
            MultiPocket{T,N}(mod_parent, bag.item, bag.card)
        end
    end
end

MultiPocket(pair::Pair{T,N}) where {T,N} = MultiPocket{T,N}(pair[1], pair[2])
MultiPocket(parent::MultiPocket{T,N}, pair::Pair) where {T,N} = MultiPocket{T,N}(parent, pair[1], pair[2])
MultiPocket(parent::MultiPocket{T,N}, pair::Pair, others::Pair...) where {T,N} = MultiPocket(MultiPocket(parent, pair), others...)
MultiPocket(pair::Pair{T,N}, others::Pair...) where {T,N} = MultiPocket(MultiPocket(pair), others...)

export MultiPocket
export cardinality_of, modified_with
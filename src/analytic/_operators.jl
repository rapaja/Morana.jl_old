# Operator +
# ==========

function Base.:+(expr1::MExpression, expr2::MExpression)
    if expr1 == expr2
        ImmutableMultiPocketBag{MExpression,Int64}(expr1, 2) |> MSum
    else
        s = ImmutableMultiPocketBag{MExpression,Int64}(expr1, 1) |> MSum
        s + expr2
    end
end

Base.:+(expr1::MSum, expr2::MExpression) = insert(expr1.terms, expr2, 1, +) |> MSum
Base.:+(expr1::MExpression, expr2::MSum) = expr2 + expr1

function Base.:+(expr1::MSum, expr2::MSum)
    terms = expr1.terms
    for (item, card) in expr2.terms
        terms = insert(terms, item, card, +)
    end
    MSum(terms)
end

Base.:+(expr::MExpression, sym::Symbol) = expr + MSymbol(sym)
Base.:+(sym::Symbol, expr::MExpression) = expr + sym
Base.:+(sym1::Symbol, sym2::Symbol) = MSymbol(sym1) + MSymbol(sym2)

Base.:+(expr::MExpression, num::T) where {T<:Number} = expr + MLiteral(num)
Base.:+(num::T, expr::MExpression) where {T<:Number} = expr + num

# Operator -
# ==========

Base.:-(expr::MExpression) = MProd(MLiteral(-1), expr)
Base.:-(sym::Symbol) = MProd(MLiteral(-1), MSymbol(sym))

Base.:-(expr1::MExpression, expr2::MExpression) = MSum(expr1, -expr2)
Base.:-(expr::MExpression, sym::Symbol) = MSum(expr, -MSymbol(sym))
Base.:-(sym::Symbol, expr::MExpression) = MSum(MSymbol(sym), -expr)
Base.:-(sym1::Symbol, sym2::Symbol) = MSum(MSymbol(sym1), -MSymbol(sym2))
Base.:-(expr::MExpression, num::T) where {T<:Number} = MSum(expr, -MLiteral(num))
Base.:-(num::T, expr::MExpression) where {T<:Number} = MSum(MLiteral(num), -expr)

Base.:*(expr1::MExpression, expr2::MExpression) = MProd(expr1, expr2)
Base.:*(expr::MExpression, sym::Symbol) = MProd(expr, MSymbol(sym))
Base.:*(sym::Symbol, expr::MExpression) = MProd(MSymbol(sym), expr)
Base.:*(sym1::Symbol, sym2::Symbol) = MProd(MSymbol(sym1), MSymbol(sym2))
Base.:*(expr::MExpression, num::T) where {T<:Number} = MProd(expr, MLiteral(num))
Base.:*(num::T, expr::MExpression) where {T<:Number} = MProd(MLiteral(num), expr)

Base.:/(expr1::MExpression, expr2::MExpression) = MDiv(expr1, expr2)
Base.:/(expr::MExpression, sym::Symbol) = MDiv(expr, MSymbol(sym))
Base.:/(sym::Symbol, expr::MExpression) = MDiv(MSymbol(sym), expr)
Base.:/(sym1::Symbol, sym2::Symbol) = MDiv(MSymbol(sym1), MSymbol(sym2))
Base.:/(expr::MExpression, num::T) where {T<:Number} = MDiv(expr, MLiteral(num))
Base.:/(num::T, expr::MExpression) where {T<:Number} = MDiv(MLiteral(num), expr)

Base.:\(expr1::MExpression, expr2::MExpression) = expr2 / expr1
Base.:\(expr::MExpression, sym::Symbol) = sym / expr
Base.:\(sym::Symbol, expr::MExpression) = expr / sym
Base.:\(sym1::Symbol, sym2::Symbol) = sym2 / sym1
Base.:\(expr::MExpression, num::T) where {T<:Number} = num / expr
Base.:\(num::T, expr::MExpression) where {T<:Number} = expr / num

Base.://(expr1::MExpression, expr2::MExpression) = expr1 / expr2

Base.:^(base::MExpression, exponent::MExpression) = MPow(base, exponent)
Base.:^(expr::MExpression, sym::Symbol) = MPow(expr, MSymbol(sym))
Base.:^(sym::Symbol, expr::MExpression) = MPow(MSymbol(sym), expr)
Base.:^(sym1::Symbol, sym2::Symbol) = MPow(MSymbol(sym1), MSymbol(sym2))
Base.:^(expr::MExpression, num::T) where {T<:Number} = MPow(expr, MLiteral(num))
Base.:^(num::T, expr::MExpression) where {T<:Number} = MPow(MLiteral(num), expr)

Base.sqrt(expr::MExpression) = MPow(expr, MLiteral(1 // 2))
Base.exp(expr::MExpression) = MExp(expr)
Base.log(expr::MExpression) = MLog(expr)

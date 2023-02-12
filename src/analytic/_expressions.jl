export MExpression, MLiteral, MSymbol,
    MSum, MProd, MDiv, MPow,
    MExp, MLog,
    MDerivative, MIntegral,
    symbols, is_constant

using Morana.Utils

# Expressions type hierarchy
# ==========================

abstract type MExpression end

struct MLiteral{T<:Number} <: MExpression
    val::T
end

struct MSymbol <: MExpression
    sym::Symbol
end

struct MSum{N} <: MExpression
    terms::MultiPocket{MExpression,N}
end

struct MProd <: MExpression
    factor1::MExpression
    factor2::MExpression
end

struct MDiv <: MExpression
    num::MExpression
    den::MExpression
end

struct MPow <: MExpression
    base::MExpression
    exponent::MExpression
end

struct MExp <: MExpression
    exponent::MExpression
end

struct MLog <: MExpression
    argument::MExpression
end

struct MDerivative <: MExpression
    of::MExpression
    wrt::MExpression
end

struct MIntegral <: MExpression
    of::MExpression
    wrt::MExpression
end

# Equality checking
# =================

__is_eq_binary(a1, a2, b1, b2) = (a1 == b1) && (a2 == b2)
__is_eq_binary_commutative(a1, a2, b1, b2) = __is_eq_binary(a1, a2, b1, b2) || __is_eq_binary(a1, a2, b2, b1)

Base.:(==)(l1::MLiteral{T}, l2::MLiteral{S}) where {S,T} = l1.val == l2.val
Base.:(==)(s1::MSum, s2::MSum) = s1.terms == s2.terms
Base.:(==)(p1::MProd, p2::MProd) = __is_eq_binary_commutative(p1.factor1, p1.factor2, p2.factor1, p2.factor2)
Base.:(==)(d1::MDiv, d2::MDiv) = __is_eq_binary(d1.num, d1.den, d2.num, d2.den)
Base.:(==)(p1::MPow, p2::MPow) = __is_eq_binary(p1.base, p2.exponent, p2.base, p2.exponent)
Base.:(==)(d1::MDerivative, d2::MDerivative) = __is_eq_binary(d1.of, d1.wrt, d2.of, d2.wrt)
Base.:(==)(i1::MIntegral, i2::MIntegral) = __is_eq_binary(i1.of, i1.wrt, i2.of, i2.wrt)

# Enumeration of variables and constant checks
# ============================================

function symbols(bag::MultiPocket{E,N}) where {E<:MExpression,N<:Number}
    vars = Set([])
    for (item, _) in bag
        union!(vars, symbols(item))
    end
    vars
end

symbols(::MLiteral) = Set([])
symbols(expr::MSymbol) = Set([expr])
symbols(expr::MSum) = symbols(expr.terms)
symbols(expr::MProd) = union(symbols(expr.factor1), symbols(expr.factor2))
symbols(expr::MDiv) = union(symbols(expr.den), symbols(expr.num))
symbols(expr::MPow) = union(symbols(expr.base), symbols(expr.exponent))
symbols(expr::MExp) = symbols(expr.exponent)
symbols(expr::MLog) = symbols(expr.argument)
symbols(expr::MDerivative) = union(symbols(expr.of), symbols(expr.wrt))
symbols(expr::MIntegral) = union(symbols(expr.of), symbols(expr.wrt))

is_constant(expr::MExpression, var::MSymbol) = !(var in symbols(expr))
is_constant(expr::MExpression, vars::AbstractArray{MSymbol}) =
    all([is_constant(expr, v) for v in vars])

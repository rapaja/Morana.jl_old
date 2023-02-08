export MExpression, MLiteral, MVariable,
    MSum, MProd, MDiv, MPow,
    MExp, MLog,
    MDerivative, MIntegral,
    variables, is_constant

# Expressions type hierarchy
# ==========================

abstract type MExpression end

struct MLiteral{T<:Number} <: MExpression
    val::T
end

struct MVariable <: MExpression
    sym::Symbol
end

struct MSum <: MExpression
    term1::MExpression
    term2::MExpression
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
Base.:(==)(s1::MSum, s2::MSum) = __is_eq_binary_commutative(s1.term1, s1.term2, s2.term1, s2.term2)
Base.:(==)(p1::MProd, p2::MProd) = __is_eq_binary_commutative(p1.factor1, p1.factor2, p2.factor1, p2.factor2)
Base.:(==)(d1::MDiv, d2::MDiv) = __is_eq_binary(d1.num, d1.den, d2.num, d2.den)
Base.:(==)(p1::MPow, p2::MPow) = __is_eq_binary(p1.base, p2.exponent, p2.base, p2.exponent)
Base.:(==)(d1::MDerivative, d2::MDerivative) = __is_eq_binary(d1.of, d1.wrt, d2.of, d2.wrt)
Base.:(==)(i1::MIntegral, i2::MIntegral) = __is_eq_binary(i1.of, i1.wrt, i2.of, i2.wrt)

# Enumeration of variables and constant checks
# ============================================

variables(::MLiteral{T}) where {T<:Number} = Set([])
variables(expr::MVariable) = Set([expr])
variables(expr::MSum) = union(variables(expr.term1), variables(expr.term2))
variables(expr::MProd) = union(variables(expr.factor1), variables(expr.factor2))
variables(expr::MDiv) = union(variables(expr.den), variables(expr.num))
variables(expr::MPow) = union(variables(expr.base), variables(expr.exponent))
variables(expr::MExp) = variables(expr.exponent)
variables(expr::MLog) = variables(expr.argument)
variables(expr::MDerivative) = union(variables(expr.of), variables(expr.wrt))
variables(expr::MIntegral) = union(variables(expr.of), variables(expr.wrt))

is_constant(expr::MExpression, var::MVariable) = !(var in variables(expr))
is_constant(expr::MExpression, vars::AbstractArray{MVariable}) =
    all([is_constant(expr, v) for v in vars])

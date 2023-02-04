abstract type MExpression end

struct MLiteral{T<:Number} <: MExpression
    val::T
end

MLiteral(val::T) where {T<:Number} = MLiteral{T}(val)

struct MVariable <: MExpression
    sym::Symbol
end

struct MSum <: MExpression
    term1::MExpression
    term2::MExpression
end

Base.:+(expr1::MExpression, expr2::MExpression) = MSum(expr1, expr2)
Base.:+(expr::MExpression, sym::Symbol) = MSum(expr, MVariable(sym))
Base.:+(sym::Symbol, expr::MExpression) = MSum(MVariable(sym), expr)
Base.:+(sym1::Symbol, sym2::Symbol) = MSum(MVariable(sym1), MVariable(sym2))
Base.:+(expr::MExpression, num::T) where {T<:Number} = MSum(expr, MLiteral(num))
Base.:+(num::T, expr::MExpression) where {T<:Number} = MSum(MLiteral(num), expr)

struct MProd <: MExpression
    factor1::MExpression
    factor2::MExpression
end

Base.:-(expr::MExpression) = MProd(MLiteral(-1), expr)
Base.:-(sym::Symbol) = MProd(MLiteral(-1), MVariable(sym))

Base.:-(expr1::MExpression, expr2::MExpression) = MSum(expr1, -expr2)
Base.:-(expr::MExpression, sym::Symbol) = MSum(expr, -MVariable(sym))
Base.:-(sym::Symbol, expr::MExpression) = MSum(MVariable(sym), -expr)
Base.:-(sym1::Symbol, sym2::Symbol) = MSum(MVariable(sym1), -MVariable(sym2))
Base.:-(expr::MExpression, num::T) where {T<:Number} = MSum(expr, -MLiteral(num))
Base.:-(num::T, expr::MExpression) where {T<:Number} = MSum(MLiteral(num), -expr)

Base.:*(expr1::MExpression, expr2::MExpression) = MProd(expr1, expr2)
Base.:*(expr::MExpression, sym::Symbol) = MProd(expr, MVariable(sym))
Base.:*(sym::Symbol, expr::MExpression) = MProd(MVariable(sym), expr)
Base.:*(sym1::Symbol, sym2::Symbol) = MProd(MVariable(sym1), MVariable(sym2))
Base.:*(expr::MExpression, num::T) where {T<:Number} = MProd(expr, MLiteral(num))
Base.:*(num::T, expr::MExpression) where {T<:Number} = MProd(MLiteral(num), expr)

struct MDiv <: MExpression
    num::MExpression
    den::MExpression
end

Base.:/(expr1::MExpression, expr2::MExpression) = MDiv(expr1, expr2)
Base.:/(expr::MExpression, sym::Symbol) = MDiv(expr, MVariable(sym))
Base.:/(sym::Symbol, expr::MExpression) = MDiv(MVariable(sym), expr)
Base.:/(sym1::Symbol, sym2::Symbol) = MDiv(MVariable(sym1), MVariable(sym2))
Base.:/(expr::MExpression, num::T) where {T<:Number} = MDiv(expr, MLiteral(num))
Base.:/(num::T, expr::MExpression) where {T<:Number} = MDiv(MLiteral(num), expr)

Base.:\(expr1::MExpression, expr2::MExpression) = expr2 / expr1
Base.:\(expr::MExpression, sym::Symbol) = sym / expr
Base.:\(sym::Symbol, expr::MExpression) = expr / sym
Base.:\(sym1::Symbol, sym2::Symbol) = sym2 / sym1
Base.:\(expr::MExpression, num::T) where {T<:Number} = num / expr
Base.:\(num::T, expr::MExpression) where {T<:Number} = expr / num

struct MDerivative <: MExpression
    of::MExpression
    wrt::MExpression
end

struct MIntegral <: MExpression
    of::MExpression
    wrt::MExpression
end

abstract type MPowerExpression <: MExpression end

struct MPower <: MPowerExpression
    base::MExpression
    exp::MExpression
end

struct MSquare <: MPowerExpression
    base::MExpression
end

struct MExp <: MExpression
    of::MExpression
end

struct MLog <: MExpression
    of::MExpression
end

abstract type MPolynomialExpression <: MExpression end

struct MExpandedPolynomial <: MPolynomialExpression
    wrt::MExpression
    coeffs::AbstractArray{MExpression}
end

struct MFactoredPolynomial <: MPolynomialExpression
    wrt::MExpression
    zeros::AbstractArray{MExpression}
    gain::MExpression
end

variables(::MLiteral{T}) where {T<:Number} = Set([])
variables(expr::MVariable) = Set([expr])
variables(expr::MSum) = union(variables(expr.term1), variables(expr.term2))
variables(expr::MProd) = union(variables(expr.factor1), variables(expr.factor2))
variables(expr::MDiv) = union(variables(expr.den), variables(expr.num))

is_constant(expr::MExpression, var::MVariable) = !(var in variables(expr))
is_constant(expr::MExpression, vars::AbstractArray{MVariable}) =
    all([is_constant(expr, v) for v in vars])

export MExpression, MLiteral, MVariable, MSum, MProd, MDiv
export MDerivative, MIntegral
export MPowerExpression, MPower, MSquare
export MExp, MLog
export MPolynomialExpression, MExpandedPolynomial, MFactoredPolynomial
export variables, is_constant
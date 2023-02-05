abstract type MExpression end

struct MLiteral{T<:Number} <: MExpression
    val::T
end

Base.:(==)(l1::MLiteral{T}, l2::MLiteral{S}) where {S,T} = l1.val == l2.val

struct MVariable <: MExpression
    sym::Symbol
end

struct MSum <: MExpression
    term1::MExpression
    term2::MExpression
end

Base.:(==)(s1::MSum, s2::MSum) = ((s1.term1 == s2.term1) && (s1.term2 == s2.term2)) ||
                                 ((s1.term1 == s2.term2) && (s1.term2 == s2.term1))

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

Base.:(==)(s1::MProd, s2::MProd) = ((s1.factor1 == s2.factor1) && (s1.factor2 == s2.factor2)) ||
                                   ((s1.factor1 == s2.factor2) && (s1.factor2 == s2.factor1))

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

Base.:(==)(expr1::MDiv, expr2::MDiv) = (expr1.num == expr2.num) &&
                                       (expr1.den == expr2.den)

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

Base.://(expr1::MExpression, expr2::MExpression) = expr1 / expr2

struct MPow <: MExpression
    base::MExpression
    exponent::MExpression
end

Base.:(==)(expr1::MPow, expr2::MPow) = (expr1.base == expr2.base) &&
                                       (expr1.exponent == expr2.exponent)

Base.:^(base::MExpression, exponent::MExpression) = MPow(base, exponent)
Base.:^(expr::MExpression, sym::Symbol) = MPow(expr, MVariable(sym))
Base.:^(sym::Symbol, expr::MExpression) = MPow(MVariable(sym), expr)
Base.:^(sym1::Symbol, sym2::Symbol) = MPow(MVariable(sym1), MVariable(sym2))
Base.:^(expr::MExpression, num::T) where {T<:Number} = MPow(expr, MLiteral(num))
Base.:^(num::T, expr::MExpression) where {T<:Number} = MPow(MLiteral(num), expr)

Base.sqrt(expr::MExpression) = MPow(expr, MLiteral(1 // 2))

struct MExp <: MExpression
    exponent::MExpression
end

Base.exp(expr::MExpression) = MExp(expr)

struct MLog <: MExpression
    argument::MExpression
end

Base.log(expr::MExpression) = MLog(expr)

struct MDerivative <: MExpression
    of::MExpression
    wrt::MExpression
end

Base.:(==)(expr1::MDerivative, expr2::MDerivative) = (expr1.of == expr2.of) &&
                                                     (expr1.wrt == expr2.wrt)

struct MIntegral <: MExpression
    of::MExpression
    wrt::MExpression
end

Base.:(==)(expr1::MIntegral, expr2::MIntegral) = (expr1.of == expr2.of) &&
                                                 (expr1.wrt == expr2.wrt)

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

export MExpression, MLiteral, MVariable, MSum, MProd, MDiv
export MPowerExpression, MPow
export MExp, MLog
export MDerivative, MIntegral
export variables, is_constant
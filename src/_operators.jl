# Operator +
# ==========

Base.:+(expr1::MExpression, expr2::MExpression) = MSum(expr1, expr2)
Base.:+(expr::MExpression, sym::Symbol) = MSum(expr, MVariable(sym))
Base.:+(sym::Symbol, expr::MExpression) = MSum(MVariable(sym), expr)
Base.:+(sym1::Symbol, sym2::Symbol) = MSum(MVariable(sym1), MVariable(sym2))
Base.:+(expr::MExpression, num::T) where {T<:Number} = MSum(expr, MLiteral(num))
Base.:+(num::T, expr::MExpression) where {T<:Number} = MSum(MLiteral(num), expr)

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

Base.:^(base::MExpression, exponent::MExpression) = MPow(base, exponent)
Base.:^(expr::MExpression, sym::Symbol) = MPow(expr, MVariable(sym))
Base.:^(sym::Symbol, expr::MExpression) = MPow(MVariable(sym), expr)
Base.:^(sym1::Symbol, sym2::Symbol) = MPow(MVariable(sym1), MVariable(sym2))
Base.:^(expr::MExpression, num::T) where {T<:Number} = MPow(expr, MLiteral(num))
Base.:^(num::T, expr::MExpression) where {T<:Number} = MPow(MLiteral(num), expr)

Base.sqrt(expr::MExpression) = MPow(expr, MLiteral(1 // 2))
Base.exp(expr::MExpression) = MExp(expr)
Base.log(expr::MExpression) = MLog(expr)

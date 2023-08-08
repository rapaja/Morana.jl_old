export simplify

# Simplification methods
# ======================

abstract type SimplificationMethod end

struct BasicSimplification <: SimplificationMethod end

# Simplification of generic Expressions
# =====================================

simplify(::SimplificationMethod, expr::MExpression) = expr
simplify(expr::MExpression) = simplify(BasicSimplification(), expr)

simplify(method::SimplificationMethod, expr::MSum) = simplify_sum(method, expr.term1, expr.term2)
simplify(method::SimplificationMethod, expr::MProd) = simplify_prod(method, expr.factor1, expr.factor2)
simplify(method::SimplificationMethod, expr::MDiv) = simplify_div(method, expr.num, expr.den)

# Simplifications of sums
# =======================

simplify_sum(::BasicSimplification, term1::MExpression, term2::MExpression) = MSum(term1, term2)
simplify_sum(::BasicSimplification, term1::MLiteral{T}, term2::MLiteral{S}) where {T,S} = MLiteral(term1.val + term2.val)

# Simplifications of products
# ===========================

simplify_prod(::BasicSimplification, factor1::MExpression, factor2::MExpression) = MProd(factor1, factor2)
simplify_prod(::BasicSimplification, factor1::MLiteral{T}, factor2::MLiteral{S}) where {T,S} = MLiteral(factor1.val * factor2.val)

# Simplifications of divisions
# ============================

simplify_div(::BasicSimplification, num::MExpression, den::MExpression) = MDiv(num, den)
simplify_div(::BasicSimplification, num::MLiteral{T}, den::MLiteral{S}) where {T,S} = MLiteral(num.val / den.val)


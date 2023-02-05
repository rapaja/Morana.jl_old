simplify_sum(term1::MExpression, term2::MExpression) = MSum(term1, term2)
simplify_sum(term1::MLiteral{T}, term2::MLiteral{S}) where {T,S} = MLiteral(term1.val + term2.val)

simplify_prod(factor1::MExpression, factor2::MExpression) = MProd(factor1, factor2)
simplify_prod(factor1::MLiteral{T}, factor2::MLiteral{S}) where {T,S} = MLiteral(factor1.val * factor2.val)

simplify_div(num::MExpression, den::MExpression) = MDiv(num, den)
simplify_div(num::MLiteral{T}, den::MLiteral{S}) where {T,S} = MLiteral(num.val / den.val)

simplify(expr::MExpression) = expr
simplify(expr::MSum) = simplify_sum(expr.term1, expr.term2)
simplify(expr::MProd) = simplify_prod(expr.factor1, expr.factor2)
simplify(expr::MDiv) = simplify_div(expr.num, expr.den)

export simplify
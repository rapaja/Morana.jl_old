export MSum

using Morana.Utils

"""
Finite sum.
"""
struct MSum{N} <: MExpression
    terms::ImmutableMultiPocketBag{MExpression,N}
end

Base.:(==)(s1::MSum, s2::MSum) = s1.terms == s2.terms

symbols(s::MSum{N}) where {N} = union(Set([]), [symbols(e) for e in s]...)

function Base.:+(expr1::MExpression, expr2::MExpression)
    if expr1 == expr2
        ImmutableMultiPocketBag{MExpression,Int64}(expr1, 2) |> MSum
    else
        s = ImmutableMultiPocketBag{MExpression,Int64}(expr1, 1) |> MSum
        s + expr2
    end
end
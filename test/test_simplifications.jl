@testset "Basic simplifications tests" begin
    lit1 = MLiteral(1)
    lit2 = MLiteral(2)
    lit3 = MLiteral(3)
    lit6 = MLiteral(6)
    t = MVariable(:t)
    s = MVariable(:s)

    @testset "Trivial simplifications" begin
        for expr in [lit1, t, s + t, exp(t), log(t), s^t]
            @test simplify(expr) == expr
        end
    end

    @testset "Literal simplification tests" begin
        @test simplify(lit1 + lit1) == lit2
        @test simplify(lit2 * lit3) == lit6
        @test simplify(lit6 / lit2) == lit3
        @test simplify(lit3 \ lit6) == lit2
    end

end
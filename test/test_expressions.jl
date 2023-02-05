@testset "Basic expression tests" begin
    lit1 = MLiteral(1)
    lit1n = MLiteral(-1)
    t = MVariable(:t)
    s = MVariable(:s)

    @testset "MLiteral tests" begin
        @test MLiteral(1 // 2) == MLiteral(1 / 2)
        @test MLiteral(1 // 2) == MLiteral(0.5)
        @test variables(lit1) == Set([])
        @test is_constant(lit1, t)
        @test is_constant(lit1, s)
    end

    @testset "MVariable tests" begin
        @test variables(t) == Set([t])
        @test variables(s) == Set([s])
        @test is_constant(t, s)
        @test is_constant(s, t)
    end

    @testset "Summation tests" begin
        @test (t + s) == MSum(t, s)
        @test variables(t + s) == Set([t, s])
        @test !is_constant(t + s, t)
        @test !is_constant(t + s, s)
        @test (t + s) == (t + :s)
        @test (t + s) == (:t + s)
        @test (t + s) == (:t + :s)
        @test (t + lit1) == (t + 1)
        @test (lit1 + t) == (1 + t)
        @test variables(1 + t) == Set([t])
        @test s + t == t + s
        @test s + t != 1 + t
        @test s + t != t
    end

    @testset "Multiplication tests" begin
        @test (t * s) == MProd(t, s)
        @test variables(t * s) == Set([t, s])
        @test !is_constant(t * s, t)
        @test !is_constant(t * s, s)
        @test (t * s) == (t * :s)
        @test (t * s) == (:t * s)
        @test (t * s) == (:t * :s)
        @test (t * lit1) == (t * 1)
        @test (lit1 * t) == (1 * t)
        @test variables(1 * t) == Set([t])
        @test s * t == t * s
        @test s * t != 1 * t
        @test s * t != t
    end

    @testset "Subtraction tests" begin
        @test -t == lit1n * t
        @test variables(-t) == Set([t])
        @test (t - s) == MSum(t, -s)
        @test variables(t - s) == Set([t, s])
        @test !is_constant(t - s, t)
        @test !is_constant(t - s, s)
        @test (t - s) == (t - :s)
        @test (t - s) == (:t - s)
        @test (t - s) == (:t - :s)
        @test (t - lit1) == (t - 1)
        @test (lit1 - t) == (1 - t)
        @test variables(1 - t) == Set([t])
    end

    @testset "Right division tests" begin
        @test (t / s) == MDiv(t, s)
        @test variables(t / s) == Set([t, s])
        @test !is_constant(t / s, t)
        @test !is_constant(t / s, s)
        @test (t / s) == (t / :s)
        @test (t / s) == (:t / s)
        @test (t / s) == (:t / :s)
        @test (t / lit1) == (t / 1)
        @test (lit1 / t) == (1 / t)
        @test variables(1 / t) == Set([t])
        @test (t / s) == (t // s)
    end

    @testset "Left division tests" begin
        @test (t \ s) == (s / t)
        @test (t \ s) == (s / :t)
        @test (t \ s) == (:s / t)
        @test (t \ s) == (:s / :t)
        @test (t \ 1) == (1 / t)
    end

    @testset "Power expression tests" begin
        @test (t^s) == MPow(t, s)
        @test variables(t^s) == Set([t, s])
        @test !is_constant(t^s, t)
        @test !is_constant(t^s, s)
        @test t^0.5 == sqrt(t)
    end

    @testset "Exponential expressions tests" begin
        @test exp(t) == MExp(t)
        @test !is_constant(exp(s + t), t)
        @test !is_constant(exp(s * t), s)
        @test variables(exp(s + t)) == Set([s, t])
    end

    @testset "Exponential expressions tests" begin
        @test log(t) == MLog(t)
        @test !is_constant(log(s + t), t)
        @test !is_constant(log(s * t), s)
        @test variables(log(s + t)) == Set([s, t])
    end

    @testset "Misc tests" begin
        @test (t^0.5 / 2) == (sqrt(t) / 2)
        @test variables(MDerivative(s, t)) == Set([s, t])
        @test variables(MIntegral(s, t)) == Set([s, t])
        # @test variables(MExpandedPolynomial(t, [MLiteral(2), MLiteral(3)])) == Set([t])
        # @test variables(MExpandedPolynomial(t, [s, 2 * s])) == Set([t, s])
    end

end
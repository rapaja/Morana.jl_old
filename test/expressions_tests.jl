@testset "Basic expression tests" begin
    lit1 = MLiteral(1)
    lit1n = MLiteral(-1)
    t = MVariable(:t)
    s = MVariable(:s)

    @testset "MLiteral tests" begin
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
    end

    @testset "Left division tests" begin
        @test (t \ s) == (s / t)
        @test (t \ s) == (s / :t)
        @test (t \ s) == (:s / t)
        @test (t \ s) == (:s / :t)
        @test (t \ 1) == (1 / t)
    end

end
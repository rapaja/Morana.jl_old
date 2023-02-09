@testset "MultiPocket tests" begin

    e = MultiPocket{Symbol,Int64}()
    a = MultiPocket(:x => 1)
    b = MultiPocket(:x => 1, :y => 2)
    c = MultiPocket(b, :z => 3)

    @testset "Initialization tests" begin
        @test_throws KeyError MultiPocket(a, :x => 2)
        @test_throws KeyError MultiPocket(c, :x => 2)
    end

    @testset "Basic utilities tests" begin
        @test isempty(e)
        @test !isempty(a) && !isempty(b) && !isempty(c)
        @test length(e) == 0 && length(a) == 1 && length(b) == 2 && length(c) == 3
        @test :x ∈ a && :x ∈ b && :x ∈ c
        @test :z ∉ a && :z ∉ b && :z ∈ c
    end

    @testset "Test get" begin
        @test get(a, :x) == 1
        @test get(b, :y) == 2
        @test get(c, :x) == 1
        @test get(c, :z) == 3
        @test get(c, :p) == 0
    end

    @testset "Test in & haskey" begin
        isin(bag, item) = (item ∈ bag) && haskey(bag, item)
        @test isin(a, :x)
        @test isin(b, :y)
        @test isin(c, :x)
        @test isin(c, :z)
        @test !isin(a, :y)
        @test !isin(c, :p)
    end

    @testset "Test insert" begin
        modifier = (old_card, new_card) -> new_card
        @test get(insert(a, :x, 2, modifier), :x) == 2
        @test insert(a, :x, 1, modifier) === a
        @test get(insert(c, :x, 2, modifier), :x) == 2
        @test insert(c, :x, 1, modifier) === c
        @test get(insert(c, :z, 4, modifier), :z) == 4
        @test insert(c, :z, 3, modifier) === c
        @test get(insert(c, :p, 4, modifier), :p) == 4
        @test get(insert(c, :a, 0, modifier), :a) == 0
    end

end
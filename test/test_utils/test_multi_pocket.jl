@testset "MultiPocket tests" begin

    a = MultiPocket(:x => 1)
    b = MultiPocket(:x => 1, :y => 2)
    c = MultiPocket(b, :z => 3)

    @testset "Test cardinality_of" begin
        @test cardinality_of(a, :x) == 1
        @test cardinality_of(b, :y) == 2
        @test cardinality_of(c, :x) == 1
        @test cardinality_of(c, :z) == 3
        @test cardinality_of(c, :p) == 0
    end

    @testset "Test modified_with" begin
        modifier = (old_card, new_card) -> new_card
        @test cardinality_of(modified_with(a, :x, 2, modifier), :x) == 2
        @test modified_with(a, :x, 1, modifier) === a
        @test cardinality_of(modified_with(c, :x, 2, modifier), :x) == 2
        @test modified_with(c, :x, 1, modifier) === c
        @test cardinality_of(modified_with(c, :z, 4, modifier), :z) == 4
        @test modified_with(c, :z, 3, modifier) === c
        @test cardinality_of(modified_with(c, :p, 4, modifier), :p) == 4
    end

end
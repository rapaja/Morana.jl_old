@testset "ImmutableMultiPocketBag tests" begin

    e = ImmutableMultiPocketBag{Symbol,Int64}()
    x_1 = ImmutableMultiPocketBag{Symbol,Int64}(:x, 1)
    xy_1 = ImmutableMultiPocketBag{Symbol,Int64}(x_1, :y, 2)
    x_2 = ImmutableMultiPocketBag(:x => 1)
    xy_2 = ImmutableMultiPocketBag(:x => 1, :y => 2)
    xy_3 = ImmutableMultiPocketBag(x_1, :y => 2)
    xyz_1 = ImmutableMultiPocketBag(xy_1, :z => 3)
    xyz_2 = ImmutableMultiPocketBag(x_1, :y => 2, :z => 3)
    xyz_3 = ImmutableMultiPocketBag(:x => 1, :y => 2, :z => 3)

    @testset "Initialization tests" begin
        @test x_1 == x_2
        @test xy_1 == xy_2 == xy_3
        @test xyz_1 == xyz_2 == xyz_3

        @test_throws KeyError ImmutableMultiPocketBag(x_1, :x => 2)
        @test_throws KeyError ImmutableMultiPocketBag(xy_1, :x => 2)
    end

    x = x_1
    xy = xy_1
    xyz = xyz_1

    @testset "Basic utilities tests" begin
        @test isempty(e)
        @test !isempty(x) && !isempty(xy) && !isempty(xyz)
        @test length(e) == 0 && length(x) == 1 && length(xy) == 2 && length(xyz) == 3
        @test :x ∈ x && :x ∈ xy && :x ∈ xyz
        @test :y ∉ x && :y ∈ xy && :y ∈ xyz
        @test :z ∉ x && :z ∉ xy && :z ∈ xyz
        @test haskey(x, :x) && haskey(xy, :x) && haskey(xyz, :x)
        @test !haskey(x, :y) && haskey(xy, :y) && haskey(xyz, :y)
        @test !haskey(x, :z) && !haskey(xy, :z) && haskey(xyz, :z)
        @test get(xyz, :x) == 1 && get(xyz, :y) == 2 && get(xyz, :z) == 3
    end

    @testset "Set conversion tests" begin
        @test Set(x) == Set([(:x, 1)]) == Set([(:x, 1.0)])
        @test Set(xy) == Set([(:x, 1), (:y, 2)])
        @test Set(xyz) == Set([(:x, 1), (:y, 2), (:z, 3)])
    end

    @testset "Test insert" begin
        modifier = (old_card, new_card) -> new_card

        @test isempty(insert(e, :x, 0, modifier))
        @test get(insert(e, :x, 1, modifier), :x) == 1

        xyz_new = insert(xyz, :x, 2, modifier)
        @test get(xyz_new, :x) == 2 && get(xyz_new, :y) == 2 && get(xyz_new, :z) == 3
        
        @test insert(xyz, :x, 1, modifier) == xyz
        @test insert(xyz, :z, 0, modifier) == xy
    end

    @testset "Test push" begin
        @test get(push(e, :x => 0), :x) == 0
        @test get(push(e, :x => 1), :x) == 1

        xyz_new = push(xyz, :x => 2)
        @test get(xyz_new, :x) == 3 && get(xyz_new, :y) == 2 && get(xyz_new, :z) == 3
        
        @test push(xyz, :x => 0) == xyz
        @test push(xyz, :z => -3) == xy        
    end

end
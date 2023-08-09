@testset "Journal tests" begin
    journal = Morana.Utils.Journal{Int,Float64}()
    push!(journal, "x", 0, 16.25)
    push!(journal, "x", 1, 12.00)
    arr = collect(journal, "x")
    @test arr == [0 16.25; 1 12.00]
end
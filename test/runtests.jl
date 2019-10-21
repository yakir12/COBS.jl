using COBS
using Test

testdata = [[0],
            [0, 0],
            [1, 2, 0, 3],
            [1, 2, 3, 4],
            [1, 0, 0, 0],
            collect(1:254)]

expected = [[1, 1, 0],
            [1, 1, 1, 0],
            [3, 1, 2, 2, 3, 0],
            [5, 1, 2, 3, 4, 0],
            [2, 1, 1, 1, 1, 0],
            [255; 1:254; 0]]

@testset "encoding" begin
    for (raw, encoded) in zip(testdata, expected)
        @test encode(raw) == encoded
    end
end


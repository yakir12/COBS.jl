using COBS
using Test

# these are examples from [the wiki on COBS](https://en.wikipedia.org/wiki/Consistent_Overhead_Byte_Stuffing#Encoding_examples)
payloads = [[0],
            [0, 0],
            [1, 2, 0, 3],
            [1, 2, 3, 4],
            [1, 0, 0, 0],
            collect(1:254)]

messages = [[1, 1, 0],
            [1, 1, 1, 0],
            [3, 1, 2, 2, 3, 0],
            [5, 1, 2, 3, 4, 0],
            [2, 1, 1, 1, 1, 0],
            [255; 1:254; 0]]

@testset "encoding" begin
    for (payload, message) in zip(payloads, messages)
        @test encode(payload) == message
    end
end

@testset "encoding to port" begin
    for (payload, message) in zip(payloads, messages)
        io = IOBuffer()
        encode(io, payload)
        @test take!(io) == message
    end
end

@testset "decoding" begin
    for (message, payload) in zip(messages, payloads)
        @test decode(message) == payload
    end
end


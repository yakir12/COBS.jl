module COBS

export encode

function _doblock(xs)
    n = length(xs)
    ys = Vector{UInt8}(undef, n + 1)
    ind = 0x01
    acc = 0x01
    for x in reverse(xs)
        if iszero(x)
            ys[ind] = acc
            acc = 0x00
        else
            ys[ind] = x
        end
        ind += 0x01
        acc += 0x01
    end
    ys[end] = acc
    return reverse(ys)
end


"""
    encode(sp, payload)

Encode each 254-byte block in the `payload` and directly send 
the data through a specified serial port, `sp`. This is faster
than first encoding the whole payload and then seding it.
"""
function encode(sp, payload)
    for xs in Base.Iterators.partition(payload, 254)
        block = _doblock(xs)
        write(sp, block)
    end
    write(sp, 0x00)
end

"""
    encode(payload)

Return theeEncoded `payload`.
"""
function encode(payload)
    blocks = Vector{Vector{UInt8}}()
    for xs in Base.Iterators.partition(payload, 254)
        block = _doblock(xs)
        push!(blocks, block)
    end
    vcat(blocks..., 0x00)
end

end # module

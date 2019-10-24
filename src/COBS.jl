module COBS

export encode, decode

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

Return the encoded `payload`.
"""
function encode(payload)
    blocks = Vector{Vector{UInt8}}()
    for xs in Base.Iterators.partition(payload, 254)
        block = _doblock(xs)
        push!(blocks, block)
    end
    vcat(blocks..., 0x00)
end

function _f!(y, msg, i1, i2)
    for i in i1 + 1:i2 - 1
        y[i - 1] = msg[i]
    end
    return i2, i2 + msg[i2]
end

"""
    decode(payload)

Return the decoded `payload`.
"""
function decode(msg)
    y = Vector{UInt8}(undef, length(msg) - 2)
    i1 = 0x01
    i2 = i1 + msg[i1]
    i1, i2 = _f!(y, msg, i1, i2)
    while i1 < i2
        y[i1 - 1] = 0
        i1, i2 = _f!(y, msg, i1, i2)
    end
    return y
end



end # module

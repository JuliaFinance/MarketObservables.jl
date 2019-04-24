struct FiniteDepthOrderBook{Tprice, Tvolume} <: AbstractOrderBook{Tprice, Tvolume}
    asks::Vector{Level{Tprice, Tvolume}}  # asks with price ascending ie lowest ask first
    bids::Vector{Level{Tprice, Tvolume}}  # bids with price descending ie highest bid first
    
    # ToDo
    # use SortedDict instead of Vector
    #asks = SortedDict(Dict{Price,Volume}(), Base.Forward)
    #bids = SortedDict(Dict{Price,Volume}(), Base.Reverse)
    
    function FiniteDepthOrderBook(asks::Vector{Level{Tprice, Tvolume}}, bids::Vector{Level{Tprice, Tvolume}}) where {Tprice, Tvolume}
        !issorted(bids, rev=true) && throw(OrderBookException("bids must have price descending"))
        !issorted(asks) && throw(OrderBookException("asks must have price ascending"))
        !isunique(bids) && throw(OrderBookException("bids must have unique prices"))
        !isunique(asks) && throw(OrderBookException("asks must have unique prices"))
        new{Tprice, Tvolume}(asks, bids)
    end

    #function OrderBook(lowest_ask::Price, highest_bid::Price; volume=Volume(0))
    #    bid_vol = ask_vol = volume
    #    bids = [Level(highest_bid, bid_vol)]
    #    asks = [Level(lowest_ask, ask_vol)]
    #    new(asks, bids)
    #end

end

function OrderBook(asks::Vector, bids::Vector)
    FiniteDepthOrderBook(asks, bids)
end


function _price(v_level::Vector{Level{Tprice, Tvolume}}, volume::Tvolume; raise=false) where {Tprice, Tvolume}
    @assert volume >= zero(Tvolume) "volume must be positive or zero"
    remaining_volume = volume
    price_volume_sum = zero(Tprice) * zero(Tvolume)
    for level in v_level
        if level.volume >= remaining_volume
            taken_volume = remaining_volume
            remaining_volume = zero(Tvolume)
            price_volume_sum += (level.price * taken_volume)
            break
        else
            taken_volume = level.volume
            remaining_volume -= level.volume
            price_volume_sum += (level.price * level.volume)
        end
    end
    total_volume = volume - remaining_volume
    price = price_volume_sum / total_volume
    if raise && remaining_volume != zero(Tvolume)
        throw(OrderBookException("Orderbook doesn't have enough depth"))
    end
    price, remaining_volume
end

function bid(ob::FiniteDepthOrderBook, volume::Volume; raise=false)
    if volume == Volume(0)
        ob.bids[1].price, volume
    else
        _price(ob.bids, volume; raise=raise)
    end
end

function ask(ob::FiniteDepthOrderBook, volume::Volume; raise=false)
    if volume == Volume(0)
        ob.asks[1].price, volume
    else
        _price(ob.asks, volume; raise=raise)
    end
end

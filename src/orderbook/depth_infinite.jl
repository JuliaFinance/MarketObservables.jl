struct InfiniteDepthOrderBook{Tprice, Tvolume} <: AbstractOrderBook{Tprice, Tvolume}
    lowest_ask::Tprice
    highest_bid::Tprice
    volume::Tvolume
    
    function InfiniteDepthOrderBook(lowest_ask::Tprice, highest_bid::Tprice; volume::Tvolume=null_volume, unchecked=false) where {Tprice, Tvolume}
        unchecked && return new{Tprice, Tvolume}(lowest_ask, highest_bid, volume)
        highest_bid > lowest_ask && throw(OrderBookException("lowest_ask ($lowest_ask) must be greater than or equal to highest_bid ($highest_bid)"))
        new{Tprice, Tvolume}(lowest_ask, highest_bid, volume)
    end

end

function OrderBook(lowest_ask, highest_bid; volume=null_volume)
    InfiniteDepthOrderBook(lowest_ask, highest_bid; volume=volume)
end

function OrderBook(price; volume=null_volume)
    InfiniteDepthOrderBook(price, price; volume=volume)
end

function bid(ob::InfiniteDepthOrderBook, volume::Tvolume; raise=false) where {Tvolume}
    ob.highest_bid, zero(Tvolume)
end

function ask(ob::InfiniteDepthOrderBook, volume::Tvolume; raise=false) where {Tvolume}
    ob.lowest_ask, zero(Tvolume)
end

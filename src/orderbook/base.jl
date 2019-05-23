abstract type AbstractOrderBook{Tprice, Tvolume} <: AbstractPriceData{Tprice, Tvolume} end

struct OrderBookException <: Exception
    msg::String
end

function price(ob::AbstractOrderBook, volume::Tvolume; raise=false) where {Tvolume}
    if volume == zero(Tvolume)
        midpoint = (bid(ob)[1] + ask(ob)[1]) / 2
        midpoint, volume
    else
        if volume > zero(Tvolume)
            ask(ob, volume; raise=raise)
        else
            bid(ob, -volume; raise=raise)        
        end
    end
end

function bid(ob::AbstractOrderBook{Tprice, Tvolume}) where {Tprice, Tvolume}
    bid(ob, zero(Tvolume))
end

function ask(ob::AbstractOrderBook{Tprice, Tvolume}) where {Tprice, Tvolume}
    ask(ob, zero(Tvolume))
end

function spread(ob::AbstractOrderBook{Tprice, Tvolume}) where {Tprice, Tvolume}
    spread(ob, zero(Tvolume))
end

function spread(ob::AbstractOrderBook, volume::Tvolume; raise=false) where {Tvolume}
    p_ask, remaining_volume_ask = ask(ob, volume; raise=raise)
    p_bid, remaining_volume_bid = bid(ob, volume; raise=raise)
    p_ask - p_bid, remaining_volume_ask, remaining_volume_bid
end

include("level.jl")
include("depth_finite.jl")
include("depth_infinite.jl")

# uncomment to add support for orderbooks provider
# include("provider/lobster.jl")  # https://lobsterdata.com/

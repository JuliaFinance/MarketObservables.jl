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

function bid(ob::AbstractOrderBook)
    bid(ob, Volume(0))
end

function ask(ob::AbstractOrderBook)
    ask(ob, Volume(0))
end

function spread(ob::AbstractOrderBook)
    spread(ob, Volume(0))
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

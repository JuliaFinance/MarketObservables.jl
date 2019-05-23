import Base: show

struct Ticker{Tcounter,Tbase,Tlast,Tvolume} <: MarketObservable
    counter::Tcounter
    base::Tbase
    last::Tlast
    timestamp::DateTime
    volume::Tvolume
    bid::Tlast
    ask::Tlast
    high::Tlast
    low::Tlast

    Ticker(counter, base, last, timestamp, volume, bid, ask, high, low) =
    new{typeof(counter), typeof(base), typeof(last), typeof(volume)}(counter, base, last, timestamp, volume, bid, ask, high, low)
end

function show(io::IO, z::Ticker)
    print(io, Currencies.name(z.counter), " - ",
          Currencies.name(z.base), " | ", z.timestamp,
          "\n--------------------------------",
          "\nLast : ", z.last, " - Volume : ", z.volume,
          "\nHigh : ", z.high," - Low : ", z.low,
          "\nBid : ", z.bid," - Ask : ", z.ask)
end

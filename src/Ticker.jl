import Base: show

struct Ticker{Tcounter,Tbase,Tlast,Tvolume} <: MarketObservable
    counter::Tcounter
    base::Tbase
    last::Tlast
    timestamp::DateTime
    volume::Tvolume
    bid::Tlast
    ask::Tlast
    low::Tlast
    high::Tlast

    Ticker(counter, base, last, timestamp, volume, bid, ask, low, high) =
    new{typeof(counter), typeof(base), typeof(last), typeof(volume)}(counter, base, last, timestamp, volume, bid, ask, low, high)
end

function show(io::IO, z::Ticker)
    print(io, Currencies.name(z.counter), " - ",
          Currencies.name(z.base), " | ", z.timestamp,
          "\n--------------------------------",
          "\nLast : ", z.last, " - Volume : ", z.volume,
          "\nBid : ", z.bid," - Ask : ", z.ask,
          "\nLow : ", z.high," - High : ", z.low)
end

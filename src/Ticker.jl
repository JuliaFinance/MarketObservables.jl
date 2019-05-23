using Currencies, Decimals

import Base: show

struct Ticker <: MarketObservable
    counter::Currency
    base::Currency
    last::Decimal
    timestamp::DateTime
    volume::Decimal
    bid::Decimal
    ask::Decimal
    high::Decimal
    low::Decimal

    Ticker(counter, base, last, timestamp, volume, bid, ask, high, low) =
    new(counter, base, last, timestamp, volume, bid, ask, high, low)
end

function show(io::IO, z::Ticker)
    print(io, Currencies.name(z.counter), " - ",
          Currencies.name(z.base), " | ", z.timestamp,
          "\n--------------------------------",
          "\nLast : ", z.last, " - Volume : ", z.volume,
          "\nHigh : ", z.high," - Low : ", z.low,
          "\nBid : ", z.bid," - Ask : ", z.ask)
end

module MarketObservables

using Dates

abstract type MarketObservable end

include("Ticker.jl")
include("OrderBook.jl")

end # module

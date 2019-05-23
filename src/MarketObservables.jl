module MarketObservables

using Dates

export Ticker

abstract type MarketObservable end

include("types.jl")
include("Ticker.jl")
include("orderbook/base.jl")

end # module

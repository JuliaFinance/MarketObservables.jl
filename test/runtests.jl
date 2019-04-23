using Test, MarketObservables

tests = ["dummy"]

for t ∈ tests
  include("$(t).jl")
end

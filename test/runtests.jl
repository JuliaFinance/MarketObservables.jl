using Test, Glob, MarketObservables

tests = glob("test_")

for test_file ∈ tests
  include(test_file)
end

using Currencies, Dates; import Currencies: USD, EUR

@testset "Ticker" begin
    tick = Ticker(USD, EUR, 1.12, now(), 12345, 1.1, 1.18, 1.0, 1.21)
    @test typeof(tick) <: Ticker
end

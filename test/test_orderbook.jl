using Test
using MarketObservables
using MarketObservables: OrderBook, OrderBookException
using MarketObservables: FiniteDepthOrderBook, InfiniteDepthOrderBook
using MarketObservables: Level, price, bid, ask, spread
using MarketObservables: Volume


@testset "Test Level" begin
    l1 = Level(1.34, 100.2)
    l2 = Level(1.35, 110.2)

    @test l1 < l2
end

@testset "Test FiniteDepthOrderBook" begin
    asks = [Level(110.0, 10.0), Level(111.0, 12.0)]  # asks (ascending asks)
    bids = [Level(100.0, 10.0), Level(99.0, 15.0)]  # bids (descending prices)

    ob = OrderBook(asks, bids)
    @test typeof(ob) <: FiniteDepthOrderBook

    @test bid(ob)[1] == 100.0
    @test ask(ob)[1] == 110.0
    @test spread(ob)[1] == 10.0

    @testset "Low volume" begin
        volume = Volume(15.0)
        expected_bid = (100.0 * 10.0 + 99.0 * 5.0) / 15.0
        calc_bid, = bid(ob, volume)
        @test calc_bid == expected_bid
        expected_ask = (110.0 * 10.0 + 111 * 5.0) / 15.0
        @test ask(ob, volume)[1] == expected_ask
        @test spread(ob, volume)[1] == expected_ask - expected_bid
        @test price(ob, volume) == ask(ob, volume)
        @test price(ob, -volume) == bid(ob, volume)
    end

    @testset "Volume too big for depth of orderbook" begin
        volume = Volume(50.0)
        _spread, _remaining_volume_ask, _remaining_volume_bid = spread(ob, volume)
        @test _remaining_volume_ask != 0
        @test _remaining_volume_bid != 0
    end
    

    @testset "Construction errors" begin
        asks = [Level(111.0, 10.0), Level(110.0, 12.0)]  # asks (NOT ascending asks)
        bids = [Level(100.0, 10.0), Level(99.0, 15.0)]  # bids (descending prices)
        @test_throws OrderBookException OrderBook(asks, bids)

        asks = [Level(110.0, 10.0), Level(111.0, 12.0)]  # asks (ascending asks)
        bids = [Level(99.0, 10.0), Level(100.0, 15.0)]  # bids (NOT descending prices)
        @test_throws OrderBookException OrderBook(asks, bids)

        asks = [Level(111.0, 10.0), Level(111.0, 12.0)]  # asks (NOT unique prices)
        bids = [Level(100.0, 10.0), Level(99.0, 15.0)]  # bids (descending prices)
        @test_throws OrderBookException OrderBook(asks, bids)

        asks = [Level(110.0, 10.0), Level(111.0, 12.0)]  # asks (ascending asks)
        bids = [Level(100.0, 10.0), Level(100.0, 15.0)]  # bids (NOT unique prices)
        @test_throws OrderBookException OrderBook(asks, bids)
    end
    
end

@testset "Test InfiniteDepthOrderBook" begin
    @testset "define with bid/ask" begin
        _ask, _bid = 110.0, 100.0
        ob = OrderBook(_ask, _bid)  # with bid/ask
        @test typeof(ob) <: InfiniteDepthOrderBook
        @test spread(ob)[1] == 10.0

        volume = Volume(50.0)
        @test bid(ob)[1] == 100.0
        @test ask(ob)[1] == 110.0
        @test bid(ob, volume)[1] == 100.0
        @test ask(ob, volume)[1] == 110.0
        _spread, _remaining_volume_ask, _remaining_volume_bid = spread(ob, volume)
        @test _remaining_volume_ask == 0
        @test _remaining_volume_bid == 0
    end

    @testset "define with price (bid==ask)" begin
        price = 100.0
        ob = OrderBook(price)
        @test typeof(ob) <: InfiniteDepthOrderBook
        volume = Volume(50.0)
        @test bid(ob)[1] == price
        @test ask(ob)[1] == price
        _spread, = spread(ob, volume)
        @test _spread == 0
    end

    @testset "Construction errors" begin
        _ask, _bid = 100.0, 110.0  #  NOT ask >= bid
        @test_throws OrderBookException OrderBook(_ask, _bid)
    end
end

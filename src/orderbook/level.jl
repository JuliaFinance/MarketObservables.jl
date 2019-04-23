struct Level{Tprice, Tvolume}
    price::Tprice
    volume::Tvolume
end

import Base: isless
isless(l1::Level, l2::Level) = isless(l1.price, l2.price)

function isunique(v_lev::Array{EOTrader.Level{Tprice,Tvolume},1}) where {Tprice,Tvolume}
    length(unique([lv.price for lv in v_lev])) == length(v_lev)
end

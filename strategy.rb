# code: UTF-8

module Strategy

  # should return an SubmittingOrder object, or 
  # a hash such like: {"buy","cny","etc",1,1}
  def self.make_an_order(depth, market, coin_name, amount, accu_distance=10000)
    # 首先，计算买卖一的价格，然后根据fee计算安全挂单点位
    # mid_price是买卖一的中间值
    # safe_buy是安全买点，即在这个点位买入且成交，至少不会亏损手续费
    fee=get_fee(market,coin_name)
    buy1=depth.bids[0].price
    sell1=depth.asks[0].price
    mid_price=(buy1+sell1)/2
    actual_fee=(fee*100*mid_price).to_f.ceil/100.0
    safe_buy=((mid_price-actual_fee).to_f*100.floor/100).round(2)
    safe_sell=((mid_price+actual_fee).to_f*100.ceil/100).round(2)
    safe=[actual_fee,safe_buy,safe_sell]


    # 然后，找出累计10000元人民币的挂单，在它的内侧放置一个同类型的挂单
    total_buy=0
    total_sell=0
    target_sell_price=0
    depth.asks.each do |ask|
      total_sell+=ask.amount*ask.price
      target_sell_price=ask.price
      if total_sell>=accu_distance
        break
      end
    end
    target_sell_price-=0.01

    target_buy_price=0
    depth.bids.each do |bid|
      total_buy+=bid.amount*bid.price
      target_buy_price=bid.price
      if total_buy>=accu_distance
        break
      end
    end
    target_buy_price+=0.01

    if target_buy_price>safe_buy
      target_buy_price=safe_buy
    end

    if target_sell_price<safe_sell
      target_sell_price=safe_sell
    end

    result={actual_fee: actual_fee, safe_buy:safe_buy, safe_sell:safe_sell, target_buy: target_buy_price, target_sell:target_sell_price}
    pp result
    # type="buy", mk_type='cny',coin_name='btc', price, amount
    return {buy:["buy","cny","etc",target_buy_price,amount], sell:["sell","cny","etc",target_sell_price,amount]}
  end

  def cancel_all_orders

  end

  def self.get_fee(market, coin_name)
    case market.to_s.downcase
      when "chbtc"
        case coin_name.to_s+"_"+"cny"
          when "btc_cny","ltc_cny","etc_cny","eth_cny"
            return 0.0016
          when "btc_cny"
            return 0.0016
          else
            return 0.002
        end
      when ""

    end
  end


end

#  this class represents the orders that you HAVE already submitted, NOT the orders you are submitting!!!
class SubmittedOrder
  attr_accessor :currency, :id, :price, :status, :total_amount, :trade_amount, :trade_date, :trade_money, :trade_price, :type
  def initialize(currency, id, price, status, total_amount, trade_amount, trade_date, trade_money, trade_price, type)
    self.currency=currency
    self.id=id
    self.price=price
    self.status=status
    self.total_amount =total_amount
    self.trade_amount=trade_amount
    self.trade_date=trade_date
    self.trade_money=trade_money
    self.trade_price=trade_price
    self.type=type
  end
end

class CancelOrderResult
  attr_accessor :id, :result, :message, :currency

  def initialize(market, currency, json, order_id)
    self.currency=currency
    json=JSON.parse json
    case market.to_s.downcase
      when "chbtc"
        if json["code"]
          case json["code"].to_s
            when "1000"
              self.result=true
              self.message="操作成功"
              self.id=order_id
            else
              self.result=false
              self.message=json["message"]
              self.id=order_id
          end
        else
          return nil
        end
      when "okcoin"
        if json["result"]
          case json["result"].to_s
            when "true"
              self.result=true
              self.message="操作成功"
              self.id=order_id
            else
              self.result=false
              self.message=json["message"]
              self.id=order_id
          end
        else
          return nil
        end
    end
  end

end

class Order
  attr_accessor :amount,:price

  def initialize(price,amount)
    self.amount=amount.to_f
    self.price=price.to_f
  end
end

class Bid<Order

end

class Ask<Order

end

# class Strategy
#   attr_accessor :depth,:fee
#
#   def initialize(depth,fee)
#     unless depth.class==Depth
#       raise "wrong param"
#     end
#     self.depth=depth
#     self.fee=fee
#   end
#
#   def trade
#
#   end
# end

class Hash
  def to_depth
    depth=Depth.new
    if self.class==Hash
      bs=self["bids"]
      bs.each do |b|
        bid=Bid.new(b[0],b[1])
        depth.bids<<bid
      end
      as=self["asks"]
      as.each do |a|
        ask=Ask.new(a[0],a[1])
        depth.asks<<ask
      end
      return depth
    end
  end
end

class Array
  def to_depth
    depth=Depth.new
    unless self.class==Array
      raise 'wrong'
    end
    self.each do |item|

      if item["type"]=="1"
        bid=Bid.new(item["price"],item["amount"])
        depth.bids<<bid
      else
        ask=Ask.new(item["price"],item["amount"])
        depth.asks<<ask
      end
    end
    return depth
  end
end

# this class represents depth in any given market
# a depth instance has two attributes: bids is an array of bid, whereas asks is an array of ask
# bid and ask is a subclass of order, where there are two attributes: price and amount
class Depth
  attr_accessor :bids, :asks, :timestamp, :message, :market, :currency

  def initialize(market, currency, json)
    self.bids=[]
    self.asks=[]
    self.timestamp=Time.now.to_i
    self.market=market.to_s
    self.currency=currency
    begin
      json=JSON.parse json
      case market.to_s.downcase
        when 'btc38'
          bs=json["bids"]
          bs.each do |b|
            bid=Bid.new(b[0],b[1])
            self.bids<<bid
          end
          as=json["asks"]
          as.each do |a|
            ask=Ask.new(a[0],a[1])
            self.asks<<ask
          end

        when 'chbtc'
          bs=json["bids"]
          bs.each do |b|
            bid=Bid.new(b[0],b[1])
            self.bids<<bid
          end
          as=json["asks"]
          as.each do |a|
            ask=Ask.new(a[0],a[1])
            self.asks<<ask
          end
          self.asks.reverse!
        when 'okcoin'
          bs=json["bids"]
          bs.each do |b|
            bid=Bid.new(b[0],b[1])
            self.bids<<bid
          end
          as=json["asks"]
          as.each do |a|
            ask=Ask.new(a[0],a[1])
            self.asks<<ask
          end
          self.asks.reverse!
      end
    rescue
      self.message=json
    end
  end

  def -(other)
    size_of_bids=self.bids.to_a.size
    size_of_asks=self.asks.to_a.size
    unless other.class==Depth
      raise 'param type wrong'
    end

    other.bids.each do |bid|

      price=bid.price
      amount=bid.amount
      # self.bids.each do |bbiidd|
      #   if bbiidd.price==price
      #     bbiidd.amount-=amount
      #   end
      # end
      cnt=0
      while cnt<size_of_bids
        if self.bids[cnt].price==price
          self.bids[cnt].amount-=amount
        end
        cnt+=1
      end

    end

    other.asks.each do |ask|
      price=ask.price
      amount=ask.amount
      # self.asks.collect! do |item|
      #   if item.price==price
      #     item.amount-=amount
      #   end
      # end
      cnt=0
      while cnt<size_of_asks
        if self.asks[cnt].price==price
          self.asks[cnt].amount-=amount
        end
        cnt+=1
      end
    end
    return self
  end

  def absolute_mid_point
    (self.bids[0].price+self.asks[0].price)/2
  end

  def mid_point(ref='vol',distance=5,options={})

  end
end

# here is the Ticker Class
class Ticker
  attr_accessor :market, :currency, :timestamp, :high, :low, :last, :vol, :buy, :sell, :message

  def initialize(market, currency, json)
    begin
      json=JSON.parse json
      case market.to_s.downcase
        when 'btc38'
          self.market='Btc38'
          self.currency=currency.to_s
          ticker=json["ticker"]
          self.buy=ticker["buy"]
          self.sell=ticker["sell"]
          self.vol=ticker["vol"]
          self.high=ticker["high"]
          self.low=ticker["low"]
          self.last=ticker["last"]
          self.timestamp=Time.now.to_i
        when 'chbtc'
          self.market='Chbtc'
          self.currency=currency.to_s
          ticker=json["ticker"]
          self.buy=ticker["buy"]
          self.sell=ticker["sell"]
          self.vol=ticker["vol"]
          self.high=ticker["high"]
          self.low=ticker["low"]
          self.last=ticker["last"]
          self.timestamp=json["date"].to_i/1000
        when 'okcoin'
          self.market='OkCoin'
          self.currency=currency.to_s
          ticker=json["ticker"]
          self.buy=ticker["buy"]
          self.sell=ticker["sell"]
          self.vol=ticker["vol"]
          self.high=ticker["high"]
          self.low=ticker["low"]
          self.last=ticker["last"]
          self.timestamp=json["date"]
      end
    rescue
      #  for debugging
      self.message=json.to_s
    end

  end
end

# here is the TradeInfo Class
class TradeInfo
  attr_accessor :timestamp, :price, :amount, :type, :tid

  def initialize(timestamp, price, amount, type, tid)
    self.timestamp = timestamp
    self.amount = amount
    self.price = price
    self.type=type
    self.tid=tid
  end

end

class Trades
  attr_accessor :market, :currency, :trades

  def initialize(market, currency, json)
    json=JSON.parse(json)
    self.market=market.to_s
    self.currency=currency.to_s
    self.trades=[]
    case market.to_s.downcase
      when 'btc38'
        json.each do |item|
          if item["type"]=="buy"
            type=1
          else
            type=0
          end
          trade=TradeInfo.new(item["date"],item["price"],item["amount"],type,item["tid"])
          self.trades<<trade
        end
      when 'chbtc'
        json.each do |item|
          if item["type"]=="buy"
            type=1
          else
            type=0
          end
          trade=TradeInfo.new(item["date"],item["price"],item["amount"],type,item["tid"])
          self.trades<<trade
        end
      when 'okcoin'
        json.each do |item|
          if item["type"]=="buy"
            type=1
          else
            type=0
          end
          trade=TradeInfo.new(item["date"],item["price"],item["amount"],type,item["tid"])
          self.trades<<trade
        end
    end
  end
end

# here is the BalanceInfo Class
class BalanceInfo
  attr_accessor :timestamp, :market, :total_asset, :net_asset, :free_cny,:free_btc,:free_ltc,:free_btc,:free_bcc,:free_eth,:free_etc,:free_bts,:free_hsr, :free_eos,:frozen_cny,:frozen_btc,:frozen_ltc,:frozen_btc,:frozen_bcc,:frozen_eth,:frozen_etc,:frozen_bts,:frozen_hsr,:frozen_eos

  def initialize(market, json)
    self.timestamp=Time.now.to_i
    self.market=market
    begin
      json=JSON.parse json
      case market.to_s.downcase
        when "btc38"
          # do something
        when "chbtc"
          self.total_asset = json["result"]["totalAssets"]
          self.net_asset = json["result"]["netAssets"]
          self.free_bts = json["result"]["balance"]["BTS"]["amount"]
          self.free_bcc = json["result"]["balance"]["BCC"]["amount"]
          self.free_cny = json["result"]["balance"]["CNY"]["amount"]
          self.free_eth = json["result"]["balance"]["ETH"]["amount"]
          self.free_btc = json["result"]["balance"]["BTC"]["amount"]
          self.free_ltc = json["result"]["balance"]["LTC"]["amount"]
          self.free_eos = json["result"]["balance"]["EOS"]["amount"]
          self.free_etc = json["result"]["balance"]["ETC"]["amount"]
          self.free_hsr = json["result"]["balance"]["HSR"]["amount"]

          self.frozen_bts = json["result"]["frozen"]["BTS"]["amount"]
          self.frozen_bcc = json["result"]["frozen"]["BCC"]["amount"]
          self.frozen_cny = json["result"]["frozen"]["CNY"]["amount"]
          self.frozen_eth = json["result"]["frozen"]["ETH"]["amount"]
          self.frozen_btc = json["result"]["frozen"]["BTC"]["amount"]
          self.frozen_ltc = json["result"]["frozen"]["LTC"]["amount"]
          self.frozen_eos = json["result"]["frozen"]["EOS"]["amount"]
          self.frozen_etc = json["result"]["frozen"]["ETC"]["amount"]
          self.frozen_hsr = json["result"]["frozen"]["HSR"]["amount"]
        when "okcoin"
          self.total_asset = json["info"]["funds"]["asset"]["total"].to_f
          self.net_asset = json["info"]["funds"]["asset"]["net"].to_f
          self.free_bcc = json["info"]["funds"]["free"]["BCC"].to_f
          self.free_cny = json["info"]["funds"]["free"]["CNY"].to_f
          self.free_eth = json["info"]["funds"]["free"]["ETH"].to_f
          self.free_btc = json["info"]["funds"]["free"]["BTC"].to_f
          self.free_ltc = json["info"]["funds"]["free"]["LTC"].to_f
          self.free_etc = json["info"]["funds"]["free"]["ETC"].to_f

          self.frozen_bcc = json["info"]["funds"]["freezed"]["BCC"].to_f
          self.frozen_cny = json["info"]["funds"]["freezed"]["CNY"].to_f
          self.frozen_eth = json["info"]["funds"]["freezed"]["ETH"].to_f
          self.frozen_btc = json["info"]["funds"]["freezed"]["BTC"].to_f
          self.frozen_ltc = json["info"]["funds"]["freezed"]["LTC"].to_f
          self.frozen_etc = json["info"]["funds"]["freezed"]["ETC"].to_f
      end
    rescue
      return nil
    end

  end
end

# here is a module, which has a method to return the COMMON tradable coins among several markets
module Market

end




require 'rest-client'
require 'openssl'
require 'addressable/uri'
require 'json'

module Btc38
  class << self
    attr_accessor :configuration
  end

  def self.setup
    @configuration ||= Configuration.new
    yield( configuration )
  end

  class Configuration
    attr_accessor :key, :secret, :uid

    def intialize
      @key    = ''
      @secret = ''
      @uid = ''
    end
  end

  def self.ticker(c='btc', mk_type='cny')
    result=get 'ticker', c: c, mk_type: mk_type
    return result.body
  end

  def self.ordered_markets(order='desc')
    begin
      result=[]

      ticker=Btc38.ticker('all','cny')
      ticker=JSON.parse(ticker)
      ticker.each do |key,value|
        coin=key
        volume=0

        t=ticker[key]
        t.each do |k,v|
          volume=t[k]["vol"].to_f*t[k]["last"].to_f
        end
        hash={coin=>volume}
        result<<hash
      end
      case order
        when "desc"
          result.sort! do |a,b|
            a=a.to_h
            b=b.to_h
            key_of_a=a.keys[0]
            key_of_b=b.keys[0]
            a[key_of_a]<=>b[key_of_b]
          end
          result.reverse!
        when "asc"
          result.sort! do |a,b|
            a=a.to_h
            b=b.to_h
            key_of_a=a.keys[0]
            key_of_b=b.keys[0]
            a[key_of_a]<=>b[key_of_b]
          end

      end
      return result
      # rescue Exception=>e
      #   return e.message
    end

  end

  def self.get_top_n_objects(n=5)
    unless n.class==Fixnum
      raise "wrong param"
    end
    if n>=10
      n=10
    end
    if n<=0
      n=1
    end
    markets=Btc38.ordered_markets
    coins=[]
    for i in (1..n) do
      coins<<markets[i-1].to_h.keys[0]
    end
    return coins
  end

  def self.depth(c='btc', mk_type='cny')
    result=get 'depth', c: c, mk_type: mk_type
    return result.body
  end

  def self.trades(c='btc', mk_type='cny', options = {})
    result=get 'trades', options.merge({c: c, mk_type: mk_type})
    return result.body
  end

  def self.balances
    post 'getMyBalance'
  end

  def self.submit_order(type, mk_type='cny', price, amount, coinname)

    post 'submitOrder', type: type, mk_type: mk_type, price: price, amount: amount, coinname: coinname
  end

  def self.cancel_order(mk_type='cny',coinname='btc', order_id)
    post 'cancelOrder', mk_type: mk_type, order_id: order_id, coinname:coinname
  end

  def self.order_list(mk_type='cny', coinname='btc')
    result=post 'getOrderList', mk_type: mk_type, coinname: coinname
    return result.body
  end

  def self.trade_list(mk_type='cny', coinname='btc',page=1)
    post 'getMyTradeList', mk_type: mk_type, coinname: coinname,page:page
  end

  protected

  def self.resource
    @@resouce ||= RestClient::Resource.new( 'http://api.btc38.com' )
  end

  def self.get( command, params = {} )
    params[:command] = command
    resource[ "v1/#{command}.php" ].get params: params, "User-Agent" => "curl/7.35.0"
  end

  def self.post( command, params = {} )
    resource[ "v1/#{command}.php" ].post params.merge(create_sign), { "User-Agent" => "curl/7.35.0" }
  end

  def self.create_sign
    time = Time.now.to_i
    mdt = "#{configuration.key}_#{configuration.uid}_#{configuration.secret}_#{time}"
    {key: configuration.key, time: time, md5: Digest::MD5.hexdigest(mdt)}
  end
end

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

      if item["type"]==1
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
  attr_accessor :bids,:asks
  def initialize()
    self.bids=[]
    self.asks=[]
  end

  def -(other)
    unless other.class==Depth
      raise 'param type wrong'
    end

    other.bids.each do |bid|
      price=bid.price
      amount=bid.amount
      self.bids.each do |bbiidd|
        if bbiidd.price==price
          bbiidd.amount-=amount
        end
      end
    end

    other.asks.each do |ask|
      price=ask.price
      amount=ask.amount
      self.asks.each do |aasskk|
        if aasskk.price==price
          aasskk.amount-=amount
        end
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

class Strategy
  attr_accessor :depth,:fee

  def initialize(depth,fee)
    unless depth.class==Depth
      raise "wrong param"
    end
    self.depth=depth
    self.fee=fee
  end

  def trade

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



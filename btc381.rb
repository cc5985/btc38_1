require 'rest-client'
require 'openssl'
require 'addressable/uri'
require 'json'
require_relative 'universal'

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
    result=Ticker.new("Btc38",c.to_s+'_'+mk_type.to_s, result.body)
    return result
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
    depth=Depth.new("btc38", c.to_s+'_'+mk_type.to_s,result)
  end

  def self.trades(c='btc', mk_type='cny', options = {})
    result=get 'trades', options.merge({c: c, mk_type: mk_type})
    result=Trades.new('btc38',c.to_s+'_'+mk_type.to_s, result)
    # return result.body
  end

  def self.balances
    begin
      return post 'getMyBalance'
    rescue Exception=>e
      return e
    end

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





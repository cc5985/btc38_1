require 'rest-client'
require 'openssl'
require 'addressable/uri'

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
    get 'ticker', c: c, mk_type: mk_type
  end

  def self.depth(c='btc', mk_type='cny')
    get 'depth', c: c, mk_type: mk_type
  end

  def self.trades(c='btc', mk_type='cny', options = {})
    get 'trades', options.merge({c: c, mk_type: mk_type})
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

  def self.order_list(mk_type='cny', coinname)
    post 'getOrderList', mk_type: mk_type, coinname: coinname
  end

  def self.trade_list(mk_type='cny', coinname)
    post 'getMyTradeList', mk_type: mk_type, coinname: coinname
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

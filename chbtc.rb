require 'rest-client'
require 'openssl'
require 'addressable/uri'
require 'json'
require 'digest/sha1'
require_relative 'universal'
require_relative 'strategy'
module Chbtc
  # OkCoin now supports btc, ltc, eth, etc, bcc
  #
  class << self
    include Strategy
    attr_accessor :configuration
  end

  def self.setup
    @configuration ||= Configuration.new
    yield( configuration )
  end

  class Configuration
    attr_accessor :key, :secret

    def intialize
      @key    = ''
      @secret = ''
    end
  end


  # the allowed coin contains: btc ltc eth etc bts eos bcc qtum hsr, default is btc
  def self.ticker(c='btc', mk_type='cny')
    result=get 'ticker', currency: c.to_s+'_'+mk_type.to_s
    result=Ticker.new("Chbtc",c.to_s+'_'+mk_type.to_s, result.body)
    return result
  end

  def self.ordered_markets(order='desc')
    begin
      result=[]

      ticker=OkCoin.ticker('all','cny')
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

  def self.depth(c='btc', mk_type='cny', size=100)
    result=get 'depth', currency: c.to_s+'_'+mk_type.to_s, size:size
    depth=Depth.new("Chbtc", c.to_s+'_'+mk_type.to_s,result)

    # begin
    #   depth=Depth.new
    #   depth.timestamp=result["timestamp"]
    #   bs=result["bids"]
    #   bs.each do |b|
    #     bid=Bid.new(b[0],b[1])
    #     depth.bids<<bid
    #   end
    #   as=result["asks"]
    #   as.each do |a|
    #     ask=Ask.new(a[0],a[1])
    #     depth.asks<<ask
    #   end
    #   depth.asks.reverse!
    #   return depth
    # rescue
    #   return nil
    # end

  end

  def self.trades(c='btc', mk_type='cny',since=0)
    if since==0
      result=get 'trades', currency: c.to_s+'_'+mk_type.to_s
    else
      result=get 'trades', currency: c.to_s+'_'+mk_type.to_s,since:since
    end

    result=Trades.new('Chbtc',c.to_s+'_'+mk_type.to_s, result)
  end

  def self.balances
    params={method:"getAccountInfo", accesskey: configuration.key}
    json=post 'getAccountInfo', params
    result=BalanceInfo.new("Chbtc",json)
  end

  def self.submit_order(type="buy", mk_type='cny',coin_name='btc', price, amount)
    if type==1 or type.to_s.downcase=="buy"
      type=1
    else
      type=0
    end
    params={method:"order",accesskey: configuration.key,  price: price, amount: amount, tradeType: type,currency: coin_name.to_s + "_" + mk_type.to_s }
    json=post 'order', params
    json=JSON.parse json
    currency=coin_name.to_s + "_" + mk_type.to_s
    order_id=nil
    if json["code"]
      case json["code"]
        when 1000
          order_id=json["id"]
          result=SubmittedOrder.new(coin_name.to_s + "_" + mk_type.to_s,order_id,price,nil,amount,nil,nil,nil,nil,type)
        when 1001
          "一般错误"
        when 1002
          "内部错误"
        when 1003
          "验证不通过"
        when 2001
          "人民币账户余额不足"
        when 2002
          "比特币账户余额不足"
        when 2003
          "莱特币账户余额不足"
        when 2004
          "一般错误"
        when 2005
          "以太币账户余额不足"
        when 2006
          "ETC币账户余额不足"
        when 2007
          "BTS币账户余额不足"
        when 2008
          "EOS币账户余额不足"
        when 2009
          "账户余额不足"
        when 3001
          "挂单没有找到"
        when 3002
          "无效的金额"
        when 3003
          "无效的数量"
        when 4002
          "请求过于频繁"
      end



    else
      "未知错误"
    end
    # currency, id, price, status, total_amount, trade_amount, trade_date, trade_money, trade_price, type

  end

  def self.cancel_order(mk_type='cny',coinname='btc', order_id)
    params={method:"cancelOrder",accesskey: configuration.key, id: order_id.to_s, currency: coinname.to_s + "_" + mk_type.to_s  }
    json=post 'cancelOrder', params
    CancelOrderResult.new("Chbtc",coinname.to_s + "_" + mk_type.to_s,json,order_id)
  end

  # order_list这个方法是取得未成交订单的列表！
  # order_list 方法应该返回一个sumitted_order类型的数组
  def self.order_list(mk_type='cny', coinname='btc')
    params={method:"getOrdersIgnoreTradeType", accesskey: configuration.key, currency: coinname.to_s + "_" + mk_type.to_s, pageIndex:1, pageSize:100 }
    result=post 'getOrdersIgnoreTradeType', params
    result=JSON.parse result.body
    # p result
    submitted_orders=[]
    begin
      if result.class==Hash && result["code"] && result["code"].to_s=="3001"
        return submitted_orders
      end
      result.each do |item|
        case item["status"].to_i
          when 0  # pending
            order=SubmittedOrder.new(item["currency"],item["id"],item["price"],item["status"],item["total_amount"],item["trade_amount"],item["trade_date"],item["trade_money"],item["trade_price"],item["type"])
            submitted_orders<<order
          when 1  # canceled
            # do nothing
          when 2  # done
            # do nothing
          when 3  # patially done
            order=SubmittedOrder.new(item["currency"],item["id"],item["price"],item["status"],item["total_amount"],item["trade_amount"],item["trade_date"],item["trade_money"],item["trade_price"],item["type"])
            submitted_orders<<order
          else  # error
            raise
        end
      end
    rescue Exception=>e
      p e.message
      return e.message
    end
    return submitted_orders
  end

  # trade_list这个方法是取得已成交订单的列表！
  def self.trade_list(mk_type='cny', coinname='btc',current_page=1,page_length=200)
    params={method:"getOrdersIgnoreTradeType", accesskey: configuration.key, currency: coinname.to_s + "_" + mk_type.to_s, pageIndex:1, pageSize:100 }
    result=post 'getOrdersIgnoreTradeType', params
    result=JSON.parse result.body

    submitted_orders=[]
    begin
      result.each do |item|

        case item["status"].to_i
          when 0  # pending

          when 1  # canceled
            # do nothing
          when 2  # done
            # :currency, :id, :price, :status, :total_amount, :trade_amount, :trade_date, :trade_money, :trade_price, :type

            order=SubmittedOrder.new(item["currency"],item["id"],item["price"],item["status"],item["total_amount"],item["trade_amount"],item["trade_date"],item["trade_money"],item["trade_price"],item["type"])
            submitted_orders<<order
          when 3  # patially done

            order=SubmittedOrder.new(item["currency"],item["id"],item["price"],item["status"],item["total_amount"],item["trade_amount"],item["trade_date"],item["trade_money"],item["trade_price"],item["type"])
            submitted_orders<<order
          else  # error
            raise
        end
      end
    rescue
      return nil
    end
    return submitted_orders
  end

  # 以下是独享的方法
  # batch_trade
  def self.batch_trade(mk_type='cny',coinname='btc',type="buy", orders_data='')
    # here is an example of the ORDERS_DATA field: [{price:3,amount:5,type:'sell'},{price:3,amount:3,type:'buy'}] )
    # which looks like an array containing several hashes, but actually it's a string!!!!
    #
    params={api_key: configuration.key, symbol: coinname.to_s + "_" + mk_type.to_s, type:type, orders_data:orders_data }
    result=post 'batch_trade', params
    return result.body
  end


  protected

  def self.resource_of_get
    @@resouce ||= RestClient::Resource.new('http://api.chbtc.com/data')

    #   http://api.chbtc.com/data
    #   https://trade.chbtc.com/api/order
  end

  def self.resource_of_post
    @@resouce ||= RestClient::Resource.new('https://trade.chbtc.com/api')

    #   http://api.chbtc.com/data
    #   https://trade.chbtc.com/api/order
  end

  def self.get( command, params = {} )
    params[:command] = command
    resource_of_get[ "v1/#{command}" ].get params: params, "User-Agent" => "curl/7.35.0"
  end

  def self.post( command, params = {} )
    # resource[ "v1/#{command}.do" ].post params.merge(create_sign), { "User-Agent" => "curl/7.35.0" }
    secret=digest
    sign=create_sign(params)
    params[:sign]= sign
    params[:reqTime]=Time.now.to_i*1000
    data=create_link_str(params,false)
    data="https://trade.chbtc.com/api/"+command+"?"+data
    url=RestClient::Resource.new(data)
    r=url.get()
    return r

  end

  def self.create_sign(params)
    secret=digest
    sign=""
    prestr=create_link_str(params,true)
    # prestr += "&secret_key=" + secret
    digest=OpenSSL::Digest.new("md5")
    sign=OpenSSL::HMAC.hexdigest(digest,secret,prestr)
    return sign

    # time = Time.now.to_i
    # mdt = "#{configuration.key}_#{configuration.uid}_#{configuration.secret}_#{time}"
    # {key: configuration.key, time: time, md5: Digest::MD5.hexdigest(mdt)}


  end

  def self.create_link_str(params,ordered)
    p={}
    # params=params.sort {|a,b| a[0].to_s<=>b[0].to_s}
    if ordered==true
      params.each do |arr|
        p[arr[0]]=arr[1]
      end
      params=p
    end


    prestr=""

    count=params.length
    i=0
    params.each do |k,v|
      if i==count-1
        prestr += k.to_s + "=" + v.to_s
      else
        prestr += k.to_s + "=" + v.to_s + "&"
      end
      i+=1
    end
    return prestr
  end

  def self.digest()
    value=configuration.secret.to_s.strip
    r=Digest::SHA1.hexdigest(value)
    return r
  end
end

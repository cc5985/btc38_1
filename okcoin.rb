require 'rest-client'
require 'openssl'
require 'addressable/uri'
require 'json'
require_relative 'universal'



module OkCoin
  # OkCoin now supports btc, ltc, eth, etc, bcc
  #
  class << self
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


  def self.ticker(c='btc', mk_type='usdt')
    result=get 'ticker', symbol: c.to_s+'_'+mk_type.to_s
    p result
    result=Ticker.new("OkCoin",c.to_s+'_'+mk_type.to_s, result.body)
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

  def self.depth(c='btc', mk_type='usdt')
    result=get 'depth', symbol: c.to_s+'_'+mk_type.to_s

    depth=Depth.new("okcoin", c.to_s+'_'+mk_type.to_s,result)
  end

  def self.trades(c='btc', mk_type='usdt')
    result=get 'trades', symbol: c.to_s+'_'+mk_type.to_s
    result=Trades.new('OkCoin',c.to_s+'_'+mk_type.to_s, result)
  end

  def self.balances
    params={api_key: configuration.key}
    json=post 'userinfo', params
    pp json.body
    result=BalanceInfo.new("okcoin",json)
  end

  def self.submit_order(type="buy", mk_type='cny',coin_name='btc', price, amount)
    if type==1 or type.to_s.downcase=="buy"
      type="buy"
    else
      type="sell"
    end
    params={api_key: configuration.key, symbol: coin_name.to_s + "_" + mk_type.to_s, type: type, price: price, amount: amount }

    json=post 'trade', params
    json=JSON.parse json
    currency=coin_name.to_s + "_" + mk_type.to_s
    order_id=nil
    if json["result"]
      order_id=json["order_id"]
      result=SubmittedOrder.new(coin_name.to_s + "_" + mk_type.to_s,order_id,price,nil,amount,nil,nil,nil,nil,type)
    elsif json["error_code"]
      case json["error_code"].to_s
        when "10000";"必选参数不能为空"
        when "10001";"请求过于频繁，请降低访问频次"
        when "10002";"系统错误"
        when "10004";"此IP不在访问白名单内"
        when "10005";"SecretKey不存在"
        when "10006";"Api_key不存在"
        when "10007";"签名不匹配"
        when "10008";"非法参数"
        when "10009";"订单不存在"
        when "10010";"余额不足"
        when "10011";"买卖的数量小于BTC/LTC最小买卖额度"
        when "10012";"当前网站暂时只支持btc_cny ltc_cny"
        when "10013";"此接口只支持https请求"
        when "10014";"下单价格不得≤0或≥1000000"
        when "10015";"下单价格与最新成交价偏差过大"
        when "10016";"币数量不足"
        when "10017";"API鉴权失败"
        when "10018";"借入不能小于最低限额[cny:100,btc:0.1,ltc:1]"
        when "10019";"页面没有同意借贷协议"
        when "10020";"费率不能大于1%"
        when "10021";"费率不能小于0.01%"
        when "10023";"获取最新成交价错误"
        when "10024";"可借金额不足"
        when "10025";"额度已满，暂时无法借款"
        when "10026";"借款(含预约借款)及保证金部分不能提出"
        when "10027";"修改敏感提币验证信息，24小时内不允许提现"
        when "10028";"提币金额已超过今日提币限额"
        when "10029";"账户有借款，请撤消借款或者还清借款后提币"
        when "10031";"存在BTC/LTC充值，该部分等值金额需6个网络确认后方能提出"
        when "10032";"未绑定手机或谷歌验证"
        when "10033";"服务费大于最大网络手续费"
        when "10034";"服务费小于最低网络手续费"
        when "10035";"可用BTC/LTC不足"
        when "10036";"提币数量小于最小提币数量"
        when "10037";"交易密码未设置"
        when "10040";"取消提币失败"
        when "10041";"提币地址不存在或者未认证"
        when "10042";"交易密码错误"
        when "10043";"合约权益错误，提币失败"
        when "10044";"取消借款失败"
        when "10047";"当前为子账户，此功能未开放"
        when "10048";"提币信息不存在"
        when "10049";"小额委托（<0.15BTC)的未成交委托数量不得大于50个"
        when "10050";"重复撤单"
        when "10052";"提币受限"
        when "10100";"账户被冻结"
        when "10101";"订单类型错误"
        when "10102";"不是本用户的订单"
        when "10103";"私密订单密钥错误"
        when "10216";"非开放API"
        when "1002";"交易金额大于余额"
        when "1003";"交易金额小于最小交易值"
        when "1004";"交易金额小于0"
        when "1007";"没有交易市场信息"
        when "1008";"没有最新行情信息"
        when "1009";"没有订单"
        when "1010";"撤销订单与原订单用户不一致"
        when "1011";"没有查询到该用户"
        when "1013";"没有订单类型"
        when "1014";"没有登录"
        when "1015";"没有获取到行情深度信息"
        when "1017";"日期参数错误"
        when "1018";"下单失败"
        when "1019";"撤销订单失败"
        when "1024";"币种不存在"
        when "1025";"没有K线类型"
        when "1026";"没有基准币数量"
        when "1027";"参数不合法可能超出限制"
        when "1028";"保留小数位失败"
        when "1029";"正在准备中"
        when "1030";"有融资融币无法进行交易"
        when "1031";"转账余额不足"
        when "1032";"该币种不能转账"
        when "1035";"密码不合法"
        when "1036";"谷歌验证码不合法"
        when "1037";"谷歌验证码不正确"
        when "1038";"谷歌验证码重复使用"
        when "1039";"短信验证码输错限制"
        when "1040";"短信验证码不合法"
        when "1041";"短信验证码不正确"
        when "1042";"谷歌验证码输错限制"
        when "1043";"登陆密码不允许与交易密码一致"
        when "1044";"原密码错误"
        when "1045";"未设置二次验证"
        when "1046";"原密码未输入"
        when "1048";"用户被冻结"
        when "1201";"账号零时删除"
        when "1202";"账号不存在"
        when "1203";"转账金额大于余额"
        when "1204";"不同种币种不能转账"
        when "1205";"账号不存在主从关系"
        when "1206";"提现用户被冻结"
        when "1207";"不支持转账"
        when "1208";"没有该转账用户"
        when "1209";"当前api不可用"
        when "HTTP错误码403";"用户请求过快，IP被屏蔽"
        when "Ping不通";"用户请求过快，IP被屏蔽"
      end
    else
      return nil
    end
    # currency, id, price, status, total_amount, trade_amount, trade_date, trade_money, trade_price, type

  end

  def self.cancel_order(mk_type='usdt',coinname='btc', order_id)
    params={api_key: configuration.key, symbol: coinname.to_s + "_" + mk_type.to_s, order_id: order_id.to_s }
    json=post 'cancel_order', params
    CancelOrderResult.new("OkCoin",coinname.to_s + "_" + mk_type.to_s,json,order_id)
  end

  # order_list这个方法是取得未成交订单的列表！
  def self.order_list(mk_type='cny', coinname='btc',current_page=1,page_length=200)
    params={api_key: configuration.key, symbol: coinname.to_s + "_" + mk_type.to_s, status:0, current_page:current_page, page_length:page_length }
    result=post 'order_history', params
    return result.body
  end

  # trade_list这个方法是取得已成交订单的列表！
  def self.trade_list(mk_type='cny', coinname='btc',current_page=1,page_length=200)
    params={api_key: configuration.key, symbol: coinname.to_s + "_" + mk_type.to_s, status:1, current_page:current_page, page_length:page_length }
    result=post 'order_history', params
    return result.body
  end

  # 以下是独享的方法
  # batch_trade
  def self.batch_trade(mk_type='cny',coinname='btc',type="buy", orders_data='')
    # here is an example of the ORDERS_DATA field: [{price:3,amount:5,type:'sell'},{price:3,amount:3,type:'buy'}] )
    # which looks like an array containing several hashes, but actually it's a string!!!!
    params={api_key: configuration.key, symbol: coinname.to_s + "_" + mk_type.to_s, type:type, orders_data:orders_data }
    result=post 'batch_trade', params
    return result.body
  end


  protected

  def self.resource
    @@resouce ||= RestClient::Resource.new( 'https://www.okex.com/api/')
  end

  def self.get( command, params = {} )
    params[:command] = command
    resource[ "v1/#{command}.do" ].get params: params, "User-Agent" => "curl/7.35.0"
  end

  def self.post( command, params = {} )
    # resource[ "v1/#{command}.do" ].post params.merge(create_sign), { "User-Agent" => "curl/7.35.0" }
    url=resource["v1/#{command}.do"]
    sign=create_sign(params)
    params[:sign]= sign
    url.post(params, { "User-Agent" => "curl/7.35.0" })

  end

  def self.create_sign(params)
    secret=configuration.secret
    sign=""
    prestr=create_link_str(params)
    prestr += "&secret_key=" + secret
    sign=Digest::MD5.hexdigest(prestr).upcase!
    return sign

    # time = Time.now.to_i
    # mdt = "#{configuration.key}_#{configuration.uid}_#{configuration.secret}_#{time}"
    # {key: configuration.key, time: time, md5: Digest::MD5.hexdigest(mdt)}


  end

  def self.create_link_str(params)
    p={}
    params=params.sort {|a,b| a[0].to_s<=>b[0].to_s}
    params.each do |arr|
      p[arr[0]]=arr[1]
    end
    params=p
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
end

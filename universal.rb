Error_code_for_okcoin=
{10000=>'必选参数不能为空',
 10001=>'用户请求频率过快，超过该接口允许的限额',
 10002=>'系统错误',
 10004=>'请求失败',
 10005=>'SecretKey不存在',
 10006=>'Api_key不存在',
 10007=>'签名不匹配',
 10008=>'非法参数',
 10009=>'订单不存在',
 10010=>'余额不足',
 10011=>'买卖的数量小于BTC/LTC最小买卖额度',
 10012=>'当前网站暂时只支持btc_usd ltc_usd',
 10013=>'此接口只支持https请求',
 10014=>'下单价格不得≤0或≥1000000',
 10015=>'下单价格与最新成交价偏差过大',
 10016=>'币数量不足',
 10017=>'API鉴权失败',
 10018=>'借入不能小于最低限额[usd:100,btc:0.1,ltc:1]',
 10019=>'页面没有同意借贷协议',
 10020=>'费率不能大于1%',
 10021=>'费率不能小于0.01%',
 10023=>'获取最新成交价错误',
 10024=>'可借金额不足',
 10025=>'额度已满，暂时无法借款',
 10026=>'借款(含预约借款)及保证金部分不能提出',
 10027=>'修改敏感提币验证信息，24小时内不允许提现',
 10028=>'提币金额已超过今日提币限额',
 10029=>'账户有借款，请撤消借款或者还清借款后提币',
 10031=>'存在BTC/LTC充值，该部分等值金额需6个网络确认后方能提出',
 10032=>'未绑定手机或谷歌验证',
 10033=>'服务费大于最大网络手续费',
 10034=>'服务费小于最低网络手续费',
 10035=>'可用BTC/LTC不足',
 10036=>'提币数量小于最小提币数量',
 10037=>'交易密码未设置',
 10040=>'取消提币失败',
 10041=>'提币地址不存在或未认证',
 10042=>'交易密码错误',
 10043=>'合约权益错误，提币失败',
 10044=>'取消借款失败',
 10047=>'当前为子账户，此功能未开放',
 10048=>'提币信息不存在',
 10049=>'小额委托（<0.15BTC)的未成交委托数量不得大于50个',
 10050=>'重复撤单',
 10052=>'提币受限',
 10064=>'美元充值后的48小时内，该部分资产不能提出',
 10100=>'账户被冻结',
 10101=>'订单类型错误',
 10102=>'不是本用户的订单',
 10103=>'私密订单密钥错误',
 10216=>'非开放API',
 1002=>'交易金额大于余额',
 1003=>'交易金额小于最小交易值',
 1004=>'交易金额小于0',
 1007=>'没有交易市场信息',
 1008=>'没有最新行情信息',
 1009=>'没有订单',
 1010=>'撤销订单与原订单用户不一致',
 1011=>'没有查询到该用户',
 1013=>'没有订单类型',
 1014=>'没有登录',
 1015=>'没有获取到行情深度信息',
 1017=>'日期参数错误',
 1018=>'下单失败',
 1019=>'撤销订单失败',
 1024=>'币种不存在',
 1025=>'没有K线类型',
 1026=>'没有基准币数量',
 1027=>'参数不合法可能超出限制',
 1028=>'保留小数位失败',
 1029=>'正在准备中',
 1030=>'有融资融币无法进行交易',
 1031=>'转账余额不足',
 1032=>'该币种不能转账',
 1035=>'密码不合法',
 1036=>'谷歌验证码不合法',
 1037=>'谷歌验证码不正确',
 1038=>'谷歌验证码重复使用',
 1039=>'短信验证码输错限制',
 1040=>'短信验证码不合法',
 1041=>'短信验证码不正确',
 1042=>'谷歌验证码输错限制',
 1043=>'登陆密码不允许与交易密码一致',
 1044=>'原密码错误',
 1045=>'未设置二次验证',
 1046=>'原密码未输入',
 1048=>'用户被冻结',
 1201=>'账号零时删除',
 1202=>'账号不存在',
 1203=>'转账金额大于余额',
 1204=>'不同种币种不能转账',
 1205=>'账号不存在主从关系',
 1206=>'提现用户被冻结',
 1207=>'不支持转账',
 1208=>'没有该转账用户',
 1209=>'当前api不可用',
 1216=>'市价交易暂停，请选择限价交易',
 1217=>'您的委托价格超过最新成交价的±5%，存在风险，请重新下单',
 1218=>'下单失败，请稍后再试'
}

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
          end
        else
          self.result=false
          self.message=Error_code_for_okcoin[json["error_code"]]
          self.id=order_id
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
  attr_accessor :timestamp, :market, :total_asset, :net_asset, :free_cny,:free_btc,:frozen_btc,:free_ltc,:free_bcc,:free_eth,:free_etc,:free_bts,:free_hsr,
                :free_eos,:frozen_cny,:frozen_ltc,:frozen_bcc,:frozen_eth,:frozen_etc,:frozen_bts,:frozen_hsr,:frozen_eos,
                :free_usdt, :frozen_usdt, :free_bch, :frozen_bch, :free_btg, :frozen_btg, :free_gas , :frozen_gas, :free_zec , :frozen_zec, :free_neo , :frozen_neo, 
                :free_iota , :frozen_iota, :free_gnt , :frozen_gnt, :free_snt , :frozen_snt, :free_dash , :frozen_dash , :free_xuc , :frozen_xuc, :free_qtum , :frozen_qtum,
                :free_omg , :frozen_omg,
                :message


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
          self.free_usdt = json["info"]["funds"]["free"]["USDT"].to_f
          self.free_eth = json["info"]["funds"]["free"]["ETH"].to_f
          self.free_btc = json["info"]["funds"]["free"]["BTC"].to_f
          self.free_ltc = json["info"]["funds"]["free"]["LTC"].to_f
          self.free_etc = json["info"]["funds"]["free"]["ETC"].to_f
          self.free_hsr = json["info"]["funds"]["free"]["HSR"].to_f
          self.free_bch = json["info"]["funds"]["free"]["BCH"].to_f
          self.free_btg = json["info"]["funds"]["free"]["BTG"].to_f
          self.free_gas = json["info"]["funds"]["free"]["GAS"].to_f
          self.free_zec = json["info"]["funds"]["free"]["ZEC"].to_f
          self.free_neo = json["info"]["funds"]["free"]["NEO"].to_f
          self.free_iota = json["info"]["funds"]["free"]["IOTA"].to_f
          self.free_snt = json["info"]["funds"]["free"]["SNT"].to_f
          self.free_gnt = json["info"]["funds"]["free"]["GNT"].to_f
          self.free_dash = json["info"]["funds"]["free"]["DASH"].to_f
          self.free_xuc = json["info"]["funds"]["free"]["XUC"].to_f
          self.free_eos = json["info"]["funds"]["free"]["EOS"].to_f
          self.free_qtum = json["info"]["funds"]["free"]["QTUM"].to_f
          self.free_omg = json["info"]["funds"]["free"]["OMG"].to_f

          self.frozen_usdt = json["info"]["funds"]["freezed"]["USDT"].to_f
          self.frozen_eth = json["info"]["funds"]["freezed"]["ETH"].to_f
          self.frozen_btc = json["info"]["funds"]["freezed"]["BTC"].to_f
          self.frozen_ltc = json["info"]["funds"]["freezed"]["LTC"].to_f
          self.frozen_etc = json["info"]["funds"]["freezed"]["ETC"].to_f
          self.frozen_hsr = json["info"]["funds"]["freezed"]["HSR"].to_f
          self.frozen_bch = json["info"]["funds"]["freezed"]["BCH"].to_f
          self.frozen_btg = json["info"]["funds"]["freezed"]["BTG"].to_f
          self.frozen_gas = json["info"]["funds"]["freezed"]["GAS"].to_f
          self.frozen_zec = json["info"]["funds"]["freezed"]["ZEC"].to_f
          self.frozen_neo = json["info"]["funds"]["freezed"]["NEO"].to_f
          self.frozen_iota = json["info"]["funds"]["freezed"]["IOTA"].to_f
          self.frozen_snt = json["info"]["funds"]["freezed"]["SNT"].to_f
          self.frozen_gnt = json["info"]["funds"]["freezed"]["GNT"].to_f
          self.frozen_dash = json["info"]["funds"]["freezed"]["DASH"].to_f
          self.frozen_xuc = json["info"]["funds"]["freezed"]["XUC"].to_f
          self.frozen_eos = json["info"]["funds"]["freezed"]["EOS"].to_f
          self.frozen_qtum = json["info"]["funds"]["freezed"]["QTUM"].to_f
          self.frozen_omg = json["info"]["funds"]["freezed"]["OMG"].to_f

          # self.total_asset = json["info"]["funds"]["free"]["total"].to_f
          # self.net_asset = json["info"]["funds"]["asset"]["net"].to_f
      end
    rescue Exception=>e
      p e.message
    end

  end
end

# here is a module, which has a method to return the COMMON tradable coins among several markets
module Market

end




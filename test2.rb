#coding=utf-8

require_relative 'helper'
# require_relative 'btc381'
require_relative 'chbtc'
require_relative 'okcoin'
require_relative 'btc381'
require 'json'
require 'rufus-scheduler'
require 'pp'
# scheduler=Rufus::Scheduler.new
#
# scheduler.every '1s' do
#   p Time.new
# end
# test "test configuration of BTC38" do
#   Btc38.setup do |config|
#     config.key="3b6f724d97da434fba4344c8bf6c2d80"
#     config.secret = 'f742a88714ec4edd6f35180c9bb7cdeb923c6ea8eaee27d4e61c5c4dee1088b9'
#     config.uid = '94238'
#   end
# end

test "test configuration of Chbtc" do
  Chbtc.setup do |config|
    config.key="368f6909-9838-4cca-99bc-5fc4b6795c06"
    config.secret = 'b23f7614-fe89-48e1-af95-3eedf8eff988'
  end
end

test "test configure of OkCoin" do
  OkCoin.setup do |config|
    config.key="efa84830-1949-4a4b-8df8-2cfe843d0d86"
    config.secret = '2C69B58CB805D6AFA40105EC1D7DD5A4'
  end
end

# test "get ticker" do
#   p "btc38:"
#   r=Btc38.ticker
#   p r
#   p "Chbtc:"
#   r=Chbtc.ticker
#   p r
#   p "OkCoin:"
#   r=OkCoin.ticker
#   p r
# end

# test "get depth" do
#   p "btc38:"
#   r=Btc38.depth
#   pp r
#   p "Chbtc:"
#   r=Chbtc.depth
#   pp r
#   p "OkCoin:"
#   r=OkCoin.depth
#   pp r
# end

# test "get trades" do
#   p "btc38:"
#   r=Btc38.trades
#   pp r
#   p "Chbtc:"
#   r=Chbtc.trades
#   pp r
#   p "OkCoin:"
#   r=OkCoin.trades
#   pp r
# end

# test "get balances" do
#   # p "btc38:"
#   # r=Btc38.balances
#   # pp r
#   p "Chbtc:"
#   r=Chbtc.balances
#   pp r
#   p "OkCoin:"
#   r=OkCoin.balances
#   pp r
# end

# test "get submitted order" do
#   # we submit an order, and hope to get its return
#     p "Chbtc:"
#     r=Chbtc.submit_order("buy","cny","etc",1,1)
#     pp r
#     p "OkCoin:"
#     r=OkCoin.submit_order("buy","cny","etc",1,1)
#     pp r
# end


# test "get cancel an existing order" do
#   # OkCoin does not return corresponding message if an error occurred....
#   p "Chbtc:"
#   r=Chbtc.cancel_order("cny","etc",2017090844873509)
#   pp r
#   p "OkCoin:"
#   r=OkCoin.cancel_order("cny","etc",2645977)
#   pp r
# end

# test "test mix-in functionality" do
#   depth=Chbtc.depth("etc","cny")
#   pp depth
#   Strategy.make_an_order(depth,"chbtc","etc_cny")
# end

test "实盘测试！请注意！" do



  cnt=0
  submitted_orders=[]  #已经提交的订单列表
  while true
    # 查询残余订单
    previous_orders=Chbtc.order_list("cny","etc")
    p previous_orders
    # 取消一切残余订单
    previous_orders.each do |o|
      Chbtc.cancel_order('cny','etc', o.id)
    end

    depth=Chbtc.depth("etc","cny")
    target_orders=Strategy.make_an_order(depth,"chbtc","etc",1,4500)
    p target_orders
    # params submit_order should post
    # type="buy", mk_type='cny',coin_name='btc', price, amount
    target_buy= target_orders[:buy]
    target_sell=target_orders[:sell]
    b=Chbtc.submit_order(target_buy[0],target_buy[1],target_buy[2],target_buy[3],target_buy[4])
    s=Chbtc.submit_order(target_sell[0],target_sell[1],target_sell[2],target_sell[3],target_sell[4])
    puts [b,s,cnt]
    cnt+=1
    sleep 5
  end
end


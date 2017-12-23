require_relative 'helper'
require_relative 'okcoin'
require 'json'
require 'rufus-scheduler'
require 'pp'
# scheduler=Rufus::Scheduler.new
#
# scheduler.every '1s' do
#   p Time.new
# end

test "test configure" do
  OkCoin.setup do |config|
    config.key="cbdcb009-ae22-4abe-81b7-76ec5c94d858"
    config.secret = '330DB5E9F2D49E00455FFF19F63DECB6'
  end
end

# following are unit tests:

test "test ticker in okcoin" do
  r=OkCoin.ticker()
  p r
end

# test "test depth in okcoin" do
#   r=OkCoin.depth()
#   p r
# end
#
# test "test trades in okcoin" do
#   r=OkCoin.trades()
#   p r
# end
#
#
#
# test "test userinfo" do
#   r=OkCoin.balances
#   puts r.frozen_usdt
# end

# test "test submit order aka: trade in okcoin" do
#   r=OkCoin.submit_order("buy","usdt","btc",1,100)
#   puts r
# end

# test "test cancel order in okcoin which the order id is 9015822394" do
#   r=OkCoin.cancel_order(9015822394)
#   puts r.message
# end

test "test order list in okcoin" do
  r=OkCoin.order_list()
  puts r
end

# test "test order list in okcoin" do
#   r=OkCoin.trade_list()
#   puts r
# end

# test "test batch_trade in okcoin" do
#   r=OkCoin.batch_trade('cny','btc','buy',"[{price:3,amount:5,type:'buy'},{price:1,amount:3,type:'buy'}]")
#   p r
# end



# test "test ticker in chbtc" do
#   coins=%w(btc ltc eth bts bcc)
#   coins.each do |coin|
#     r=Chbtc.ticker(coin)
#     puts r
#   end
# end

# test "test depth in chbtc" do
#   coins=%w(btc)
#   coins.each do |coin|
#     r=Chbtc.depth(coin)
#     p r.timestamp
#     r.asks.each do |b|
#       p b
#     end
#   end
# end

# test "test trades in chbtc" do
#   coins=%w(btc)
#   coins.each do |coin|
#     r=Chbtc.trades(coin)
#     puts r
#   end
# end

# test "test account info in chbtc" do
#   r=Chbtc.balances
#   p r
#   p r.body
# end

# test "test submit order info in chbtc" do
#   r=Chbtc.submit_order(0,'cny','etc',200,0.1)
#   p r
#   p r.body
# end

# test "test submit cancel order info in chbtc" do
#   r=Chbtc.cancel_order('cny','etc',2017082941434602)
#   p r
#   p r.body
# end

# specifically, Chbtc has an api getOrdersIgnoreTradeType, which returns both traded and pending orders, so let's split it up a bit
# test "test get order list" do
#   r= Chbtc.order_list('cny','etc')
#   puts r.class
#   puts r.size
#   puts r[0].currency
# end

# test "test get my trade list" do
#   r= Chbtc.trade_list('cny','etc')
#   puts r.class
#   puts r[0].currency
#   puts r[0].price
#   puts r[0].status
# end
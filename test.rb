# require_relative 'btc38'
#
#
# btc38_1=Btc381.new(94238,'f742a88714ec4edd6f35180c9bb7cdeb923c6ea8eaee27d4e61c5c4dee1088b9','3b6f724d97da434fba4344c8bf6c2d80')
#  result=btc38_1.ticker
#  # result=btc38_1.balance
#
# p result
#
#
#
require_relative 'helper'
# require_relative 'btc381'
require_relative 'chbtc'
require 'json'
require 'rufus-scheduler'
require 'pp'
# scheduler=Rufus::Scheduler.new
#
# scheduler.every '1s' do
#   p Time.new
# end

# Btc38.setup do |config|
#   config.key="3b6f724d97da434fba4344c8bf6c2d80"
#   config.secret = 'f742a88714ec4edd6f35180c9bb7cdeb923c6ea8eaee27d4e61c5c4dee1088b9'
#   config.uid = '94238'
# end

test "test configuration" do
  Chbtc.setup do |config|
    config.key="368f6909-9838-4cca-99bc-5fc4b6795c06"
    config.secret = 'b23f7614-fe89-48e1-af95-3eedf8eff988'
  end
end

# test "test configure" do
#   OkCoin.setup do |config|
#     config.key="efa84830-1949-4a4b-8df8-2cfe843d0d86"
#     config.secret = '2C69B58CB805D6AFA40105EC1D7DD5A4'
#   end
# end
# following are unit tests:

# if ARGV[0].nil?
#   test 'ticker' do |r|
#     r=Btc38.ticker
#     p r
#     p r.body
#   end
#
#   test 'depth' do |r|
#     r=Btc38.depth
#     p r
#     p r.body
#   end
#
#   test 'trades' do |r|
#     r=Btc38.trades
#     p r
#     p r.body
#   end
#
# # return value is like 'succ|123'
# # or succ
# # or overBalance
# # or else
#   test 'make an order' do |r|
#     begin
#       r=Btc38.submit_order(1,'cny',1000,1,'btc' )
#       p r
#       p r.body
#     rescue Exception=>e
#       p e.message
#     end
#   end
#
# # return value includes:
# # "no_record"
# # "succ"
#   test 'cancel an order' do |r|
#     begin
#       r=Btc38.cancel_order('cny','btc','368205786')
#       p r
#       p r.body
#     rescue Exception=>e
#       p e.message
#     end
#   end
#
# test "my orders" do |r|
#   begin
#     r=Btc38.order_list('cny','btc')
#     p r
#   rescue Exception=>e
#     p e.message
#   end
# end
#
#   test "my trades" do |r|
#     begin
#       r=Btc38.trade_list('cny','xlm',1)
#       p r
#       p r.body
#     rescue Exception=>e
#       p e.message
#     end
#   end
#
# else   #eval the code
#   begin
#     r=(eval ARGV[0])
#     p r
#     p r.body
#   rescue Exception=>e
#     p e.message
#
#   end
# end





# test 'ticker parser' do
#   markets=Btc38.ordered_markets
#   p markets
# end
#
# test 'get the top 5 trading objects' do
#   coins=Btc38.get_top_n_objects(10)
#   p coins
# end

# test 'get order books of top 5 objects' do
#   coins=Btc38.get_top_n_objects(1)
#   coins.each do |coin|
#     reulst=JSON.parse Btc38.depth(coin)
#     depth=reulst.to_depth
#     absolute_mid_point=depth.absolute_mid_point
#     p depth
#   end
#
# end


# test "my orders to depth" do |r|
#   begin
#     r=JSON.parse Btc38.order_list('cny','btc')
#     p r
#     p r.class
#     order_list=r.to_depth
#     p order_list
#     p order_list.asks
#     p '-'*40
#     r=JSON.parse Btc38.depth
#     depth=r.to_depth
#     p '-'*40
#     d=depth-order_list
#     p d
#
#
#   end
# end
#
# test "test - method" do
#   r=JSON.parse Btc38.order_list('cny','btc')
#   pp r
#
#   p '-'*40
#   order_list=r.to_depth
#   pp order_list
#
#   p '-'*40
#   r=JSON.parse Btc38.depth
#   depth=r.to_depth
#   p '-'*40
#   d=depth-order_list
#   pp d
# end

# test "test the mid price" do
#   begin
#     r=JSON.parse Btc38.order_list('cny','btc')
#     order_list=r.to_depth
#
#     r=JSON.parse Btc38.depth
#     depth=r.to_depth
#
#     d=depth-order_list
#     pp d
#
#   rescue Exception=>e
#     pp e.message
#   end
# end




# test "test ticker in okcoin" do
#   r=OkCoin.ticker()
#   p r
# end
#
# test "test depth in okcoin" do
#   r=OkCoin.depth()
#   p r
# end
#
# test "test trades in okcoin" do
#   r=OkCoin.trades()
#   p r
# end



# test "test userinfo" do
#   r=OkCoin.balances
#   puts r.body
# end

# test "test submit order aka: trade in okcoin" do
#   r=OkCoin.submit_order("buy","cny",100,1,"btc")
#   puts r.body
# end

# test "test cancel order in okcoin which the order id is 9015822394" do
#   r=OkCoin.cancel_order(9015822394)
#   puts r.body
# end

# test "test order list in okcoin" do
#   r=OkCoin.order_list()
#   puts r
# end

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
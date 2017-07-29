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
require_relative 'btc381'
require 'json'
require 'rufus-scheduler'

# scheduler=Rufus::Scheduler.new
#
# scheduler.every '1s' do
#   p Time.new
# end

Btc38.setup do |config|
  config.key="3b6f724d97da434fba4344c8bf6c2d80"
  config.secret = 'f742a88714ec4edd6f35180c9bb7cdeb923c6ea8eaee27d4e61c5c4dee1088b9'
  config.uid = '94238'
end


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

test "my orders to depth" do |r|
  begin
    r=JSON.parse Btc38.order_list('cny','btc')
    p r
    p r.class
    order_list=r.to_depth
    p order_list
    p order_list.asks
    p '-'*40
    r=JSON.parse Btc38.depth
    depth=r.to_depth
    o '-'*40
    d=depth-order_list
    p d


  end
end
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
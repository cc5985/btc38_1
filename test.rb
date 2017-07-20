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

Btc38.setup do |config|
  config.key="3b6f724d97da434fba4344c8bf6c2d80"
  config.secret = 'f742a88714ec4edd6f35180c9bb7cdeb923c6ea8eaee27d4e61c5c4dee1088b9'
  config.uid = '94238'
end

test 'ticker' do |r|
  r=Btc38.ticker
  p r
  p r.body
end


test 'depth' do |r|
  r=Btc38.depth
  p r
  p r.body
end

test 'trades' do |r|
  r=Btc38.trades
  p r
  p r.body
end


# return value is like 'succ|123'
# or succ
# or overBalance
# or else
test 'make an order' do |r|
  begin
    r=Btc38.submit_order(1,'cny',1000,1,'btc' )
    p r
    p r.body
  rescue Exception=>e
    p e.message
  end
end


# return value includes:
# "no_record"
#
test 'cancel an order' do |r|
  begin
    r=Btc38.cancel_order('cny','btc','368205786')
    p r
    p r.body
  rescue Exception=>e
    p e.message
  end
end
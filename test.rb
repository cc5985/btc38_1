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

require 'btc38'

Btc38.setup do |config|
  config.key="3b6f724d97da434fba4344c8bf6c2d80"
  config.secret = 'f742a88714ec4edd6f35180c9bb7cdeb923c6ea8eaee27d4e61c5c4dee1088b9'
  config.uid = '94238'
end

r=Btc38.ticker
p r.body

r=Btc38.balances
p r.body




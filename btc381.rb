require 'net/http'
require 'digest'
require 'rest-client'

class Btc381
  attr_accessor :private_key
  attr_accessor :public_key
  attr_accessor :user_id
  # attr_accessor :market
  # attr_accessor :
  BaseURL='http://api.btc38.com/v1/'
  Ticker_URL='ticker.php'
  Balance_URL='getMyBalance.php'
  public
  def ticker(market=nil,mk_type=nil)
    market="btc" if market==nil
    mk_type="cny" if mk_type==nil
    # uri=(BaseURL+Ticker_URL+market+'&mk_type=cny')
    url="#{BaseURL+Ticker_URL}?c=#{market}&mk_type=#{mk_type}"
    p url
    response=RestClient.get(url,:user_agent=>'User-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)')
    return response.body

    # response=Net::HTTP.get(URI(url))

  end

  def balance()
    # http://api.btc38.com/v1/getMyBalance.php
    result=''
    begin
      ts=Time.now.to_i
      message="#{self.public_key}_#{self.user_id}_#{self.private_key}_#{ts}"
      sign=Digest::MD5.hexdigest(message)
      params="key=#{self.public_key}&time=#{ts}&md5=#{sign}"
      url = "#{BaseURL+Balance_URL}"
      params={}
      params['key']=self.public_key
      params['time']=ts
      params['md5']=sign
      response=RestClient.post(url,{key:self.public_key,skey:self.private_key,time:ts,md5:sign},{:user_agent=>'User-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)'})
      # Net::HTTP.start(url.host, url.port,:user_agent => 'User-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)') do |http|
      #   req = Net::HTTP::Post.new(url.path)
      #   req.set_form_data(params)
      #   puts http.request(req).body
      # end
      #
      #
      # req = Net::HTTP::Post.new(url)
      # req.set_form_data('from' => '2005-01-01', 'to' => '2005-03-31')
      #
      # res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      #   http.request(req)
      return response.body
    end


  end

  def initialize(user_id, private_key,public_key)
    self.private_key=private_key
    self.public_key=public_key
    self.user_id=user_id.to_s
  end


end


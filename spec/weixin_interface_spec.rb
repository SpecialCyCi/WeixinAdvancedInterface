#encoding: utf-8
require 'spec_helper'
require 'faraday'

# WeixinInterface 运行于单例模式下
describe WeixinInterface do
  
  # 观察 http request 代码
  # Faraday.new(:url => 'https://api.weixin.qq.com/cgi-bin/') do |f|
  #   f.response :logger
  #   f.adapter  Faraday.default_adapter
  # end

  before do
    @interface = WeixinInterface.instance
    # app_id 和 app_secret 在 config/initializers/wechat_interface.rb 已初始化
  end

  # 将当前时间stub成token过期的时间
  def make_time_to_expired_time
    # 微信token过期时间是7200, 程序在 now + 7200 * 0.75 后认为token过期
    expires_time = Time.now.to_i + 7200 * 0.75 + 1
    Time.stub(:now).and_return Time.at(expires_time.to_i)
  end

  def get_user_info
    @openid = "oQUT-tuN_OhK8GNw7ypphWRejtmQ"
    return @interface.get_user_info(@openid)
  end

  describe "get user info" do

    it "should be successfully" do
      user = get_user_info
      puts user
      user['openid'].should eq @openid
    end

  end

  describe "access_token method" do

    it "should not be nil while has token" do
      @interface.get_access_token
      @interface.access_token.should_not be_nil
    end

    # 测试access token在过期后是否返回null
    it "should be nil while token expires" do
      @interface.get_access_token
      make_time_to_expired_time
      @interface.access_token.should be_nil
    end

  end

  describe "request method" do

    # token 过期后所有请求应该重新获取token
    it "should call get_access_token method while token expires" do
      @interface.get_access_token
      make_time_to_expired_time
      @interface.should_receive(:get_access_token).exactly(1).times
      @interface.request(:get, "url")
    end

    # 避免类似 cache-db 的 dog pile effect
    # 当多个请求同时到达，并且token已过期，get_access_token函数应只被call一次,避免大量token请求被微信拒绝
    it "should call get_access_token one times while many requests arrive and token expires" do
      @interface.get_access_token
      make_time_to_expired_time
      # ... rspec thread 测试不懂，只有观察log效果了...
      10.times do |i|
        Thread.new{ get_user_info }
      end
      sleep 10
    end

  end

end
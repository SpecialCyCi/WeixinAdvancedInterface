#encoding: utf-8
require 'faraday'
require 'json'
require 'logger'
require 'singleton'

# 用以获取微信oauth
# 本例必须用单例模式实例化，防止过多请求token
class WeixinOauth

  include Singleton

  def initialize
    @conn = Faraday.new(:url => 'https://api.weixin.qq.com/sns/oauth2/') do |f|
      f.response :logger
      f.adapter  Faraday.default_adapter
    end
  end

  def app_id=(app_id)
    @app_id = app_id
  end

  def app_secret=(app_secret)
    @app_secret = app_secret
  end

  # 链接微信oauth2.0,获取openid
  def get_openid(code)
    ret = @conn.get "access_token?appid=#{@app_id}&secret=#{@app_secret}&code=#{code}&grant_type=authorization_code"
    ret = JSON.parse(ret.body)
    ret['openid']
  end

end
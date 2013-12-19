#encoding: utf-8
require 'faraday'
require 'json'
require 'logger'
require 'singleton'

# 本例必须用单例模式实例化，防止过多请求token
class WeixinInterface

  include Singleton

  def initialize
    @lock = Mutex.new
    @conn = Faraday.new(:url => 'https://api.weixin.qq.com/cgi-bin/') do |f|
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

  # 获取用户基本信息
  def get_user_info(open_id)
    request(:get, "user/info?openid=#{open_id}")
  end

  # 获取所有用户分组
  def get_user_groups
    request(:get, "groups/get")
  end

  # 创建用户分组
  def create_user_group(name)
    data = { "group" => { "name" => name } }
    request(:post, "groups/create", body: JSON.generate(data) )
  end

  # 修改用户分组名
  def update_group_name(group_id, new_group_name)
    data = { "group" => {"id" => group_id, "name" => new_group_name } }
    request(:post, "groups/update", body: JSON.generate(data) )
  end

  # 移动用户分组
  def move_user_to_group(openid, to_groupid)
    data = { "openid" => openid, "to_groupid" => to_groupid }
    request(:post, "groups/members/update", body: JSON.generate(data) )
  end

  # 发送文本信息给用户(客服接口...)
  def send_message(openid, text)
    data = { "touser" => openid, "msgtype" => "text", "text" => { "content" => text} }
    request(:post, "message/custom/send", body: JSON.generate(data) )
  end

  # 创建自定义菜单
  def create_menu(menu_hash)
    request(:post, "menu/create", body: JSON.generate(menu_hash) )
  end

  # 获取access token并判断是否过期
  def access_token
    return @access_token unless access_token_expired?
  end

  # token 是否过期
  def access_token_expired?
    Time.now.to_i > @expires_time.to_i
  end

  # 连接服务器获取access_token
  def get_access_token
    # 检查token是否过期
    return unless access_token_expired?
    ret = @conn.get "token?grant_type=client_credential&appid=#{@app_id}&secret=#{@app_secret}"
    ret = JSON.parse(ret.body)
    @access_token = ret['access_token']
    @expires_time = Time.now.to_i + ret['expires_in'] * 0.75
  end

  # 确保在token过期时只能有一个request请求token.
  def lock_get_access_token
    if access_token_expired?
      @lock.synchronize{ get_access_token } 
    end
  end

  def request(method,url, params = {})
    lock_get_access_token
    if method == :post
      ret = @conn.post do |req|
        req.url url + "?access_token=#{access_token}"
        req.body = params[:body]
      end
    else
      ret = @conn.get do |req|
        req.url url + "&access_token=#{access_token}"
      end
    end
    JSON.parse(ret.body) if ret.status == 200
  end

end
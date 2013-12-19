# WeixinAdvancedInterface
微信高级接口调用 0.0.1

## Installation

Add this line to your application's Gemfile:

    gem 'weixin_advanced_interface'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install weixin_advanced_interface

## Structure

 1. WeixinInterface -- 微信高级接口的详细功能
 2. WeixinOauth     -- 微信网页oauth

详细文档请参考微信高级接口官方文档

## Usage
设置app_id和app_secret
```ruby
# 微信高级接口设置
interface = WeixinInterface.instance
interface.app_id = Rails.configuration.wechat_app_id
interface.app_secret = Rails.configuration.wechat_app_secret

oauth_interface = WeixinOauth.instance
oauth_interface.app_id = Rails.configuration.wechat_app_id
oauth_interface.app_secret = Rails.configuration.wechat_app_secret
```
基本使用用法
```ruby
user_info = interface.get_user_info(open_id)
```
其余函数可以直接看源码.返回值都是Hash.

## Tips
结合sidekiq异步使用更佳

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Author
Email: specialcyci#gmail.com
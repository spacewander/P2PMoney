require 'bcrypt'

class User < ActiveRecord::Base

  # users.password_hash in the database is a :string
  include BCrypt

  validates :username, :email, :telephone, :password, :real_name, :id_card_num,
    :presence => { message: '不能为空 '}
  validates :username, :email, :uniqueness => { message: '已经被人抢注了，换一个吧 '}
  validates :username, length: { maximum: 30,
    too_long: "用户名长度不能超过%{count}个字符 " }

  validates :password, :confirmation => { message: '跟密码不匹配啊 ' }
  validate :password_given
  attr_reader :password
  attr_accessor :password_confirmation

  validates :email, format: { with: /\A\w+@\w+(?:\.[a-zA-Z]+)+\z/, 
    message: "邮箱地址不正确 "} 
  validates :id_card_num, format: { with: /\A4401/,
    message: "身份证号码不正确 " }
  validates :telephone, :numericality => { message: '电话号码不合法 ' }

  def self.authenticate(name, password)
    if @user = find_by_username(name)
      if @user.password == password
        @user
      else
        nil
      end
    end
  end

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  private

  def password_given
    errors.add(:password, "请输入密码") unless password_hash.present?
  end

end

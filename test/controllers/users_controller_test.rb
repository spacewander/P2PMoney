require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @input = {
      username: 'lzx',
      password: '123',
      password_confirmation: '123',
      telephone: 123,
      email: 'abc@qq.com',
      real_name: '林则徐',
      id_card_num: 440108
    }
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, :user => @input
    end

    assert_redirected_to login_url
  end

  test "should let user login" do
    assert_not_equal nil, User.authenticate('MyString', '123')
  end

end

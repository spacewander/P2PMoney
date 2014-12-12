require 'test_helper'

class InvestmentsControllerTest < ActionController::TestCase
  test "成功投资" do
    session[:id] = users(:two).id
    session[:loan_id] = loans(:one).id
    assert_difference('Investment.count') do
      post :create, :password => 'a'
    end

    assert_equal loans(:one).id, assigns(:investment).loan_id
    assert_equal session[:id], assigns(:investment).user_id
    assert_equal false, assigns(:investment).is_repay
    assert_equal true, assigns(:loan).is_invested
    assert_equal 15000, assigns(:investor).balance
    assert_equal 15000, User.find(assigns(:loan).user_id).balance
    assert_redirected_to new_investment_path 
  end

  test "投资失败，因为余额不足" do
    session[:id] = users(:two).id
    session[:loan_id] = loans(:two).id
    post :create, :password => 'a'
    assert_redirected_to new_investment_path 
    assert_equal '余额不足 ', assigns(:investor).errors.messages[:balance].first
  end

  test "投资失败，因为密码不对" do
    session[:id] = users(:two).id
    session[:loan_id] = loans(:one).id
    post :create, :password => 'ab'
    assert_redirected_to new_investment_path 
    assert_equal "密码不对", assigns(:error)
  end
end

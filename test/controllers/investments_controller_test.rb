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
    assert_equal true, Loan.find(session[:loan_id]).is_invested
    assert_equal 15000, User.find(assigns(:investor)).balance.to_i
    assert_equal 15000, User.find(assigns(:loan).user_id).balance.to_i
    assert_redirected_to controller: 'users', action: 'invest'  
  end

  test "投资失败，因为余额不足" do
    session[:id] = users(:two).id
    session[:loan_id] = loans(:two).id
    assert_no_difference('Investment.count') do
      post :create, :password => 'a'
    end
    assert_redirected_to action: 'new', id: session[:loan_id].to_i
    assert_equal '余额不足 ', 
      assigns(:investor).errors.messages[:balance].first
    assert_equal 20000, User.find(assigns(:investor).id).balance.to_i
    assert_equal 10000, User.find(assigns(:loan).user_id).balance.to_i
    assert_equal false, assigns(:investment).is_repay
    assert_equal false, Loan.find(session[:loan_id]).is_invested
  end

  test "投资失败，因为密码不对" do
    session[:id] = users(:two).id
    session[:loan_id] = loans(:one).id
    assert_no_difference('Investment.count') do
      post :create, :password => 'ab'
    end
    assert_redirected_to action: 'new', id: session[:loan_id].to_i
    assert_equal "密码不对", assigns(:error)
    assert_equal 20000, User.find(assigns(:investor).id).balance.to_i
    assert_equal 10000, User.find(assigns(:loan).user_id).balance.to_i
    assert_equal nil, assigns(:investment)
    assert_equal false, Loan.find(session[:loan_id]).is_invested
  end
end

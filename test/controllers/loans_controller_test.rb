require 'test_helper'


class LoansControllerTest < ActionController::TestCase
  test "成功还款" do
    loan_interval = (Time.now.to_date - loans(:five).loan_time).to_i
    loan_interval = loan_interval >= 30 ? loan_interval : 30
    interest = loans(:five).amount * 11.00 / 100 * loan_interval / 360

    session[:id] = users(:three).id
    post :repay, :password => '1', :bank_card_num => '1', :id => loans(:five).id

    # 检查是否正确地保存了
    assert_equal true, Investment.find(assigns(:investment).id).is_repay
    assert_equal true, Loan.find(loans(:five).id).is_repay
    assert_equal (25000 + interest).to_i, 
      User.find(assigns(:investor).id).balance.to_i
    assert_equal (15000 - interest).to_i, 
      User.find(assigns(:debtor).id).balance.to_i
    assert_redirected_to user_path(session[:id])
  end

  test "还款失败，因为余额不足" do
    session[:id] = users(:three).id
    post :repay, :password => '1', :bank_card_num => '1', :id => loans(:four).id

    assert_redirected_to loan_path
    assert_equal '余额不足 ', 
      assigns(:debtor).errors.messages[:balance].first
    # 检查是否正确地回滚了
    assert_equal false, Investment.find(assigns(:investment).id).is_repay
    assert_equal false, Loan.find(loans(:two).id).is_repay
    assert_equal 20000, User.find(assigns(:investor).id).balance.to_i
    assert_equal 20000, User.find(assigns(:debtor).id).balance.to_i
  end

  # 不需要测试了，因为禁止给自己投资
  test "测试自己给自己借款/还款的情况" do
    #session[:id] = users(:one).id
    #post :repay, :password => '1', :bank_card_num => '1', :id => loans(:three).id

     #检查是否正确地保存了
    #assert_equal true, Investment.find(assigns(:investment).id).is_repay
    #assert_equal true, Loan.find(loans(:three).id).is_repay
    #assert_equal 10000, User.find(assigns(:investor).id).balance.to_i
    #assert_equal 10000, User.find(assigns(:debtor).id).balance.to_i
    #assert_redirected_to controller: 'users', action: 'debt'  
  end

end

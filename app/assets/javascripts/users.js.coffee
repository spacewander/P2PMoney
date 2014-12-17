# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  [controller, action] = Webpath()
  if controller == "users-controller"
    switch action
      when 'new-action', 'create-action'
        FormHelper.checkRegisterForm()
      when 'edit-action', 'update-action'
        FormHelper.lockInput()
        FormHelper.bindUnlockAction()
        FormHelper.checkEditForm()
      when 'show-action'
        FormHelper.checkChargeForm()
      when 'debt-action'
        Users.bindClickRepayBtn()
      else
      # do nothing
  # 为了追求复用，loans也用这个表单检查函数
  else if controller == "loans-controller"
    switch action
      when 'new-action', 'create-action'
        FormHelper.checkLoanForm()
      when 'show-action', 'repay-action'
        FormHelper.checkRepayForm()
  else if controller == 'investments-controller'
    switch action
      when 'new-action', 'create-action'
        FormHelper.checkInvestForm()
        

$(document).ready(ready)
$(document).on('page:load', ready)

FormHelper =
  lockInput: ->
    inputs = document.getElementsByTagName('input')
    for e in inputs
      if e.type in ['text', 'date', 'number', 'password', 'email']
        if e.readOnly = true
          e.data_readOnly = true
        e.readOnly = true

    $('input[type=submit]').hide()

  bindUnlockAction: ->
    $('#user-edit-btn').click =>
      @unlockInput()

  unlockInput: ->
    inputs = document.getElementsByTagName('input')
    for e in inputs
      if e.type in ['text', 'date', 'number', 'password', 'email']
        if e.readOnly = true and e.data_readOnly != true
          e.readOnly = false

    $('#user-edit-btn').hide()
    $('input[type=submit]').show()

  checkRegisterForm: ->
    @bindNullRegisterChecker('user_username')
    @bindNullRegisterChecker('user_real_name')
    @bindPasswordRegisterChecker()
    @bindEmailRegisterChecker()
    @bindTelephoneRegisterChecker()
    @bindAcceptChecker()

  checkEditForm: ->
    @bindNullRegisterChecker('user_username')
    @bindNullRegisterChecker('user_real_name')
    @bindEmailRegisterChecker()
    @bindTelephoneRegisterChecker()

  checkChargeForm: ->
    @bindPasswordChecker()
    @bindBankCardNumChecker()
    @bindAmountChecker()

  checkLoanForm: ->
    @bindNullRegisterChecker('loan_company')
    @bindNullRegisterChecker('loan_age')
    @bindNullRegisterChecker('loan_loan_time')
    @bindNullRegisterChecker('loan_repay_time')
    @bindLoanBankCardNumChecker()
    @bindLoanAmountChecker()

  checkRepayForm: ->
    @bindNullRegisterChecker('password')
    @bindBankCardNumChecker()

  checkInvestForm: ->
    @bindNullRegisterChecker('password')

  editHelpBlock: (labelName, msg) ->
    return if labelName == ''
    # 使用CSS3的同级选择器
    if $("##{labelName} ~ .help-block").length
      $('span.help-block').text(msg)
    else
      if $("##{labelName}")?.parent().hasClass('form-group')
        $("##{labelName}")?.parent().addClass('has-error')
      else
        $("##{labelName}")?.parent().parent().addClass('has-error')

      $("##{labelName}").after("""
        <span class="help-block">#{msg}</span>
        """)

  bindPasswordRegisterChecker: ->
    $('form').submit (event) =>
      password = $('input[name="user[password]"]').val().trim()
      if password == ''
        event.preventDefZault()
        @editHelpBlock('user_password', '不能为空！')

      password_confirmation = $('#user_password_confirmation').val().trim()
      if password_confirmation == ''
        event.preventDefault()
        @editHelpBlock('user_password_confirmation', '不能为空！')
      else if password_confirmation != password
        event.preventDefault()
        @editHelpBlock('user_password_confirmation', '确认密码不匹配')

  bindNullRegisterChecker: (id) ->
    $('form').submit (event) =>
      name = $("##{id}").val().trim()
      if name == ''
        event.preventDefault()
        @editHelpBlock("#{id}", '不能为空！')

  bindEmailRegisterChecker: ->
    $('form').submit (event) =>
      email = $('#user_email').val().trim()
      if email == ''
        event.preventDefault()
        @editHelpBlock('user_email', '不能为空！')
      else if !email.match(/^\w+@\w+(?:\.[a-zA-Z]+)+$/)
        event.preventDefault()
        @editHelpBlock('user_email', '邮箱地址不正确！')

  bindTelephoneRegisterChecker: ->
    $('form').submit (event) =>
      telephone = $('#user_telephone').val().trim()
      if !telephone.match(/\d+/)
        event.preventDefault()
        @editHelpBlock('user_telephone', '号码不合法！')

  bindAcceptChecker: ->
    $('form').submit (event) ->
      if !document.querySelector('#accept').checked
        event.preventDefault()

  bindPasswordChecker: ->
    $('form').submit (event) =>
      password = $("#password").val().trim()
      if password == ''
        event.preventDefault()
        @editHelpBlock('password', '密码不能为空！')

  bindBankCardNumChecker: ->
    $('form').submit (event) =>
      bank_card_num = $("#bank_card_num").val().trim()
      if !(bank_card_num.match /^\d+$/)
        event.preventDefault()
        @editHelpBlock('bank_card_num', '银行卡号码不对')

  bindAmountChecker: ->
    $('form').submit (event) =>
      amount = $("#amount").val().trim()
      if amount == '' or amount == '0'
        event.preventDefault()
        @editHelpBlock('amount', '金额不对')

  bindLoanBankCardNumChecker: ->
    $('form').submit (event) =>
      bank_card_num = $("#loan_bank_card_num").val().trim()
      if !(bank_card_num.match /^\d+$/)
        event.preventDefault()
        @editHelpBlock('loan_bank_card_num', '银行卡号码不对')

  bindLoanAmountChecker: ->
    $('form').submit (event) =>
      amount = $("#loan_amount").val().trim()
      if amount == '' or amount == '0'
        event.preventDefault()
        @editHelpBlock('loan_amount', '金额不对')


Users =
  bindClickRepayBtn: ->
    $('.debt.btn').click ->
      this.firstElementChild.click()
    

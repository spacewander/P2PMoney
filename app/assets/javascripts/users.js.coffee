# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  [controller, action] = Webpath()
  if controller == "users-controller"
    switch action
      when 'new-action', 'create-action'
        Users.checkForm()
      when 'show-action'
        
      else
      # do nothing
    
Users =
  checkForm: ->
    @bindNullRegisterChecker('user_username')
    @bindNullRegisterChecker('user_real_name')
    @bindPasswordRegisterChecker()
    @bindEmailRegisterChecker()
    @bindTelephoneRegisterChecker()
    @bindIdCardNumRegisterChecker()
    @bindAcceptChecker()

  editHelpBlock: (labelName, msg) ->
    return if labelName == ''
    # 使用CSS3的同级选择器
    if $("##{labelName} ~ .help-block").length
      $('span.help-block').text(msg)
    else
      $("##{labelName}")?.parent().parent().addClass('has-error')
      .find("input")
      .after("""
        <span class="help-block">#{msg}</span>
        """)

  bindPasswordRegisterChecker: ->
    $('form').submit (event) =>
      password = $('input[name="user[password]"]').val().trim()
      if password == ''
        event.preventDefault()
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

  bindIdCardNumRegisterChecker: ->
    $('form').submit (event) =>
      id_card_num = $('#user_id_card_num').val().trim()
      if id_card_num.substring(0, 4) != '4401'
        event.preventDefault()
        @editHelpBlock('user_id_card_num', '号码不合法！')

  bindAcceptChecker: ->
    $('form').submit (event) ->
      if !document.querySelector('#accept').checked
        event.preventDefault()


# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  [controller, action] = Webpath()
  if controller == "loans-controller"
    switch action
      when 'index-action'
        Loans.checkSpecifitRadio()
        Loans.bindFilterChange()
        Loans.bindClickInvestBtn()
    

$(document).ready(ready)
$(document).on('page:load', ready)

Loans =
  checkSpecifitRadio: ->
    amount = $('#amount_checked').text()
    interval = $('#interval_checked').text()
    radios = document.querySelectorAll('input[type=radio]')
    for radio in radios
      if radio.name == 'amount' and radio.value == amount
        radio.checked = 'checked'
      else if radio.name == 'interval' and radio.value == interval
        radio.checked = 'checked'


  bindFilterChange: ->
    radios = document.querySelectorAll('input[type=radio]')
    for radio in radios
      radio.addEventListener 'click', ->
        #page = $('#loan-pagination .active > span').text()
        amount = $('#amount-condition input[type=radio]:checked').val()
        interval = $('#interval-condition input[type=radio]:checked').val()
        Loans.pageReloadWithFilter amount, interval

  pageReloadWithFilter: (amount, interval) ->
    window.location.search =
      "?page=1&amount=#{amount}&interval=#{interval}"

  bindClickInvestBtn: ->
    $('.invest > .btn').click ->
      this.firstElementChild.click()

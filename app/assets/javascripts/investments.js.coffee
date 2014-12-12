# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  [controller, action] = Webpath()
  if controller == "investments-controller"
    switch action
      when 'new-action', 'create-action'
        Investments.bindNextStep()
    
$(document).ready(ready)
$(document).on('page:load', ready)


Investments =
  bindNextStep: ->
    $('.next-step').click ->
      $('.new-investment-form').removeClass('hidden')
      $('#new-investment-table').hide()
      $(this).hide()

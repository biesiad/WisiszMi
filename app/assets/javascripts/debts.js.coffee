# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  # friends vertical align
  $('.friends').masonry
    itemSelector : '.friend'
  
  # toggle debt form
  $('.add_debt').click (event) -> 
    $(this).next().toggle()
    $(this).next().children().find('#debt_description').focus()
    $(this).trigger('debt_toggle')
    event.preventDefault() 

  # debt form toggle relayout
  $('.add_debt').bind 'debt_toggle', ->
    $('.friends').masonry('reload')

  # debt submitting
  $('input[type=submit]').bind 'click', (event) ->
    form = $(@).closest('form')
    friend = JSON.parse form.find('#friend').val()
    return true if friend.is_user 

    description = form.find('#debt_description').val()
    value = form.find('#debt_value').val()

    FB.ui
      method: 'apprequests'
      to: friend.facebook_id
      message: 'Twój znajomy właśnie dodał nowy dług: "' + description + '", o wartości: ' + value + ',- . Wejdź do aplikacji WisiszMi, aby lepiej zarządzać swoimi pożyczkami.'
      =>
        if $(@).attr('name') == 'debit'
          debit = $('<input type=hidden name=debit value=true />')
          form.append(debit)
        form.submit()

    return false 

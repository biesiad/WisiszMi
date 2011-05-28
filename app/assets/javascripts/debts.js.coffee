# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  # friends vertical align
  $('.friends').masonry({
    itemSelector : '.friend',
    #columnWidth : 380
  })
  
  # toggle debt form
  $('.add_debt').click (event) -> 
    $(this).next().toggle()
    $(this).next().children().find('#debt_description').focus()
    $(this).trigger('debt_toggle')
    event.preventDefault() 

  $('.add_debt').bind 'debt_toggle', ->
    $('.friends').masonry('reload')
    

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  # toggle debt form
  $('.add_debt').click (event) -> 
    $(this).next().toggle()
    $(this).next().children().find('#debt_description').focus()
    event.preventDefault() 

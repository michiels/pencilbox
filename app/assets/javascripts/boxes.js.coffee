# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('p img').each () ->
    $(this).parent().addClass('with_image')

  $('a[data-behavior=close-branding-bar]').click () ->
    $('.branding').fadeOut()
    return false
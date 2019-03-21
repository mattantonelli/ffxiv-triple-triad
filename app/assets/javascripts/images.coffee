$(document).on 'turbolinks:load', ->
  $('.avatar').on 'error', ->
    $(this).css('opacity', 0)

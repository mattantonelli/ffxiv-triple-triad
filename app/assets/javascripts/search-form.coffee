$(document).on 'turbolinks:load', ->
  $('.search-form').submit ->
    $(this).find(':input').filter(-> !@value).prop('disabled', true)
    true


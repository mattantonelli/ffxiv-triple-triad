$(document).on 'turbolinks:load', ->
  return unless $('#npcs').length > 0

  restripe = ->
    $('tbody tr:visible').each (index) ->
      $(this).css('background-color', if index % 2 == 0 then 'rgba(0, 0, 0, 0.1)' else 'rgba(0, 0, 0, 0.2)')

  if localStorage.getItem('display-completed') == 'false'
    $('.completed').hide()
    $('#toggle-completed').prop('checked', true)
    restripe()
  else
    $('.completed').show()

  $('#toggle-completed').change ->
    $('.completed').toggle()

    if !this.checked
      localStorage.setItem('display-completed', 'true')
    else
      localStorage.setItem('display-completed', 'false')

    restripe()

  $('#npc-search select').change ->
    $('form').submit()

$(document).on 'turbolinks:load', ->
  return unless $('#my-cards').length > 0

  restripe = ->
    $('tbody tr:visible').each (index) ->
      $(this).css('background-color', if index % 2 == 0 then 'rgba(0, 0, 0, 0.1)' else 'rgba(0, 0, 0, 0.2)')

  if localStorage.getItem('display-owned') == 'false'
    $('.has-card').hide()
    $('#toggle-owned').prop('checked', true)
    restripe()
  else
    $('.has-card').show()

  $('.card-toggle').change ->
    card = $(this)

    if !this.checked
      $.post(card.data('path'), { authenticity_token: window._token })
      path = card.data('path').replace('remove', 'add')
      card.closest('tr').removeClass('has-card')
    else
      $.post(card.data('path'), { authenticity_token: window._token })
      path = card.data('path').replace('add', 'remove')
      row = card.closest('tr')
      row.addClass('has-card')
      if $('#toggle-owned').prop('checked')
        row.hide()

    card.data('path', path)
    $('.btn-attention').removeClass('btn-attention')

  $('#toggle-owned').change ->
    $('.has-card').toggle()

    if !this.checked
      localStorage.setItem('display-owned', 'true')
    else
      localStorage.setItem('display-owned', 'false')

    restripe()

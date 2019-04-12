$(document).on 'turbolinks:load', ->
  return unless $('#my-cards').length > 0

  restripe = ->
    $('tbody tr:visible').each (index) ->
      $(this).css('background-color', if index % 2 == 0 then 'rgba(0, 0, 0, 0.1)' else 'rgba(0, 0, 0, 0.2)')

    progress = $('.progress-bar')
    current = $('.has-card').length
    max = $('.card-row').length
    completion = (current / max) * 100

    progress.attr('aria-valuenow', current)
    progress.attr('style', "width: #{completion}%")
    progress.find('b').text("#{current}/#{max} (#{parseInt(completion)}%)")

  updateCollection = (card) ->
    $.ajax({
      type: 'POST',
      url: card.data('path'),
      data: { authenticity_token: window._token },
      error: ->
        alert('There was a problem updating your collection. Please try again.')
        location.reload()
    })

  if localStorage.getItem('display-owned') == 'false'
    $('.has-card').hide()
    $('#toggle-owned').prop('checked', true)
    restripe()

  $('.card-toggle').change ->
    card = $(this)

    if !this.checked
      updateCollection(card)
      path = card.data('path').replace('remove', 'add')
      card.closest('tr').removeClass('has-card')
    else
      updateCollection(card)
      path = card.data('path').replace('add', 'remove')
      row = card.closest('tr')
      row.addClass('has-card')
      if $('#toggle-owned').prop('checked')
        row.hide()

    card.data('path', path)
    $('.btn-attention').removeClass('btn-attention')
    restripe()

  $('#toggle-owned').change ->
    $('.has-card').toggle()

    if !this.checked
      localStorage.setItem('display-owned', 'true')
    else
      localStorage.setItem('display-owned', 'false')

    restripe()

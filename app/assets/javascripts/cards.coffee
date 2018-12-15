$(document).on 'turbolinks:load', ->
  $('.card-toggle').change ->
    card = $(this)

    if !this.checked
      $.post(card.data('path'), { authenticity_token: window._token })
      path = card.data('path').replace('remove', 'add')
      card.closest('tr').removeClass('has-card')
    else
      $.post(card.data('path'), { authenticity_token: window._token })
      path = card.data('path').replace('add', 'remove')
      card.closest('tr').addClass('has-card')

    card.data('path', path)

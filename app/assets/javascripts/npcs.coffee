$(document).on 'turbolinks:load', ->
  return unless $('#npcs').length > 0

  restripe = ->
    $('tbody tr:visible').each (index) ->
      $(this).css('background-color', if index % 2 == 0 then 'rgba(0, 0, 0, 0.1)' else 'rgba(0, 0, 0, 0.2)')

    progress = $('.progress-bar')
    current = $('.defeated:not(.excluded)').length
    max = $('.npc-row:not(.excluded)').length
    completion = (current / max) * 100

    progress.attr('aria-valuenow', current)
    progress.attr('style', "width: #{completion}%")
    progress.find('b').text("#{current}/#{max} (#{parseInt(completion)}%)")

  updateNPC = (npc) ->
    $.ajax({
      type: 'POST',
      url: npc.data('path'),
      data: { authenticity_token: window._token },
      error: ->
        alert('There was a problem updating your completion. Please try again.')
        location.reload()
    })

  updateCard = (card) ->
    $.ajax({
      type: 'POST',
      url: card.data('path'),
      data: { authenticity_token: window._token },
      error: ->
        alert('There was a problem updating your collection. Please try again.')
        location.reload()
    })

  $('input[name="display"]').change ->
    $('.npc-row').show()
    if $('#show-all').prop('checked')
      localStorage.setItem('npc-display', 'show-all')
    else if $('#hide-completed').prop('checked')
      $('.completed').hide()
      localStorage.setItem('npc-display', 'hide-completed')
    else if $('#hide-defeated').prop('checked')
      $('.defeated').hide()
      localStorage.setItem('npc-display', 'hide-defeated')
    else if $('#hide-finished').prop('checked')
      $('.completed.defeated').hide()
      localStorage.setItem('npc-display', 'hide-finished')

    restripe()

  display_setting = localStorage.getItem('npc-display')
  if display_setting != null
    $('#' + display_setting).click()

  $('#npc-search select').change ->
    $('form').submit()

  $('.npc-toggle').change ->
    npc = $(this)

    if !this.checked
      updateNPC(npc)
      path = npc.data('path').replace('remove', 'add')
      npc.closest('tr').removeClass('defeated')
    else
      updateNPC(npc)
      path = npc.data('path').replace('add', 'remove')
      row = npc.closest('tr')
      row.addClass('defeated')
      if $('#hide-defeated').prop('checked')
        row.hide()

    npc.data('path', path)
    restripe()

  $('.card-toggle').click ->
    card = $(this)

    # Update the users' card collection and toggle the card
    if card.hasClass('owned')
      updateCard(card)
      card.removeClass('owned')
      path = card.data('path').replace('remove', 'add')
    else
      updateCard(card)
      card.addClass('owned')
      path = card.data('path').replace('add', 'remove')

    card.data('path', path)

    # Update the NPC's completion status
    cardList = card.parent()

    if cardList.find('.owned').length == cardList.children().length
      card.closest('tr').addClass('completed')
    else
      card.closest('tr').removeClass('completed')

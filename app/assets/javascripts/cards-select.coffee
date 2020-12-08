$(document).on 'turbolinks:load', ->
  return unless $('.card-select').length > 0

  all_cards = ->
    $('.card-select')

  owned_cards = ->
    $('.card-select:not(.missing)')

  missing_cards = ->
    $('.card-select.missing')

  page = 1
  dirty = false
  page_size = 30
  page_max = Math.ceil(all_cards().length / page_size)

  navigate_to = (page) ->
    hide_missing = $('#toggle-missing').prop('checked')
    cards = if hide_missing then owned_cards() else all_cards()

    cards.slice((page - 1) * page_size, page * page_size).show()
    cards.slice(page * page_size).hide()
    cards.slice(0, (page - 1) * page_size).hide()

    if hide_missing
      missing_cards().hide()

    $('#page').text('Page ' + page)

  update_cards = ->
    $('#total').text('Total: ' + owned_cards().length)
    ids = $.map owned_cards(), (card) -> $(card).data('id')
    $('#card-ids').val(ids.toString())
    dirty = true

  reset_page = ->
    page = 1
    navigate_to(page)

  navigate_to(page)

  $(document).off 'turbolinks:before-visit'
  $(document).on 'turbolinks:before-visit', ->
    if $('.card-select').length > 0 && dirty then return confirm('Your selection has not been saved! Are you sure you want to leave?')

  window.onbeforeunload = ->
    if $('.card-select').length > 0 && dirty then return true

  $('#add-all').click ->
    if !dirty || confirm('Are you sure you want to add all cards to your collection?')
      all_cards().removeClass('missing')
      $('#toggle-missing').prop('checked', true)
      update_cards()
      reset_page()

  $('#remove-all').click ->
    if !dirty || confirm('Are you sure you want to remove all cards from your collection?')
      owned_cards().addClass('missing')
      $('#toggle-missing').prop('checked', false)
      update_cards()
      reset_page()

  $('#toggle-missing').change ->
    missing_cards().toggle()
    navigate_to(page)

  $('.card-select').click ->
    card = $(this)

    if card.hasClass('missing')
      card.removeClass('missing')
    else
      card.addClass('missing')

    update_cards()
    navigate_to(page)

  $('#nav-prev').click ->
    page = if page == 1 then page_max else page - 1
    navigate_to(page)

  $('#nav-next').click ->
    page = if page == page_max then 1 else page + 1
    navigate_to(page)

  $('#submit').click ->
    dirty = false
    $('form').submit()

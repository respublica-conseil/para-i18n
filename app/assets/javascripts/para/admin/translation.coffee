$(document).on 'page:change', ->
  $('body').on 'change', '[data-locale-select]', (e) ->
    $(e.currentTarget).closest('form').submit()

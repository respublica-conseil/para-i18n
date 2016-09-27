$(document).on 'page:change turbolinks:load', ->
  $('body').on 'change', '[data-locale-select]', (e) ->
    $(e.currentTarget).closest('form').submit()

class TranslationLocaleSelect
  @onChange = ($field) ->
    targetURL = $field.data('locale-select-target-url')
    targetLocale = $field.val()
    targetURL = targetURL.replace('target_locale=_', ['target_locale', targetLocale].join('='))
    Turbolinks.visit(targetURL.replace(':locale', targetLocale))

$(document).on 'page:change turbolinks:load', ->
  $('body').on 'change', '[data-locale-select]', (e) ->
    TranslationLocaleSelect.onChange($(e.currentTarget))

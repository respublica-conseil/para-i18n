var TranslationLocaleSelect;

TranslationLocaleSelect = class TranslationLocaleSelect {
  static onChange($field) {
    var targetLocale, targetURL;
    targetURL = $field.data('locale-select-target-url');
    targetLocale = $field.val();
    targetURL = targetURL.replace('target_locale=_', ['target_locale', targetLocale].join('='));
    return Turbolinks.visit(targetURL.replace(':locale', targetLocale));
  }

};

$(document).on('turbo:load turbo:frame-load', function() {
  return $('body').on('change', '[data-locale-select]', function(e) {
    return TranslationLocaleSelect.onChange($(e.currentTarget));
  });
});

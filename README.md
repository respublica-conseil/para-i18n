# Para::I18n

This gem allows for translating models content within the [Para](https://github.com/para-cms/para)
admin interface.

It works by adding a translations layer to ActiveRecord models, like Globalize
does, and with a similar API, but using JSON fields instead of tables.

**Note** : This gem only works with Postgres 9.4+

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'para-i18n'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install para-i18n

Add the para-i18n javascript file to your app's admin manifest at `app/assets/javascripts/admin/app.(js|coffee)` :

```javascript
//= require para/i18n
```

## Usage

To allow models to be translated, you need to add the `_translations:jsonb`
column to your model.

You can use the `para:i18n:translate` generator to generate the migration.
For example, to translate a page model :

```bash
rails generate para:i18n:translate page -m
```

Note that the `-m` option automatically migrates after the migration is
created.

Now that your model has the translations field in the table, juste use the
`translates` macro in your model to define which fields will be translated :

```ruby
class Page < ActiveRecord::Base
  translates :title, :content
end
```

Now, any `crud` component managing the `Page` model will show a button to access
the translation interface for existing entries.

### Overriding the translations form

The translation form can be overriden by generating it with the `para:i18n:form`
generator. This is useful to delete or add fields to translate that are not
properly displayed by the default view.

For example, the `Page` model translation form can be generated the following
way :

```bash
rails g para:i18n:form page
```

This will create a partial at `app/views/admin/pages/_translations_form.html.haml`
that you can override.

### Locales fallbacks support

The gem fully supports Rails' I18n fallbacks and will try to fallback to any
available translation using the `I18n.fallbacks` hash if you enable them.

If not enabled, any untranslated content will be empty.

### Friendly id support

The gem comes with friendly_id i18n support, with a dedicated `:i18n` module to
include instead of the `:slugged` module into your models friendly_id options.

For example, for the page :

```ruby
class Page < ActiveRecord::Base
  translates :title, :slug

  friendly_id :title, use: [:i18n, :finders]
end
```

This will automatically build localized slugs when updating the `title` in any
locale, and will allow you to find the resources with the translated slugs.

Note that if I18n fallbacks are enabled, it will try to fall back to the next
locale if no resource was found for the given slug and locale.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/para-cms/para-i18n.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

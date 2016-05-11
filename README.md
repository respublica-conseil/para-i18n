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

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/para-cms/para-i18n.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


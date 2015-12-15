# RailsApiModel

TODO: This is a work in progress, it does not currently work.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_api_model'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails_api_model

## Usage

It is recommended that the API models are put in `<rails-root>/app/api_models` and namespaced in a module.
This will prevent them from conflicting with other parts of your application, such as the ActiveRecord models.

### Define an API model

To define an API model create a class in `<rails-root>/app/api_models` extending `RailsApiModel::Base`.
Then, you can configure it using our DSL.

```ruby
module ApiModels
  class User < RailsApiModel::Base
    # Associate an ActiveRecord model
    active_record_model ::User

    filters do
      # Allow filtering by these fields of the model
      allow_fields :name, :email, :rank, :created_at
    end

    fields do
      # Allow these fields to be displayed in the return object
      allow_fields :name, :email, :rank, :created_at, :updated_at

      # If not specified otherwise, display only these fields
      default_fields :name, :email
    end

    sorts do
      # Allow sorting by these fields
      allow_fields :name, :rank, :created_at
    end
  end
end
```

You can skip the `filters` or `sorts` blocks, but you will not be able to filter or sort using query parameters.

### Use the API model in a controller

The main use-case for `rails_api_models` is to handle filtering, sorting and display of objects in a RESTful API.
To create a list endpoint for the above definition of `User`, create a route and an `index` action like so:

```ruby
class UsersController < ApplicationController
  def index
    # Use the API model to filter, load and return the queried users
    ApiModels::User.query_all(params)
  end
end
```

### Use the API endpoint

With the above code, the following requests become possible:

- `/users` - all users are returned, with no sorting and containing only `name` and `email`.
- `/users?name=John` - all users named `John`
- `/users?name=John&fields=email` - only the emails of all users named `John`
- `/users?fields=_defaults,rank,created_at` - return all users with `name`, `email`, `rank` and `created_at`
- `/users?name=John&sort=created_at` - return all users named `John` sorted by their registration date
- `/users?name=John&sort=created_at:asc` - same as the above but in ascending order
- `/users?name=John&sort=created_at:asc,updated_at:desc`

#### Filter modifiers

The filter queries have the form of `<field>[:<modifier>]=<value>`. Valid modifiers are:

- `eq` - the default, can be omitted.
- `lt`, `lte`, `gt`, `gte` - standard comparisons
- `not` - negation

The value can be interpreted differently based on the field being filtered:

- As a string
- As a number
- As a datetime object
- As a date object - passing `date=2015-11-03` actually makes a range query to match all times during that day
- As a boolean (the strings `true`, `t`, `1`, `y` and `yes` are considered true, others are false)
- As an enum value (automatically converted to its integer representation)

### All available configurations

```ruby
module ApiModels
  class User < RailsApiModel::Base
    # Associate an ActiveRecord model
    active_record_model ::User

    filters do
      # Allow filtering by these fields of the model - `api/users?name=John&rank=admin`
      allowed_fields :name, :email, :rank, :created_at

      # Allow scopes to be used - `api/users?scope=admin,facebook`.
      # Using multiple scopes defines an intersection between them.
      allowed_scopes :user, :admin, :facebook

      # You can set custom filters
      filter :register_date do |relation, param_value|
        relation.where 'DATE(created_at) = DATE(?)', param_value
      end

      # Or, preferrably, define a custom filter class in `app/api_models/filters`...
      #
      module ApiModels
        module Filters
          class RegisterDateFilter < RailsApiModels::Filters::Base
            def apply_scope(relation, key, value)
              relation.where 'DATE(created_at) = DATE(?)', param_value
            end
          end
        end
      end
      #
      # ...and use it here:
      #
      filter :register_date, Filters::RegisterDateFilter

      # Set default filter
      default rank: :user

      # This works with all filters that can be used as a URL parameter:
      default 'rank:lt' => 1
      #
      # You sometimes need a block:
      default { {'created_at:lt' => Time.zone.now} }
      #
      # You can default to custom filters as well:
      default { {register_date: Time.zone.now} }

      # You can also filter by fields of an associated model. Let's say you have `has_many :posts`
      # on `User`. If you have defined `ApiModel::Post`
      #
      allowed_associations :posts
      #
      # This enable you to do `api/users?posts.created_at:gt=2015-12-01` which will give you all users
      # who have posted since 2015-12-01. This will only work if you have `allowed_fields :created_at`
      # in `ApiModel::Post`.
    end

    fields do
      # Allow these fields to be displayed in the return object
      allowed_fields :name, :email, :rank, :created_at, :updated_at

      # Set named groups of fields:
      #
      group :basic, [:name, :email]
      group :extended, [:name, :email, :rank]
      group :timestamps, [:created_at, :updated_at]
      #
      # This allows you to conveniently set which fields you want returned:
      #
      #   GET /api/users?fields=basic,timestamps => will give you objects with `name`,
      #                                             `email`, `created_at` and `updated_at`
      #
      # This is how the `_defaults` field works:
      #
      group :_defaults, User.fields.default

      # If not specified otherwise, display only these fields
      default :name, :email

      # You can also display an embedded object for a referenced model:
      #
      allowed_associations :posts, default_group: :basic
      #
      #   GET /api/users?fields=basic,posts => object with `name`, `email` and `posts` array
      #
      # The `default_group` specifies which of the groups defined in `ApiModels::Post`
      # will be used for the embedded object.
      # This can, of course, be overriden in the request:
      #
      #   GET /api/users?fields=basic,posts:extended => the `posts` array will contain the extended posts
    end

    sorts do
      # Allow sorting by these fields
      allowed_fields :name, :rank, :created_at

      # TODO: Describe custom sorts, default sorts, etc.
    end
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `rake console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rails_api_model.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


# Circonus::Api

This is a gem for interacting with the [Circonus API](http://circonus.com/resources/api).

## Installation

Add this line to your application's Gemfile:

    gem 'circonus-api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install circonus-api

## Usage

This gem provides a pretty simple interface to the Circonus API.

    # you can also set CIRCONUS_APP_NAME and CIRCONUS_API_TOKEN env vars and
    # not pass any arguments.
    api = Circonus::Api.new(app_name, api_token)

    # Each resource has the following methods, using Accounts as an example
    api.list_accounts
    api.show_account(id)
    api.create_account(json_data)
    api.update_account(id, json_data)
    api.delete_account(id)

    # There is also a method for the new Data Extraction api (in beta)
    # See https://login.circonus.com/resources/api/calls#data_extraction
    api.data_extraction(
      check_id: 12345,
      metric_name: 'orders_count',
      type: 'numeric',                 # Defaults to 'numeric', can also be 'text' or 'histogram'
      period: 300,                     # In seconds, defaults to 300. Not required for 'text' type
      start_time: 5.days.ago,          # Defaults to 1.day.ago, #to_i of this value must return a timestamp in seconds
      end_time: Time.now               # Defaults to Time.now,  #to_i of this value must return a timestamp in seconds
    )

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

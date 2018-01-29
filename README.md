# Circumstance

Circumstance allows you to register and evaluate setup blocks globally in your test suite. This is useful when you want to share big blocks of factory setups between tests.

## Example

Circumstance ships with helpers which you can include in your suite to have access to helpers like `load_circumstance`. In RSpec you can do the following:

```ruby
require 'circumstance'

RSpec.configure do |config|
  config.extend Circumstance::Helpers
end

Circumstance.define(:nuts_and_bolts) do
  let(:nuts_and_bolts) { create(:company, name: 'Nuts and Bolts') }
end

describe Company do
  load_circumstance :nuts_and_bolts
  
  it "has a name" do
    expect(nuts_and_bolts.name).to_not be_blank
  end
end
```

But you can also use it with other test suites.

```ruby
require 'circumstance'

class ActiveSupport::TestCase
  extend Circumstance::Helpers
end

Circumstance.define(:large_database) do
  before do
    @number_count = 10_000
    @number_count.times do
      ActiveRecord::Base.connection.execute("INSERT INTO numbers SET i = 1")
    end
  end
end

class NumberTest < ActiveSupport::TestCase
  load_circumstance :large_database

  test "counts all numbers" do
    assert_equal @number_count, Number.count
  end
end
```

You can nest circumstances within other circumstances to reuse base circumstances in others.

```ruby
    Circumstance.define(:company) do
      let(:company) { create(:company) }
    end

    Circumstance.define(:company_with_client) do
      load_circumstance :company
      let(:company_with_client) do
        company_with_client = company
        company_with_client.clients << create(:client)
        company_with_client 
      end
    end
```

The `load_circumstance` method tries to figure out if a circumstance was previously loaded so you won't load them multiple times for the same context. If you do need to evaluate a circumstance multiple times or directly on a test class for some reason, that's possible too.

```ruby
Circumstance.evaluate(ActiveRecord::Base, :setup_mock_responses)

describe PunyHuman do
  Circumstance.evaluate(self, :setup_mock_responses)
  Circumstance.evaluate(self, :setup_mock_responses)
end
```

## What's happening to my tests?

You can follow along with what Circumstance is doing with your circumstances by setting a different log level or changing the logger instance.

When logging to $stderr is good enough for you, just lower the log level.

    Circumstance.logger.level = Logger::DEBUG

Alternatively you can swap out the entire logger.

    Circumstance.logger = Rails.logger

## Contributing

Circumstance is really tiny so any changes have big consequences. Please create an issue before hacking away at the code to discuss your changes. Thanks!

1. Create a ticket on GitHub describing **what** you want to change and **why** you want to change it
2. Discuss the changes
3. Write the code
4. Request a pull
5. Bask in glory

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

# Scenario

Scenario allows you to register and evaluate setup block globally in your test suite. This is useful when you want to share big blocks of factory setups between tests.

## Example

Scenario ships with RSpec helpers.

    require 'scenario'

    RSpec.configure do |config|
      config.extend Scenario::Helpers
    end

    Scenario.define(:nuts_and_bolts) do
      let(:nuts_and_bolts) { create(:company, name: 'Nuts and Bolts')
    end

    describe Company do
      load_scenario :nuts_and_bolts
      
      it "has a name" do
        expect(nuts_and_bolts.name).to_not be_blank
      end
    end

But you can also use it with other test suites.

    require 'scenario'

    class ActiveSupport::TestCase
      extend Scenario::Helpers
    end

    Scenario.define(:large_database) do
      before do
        @number_count = 10_000
        @number_count.times do
          ActiveRecord::Base.connection.execute("INSERT INTO numbers SET i = 1")
        end
      end
    end

    class NumberTest < ActiveSupport::TestCase
      load_scenario :large_database

      test "counts all numbers" do
        assert_equal @number_count, Number.count
      end
    end

Nesting scenarios can be useful.

    Scenario.define(:company) do
      let(:company) { create(:company) }
    end

    Scenario.define(:company_with_client) do
      load_scenario :company
      let(:company_with_client) do
        company_with_client = company
        company_with_client.clients << create(:client)
        company_with_client 
      end
    end

The `load_scenario` method tries to figure out if a scenario was previously loaded so you don't load them multiple times for the same context. If you do need to evaluate a scenario multiple times or directly on a test class for some reason, that's possible too.

    Scenario.evaluate(ActiveRecord::Base, :setup_mock_responses)

    describe PunyHuman do
      Scenario.evaluate(self, :setup_mock_responses)  
      Scenario.evaluate(self, :setup_mock_responses)  
    end

## What's happening to my tests?

When logging to $stderr is good enough for you, just lower the log level.

    Scenario.logger.level = Logger::DEBUG

Alternatively you can swap out the entire logger.

    Scenario.logger = Rails.logger

## Contributing

Scenario is really tiny so any changes have big consequences. Please create an issue before hacking away at the code to discuss your changes. Thanks!

1. Create a ticket on GitHub describing **what** you want to change and **why** you want to change it
2. Discuss the changes
3. Write the code
4. Request a pull
5. Bask in glory

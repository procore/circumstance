require 'set'

class Scenario
  module Helpers
    # Returns a set of loaded scenarios for the current context
    def loaded_scenarios
      @loaded_scenarios ||= Set.new
    end

    # Evaluate a scenario in the current context
    def load_scenario(name)
      unless loaded_scenarios.include?(name)
        Scenario.evaluate(self, name)
        loaded_scenarios.add(name)
      end
    end
  end
end

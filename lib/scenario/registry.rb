class Scenario
  # A Registry holds scenarios by name. It's usually used through Scenario
  # class methods.
  class Registry
    class NotFound < StandardError
    end

    attr_accessor :scenarios

    def initialize
      reset
    end

    # Undefine all scenarios in this Registry
    def reset
      @scenarios = {}
    end

    # Find a scenario in this Registry by name
    def find(name)
      if scenario = scenarios[name]
        scenario
      else
        raise Scenario::Registry::NotFound, "Can't find the scenario `#{name}', did you define it?"
      end
    end

    # Define a scenario in this Registry
    def define(name, &block)
      @scenarios[name] = ::Scenario.new(name, block)
    end
  end
end

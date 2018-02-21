require 'set'

class Circumstance
  module Helpers
    # Returns a set of loaded circumstances for the current context
    def loaded_circumstances
      @loaded_circumstances ||= Set.new
    end

    # Evaluate a circumstance in the current context
    def load_circumstance(name)
      unless loaded_circumstances.include?(name)
        Circumstance.evaluate(self, name)
        loaded_circumstances.add(name)
      end
    end
  end
end

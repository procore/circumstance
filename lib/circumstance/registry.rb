class Circumstance
  # A Registry holds circumstances by name. It's usually used through Circumstance
  # class methods.
  class Registry
    class NotFound < StandardError
    end

    attr_accessor :circumstances

    def initialize
      reset
    end

    # Undefine all circumstances in this Registry
    def reset
      @circumstances = {}
    end

    # Find a circumstance in this Registry by name
    def find(name)
      if circumstance = circumstances[name]
        circumstance
      else
        raise Circumstance::Registry::NotFound, "Can't find the circumstance `#{name}', did you define it?"
      end
    end

    # Define a circumstance in this Registry
    def define(name, &block)
      @circumstances[name] = ::Circumstance.new(name, block)
    end
  end
end

require 'logger'

class Scenario
  autoload :Helpers,  'scenario/helpers'
  autoload :Registry, 'scenario/registry'
  autoload :VERSION,  'scenario/version'

  class << self
    # Logger used for debugging information
    attr_accessor :logger
    # A registry which keeps track of all the scenarios you've defined
    attr_accessor :registry
  end

  attr_reader :name

  self.logger = Logger.new($stderr)
  logger.level = Logger::ERROR

  self.registry = Scenario::Registry.new

  def initialize(name, block)
    @name, @block = name, block
  end

  # Returns Scenario.logger for convenience
  def logger
    self.class.logger
  end

  # Evaluate this scenario in the context
  def evaluate(context)
    logger.debug("Evaluating scenario #{@name}")
    if defined?(FactoryGirl)
      context.send(:include, FactoryGirl::Syntax::Methods)
    end
    context.instance_eval(&@block)
  end

  # Define a scenario on the global registry
  #
  #   Scenario.define(:blue_ocean_fishing) {}
  def self.define(name, &block)
    logger.debug("Defining scenario #{name}")
    registry.define(name, &block)
  end

  # Find a scenario on the global registry
  #
  #   Scenario.find(:blue_ocean_fishing) #=> Proc…
  def self.find(name)
    registry.find(name)
  end

  # Find and evaluate a scenario in a certain context. The context is usually
  # either a test class or spec context.
  #
  #   Scenario.evaluate(self, :blue_ocean_fishing)
  def self.evaluate(context, name)
    logger.debug("Loading scenario #{name}")
    scenario = find(name)
    scenario.evaluate(context)
    scenario
  end
end

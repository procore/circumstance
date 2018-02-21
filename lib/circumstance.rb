require 'logger'

class Circumstance
  autoload :Helpers,  'circumstance/helpers'
  autoload :Registry, 'circumstance/registry'
  autoload :VERSION,  'circumstance/version'

  class << self
    # Logger used for debugging information
    attr_accessor :logger
    # A registry which keeps track of all the circumstances you've defined
    attr_accessor :registry
  end

  attr_reader :name

  self.logger = Logger.new($stderr)
  logger.level = Logger::ERROR

  self.registry = Circumstance::Registry.new

  def initialize(name, block)
    @name, @block = name, block
  end

  # Returns Circumstance.logger for convenience
  def logger
    self.class.logger
  end

  # Evaluate this circumstance in the context
  def evaluate(context)
    logger.debug("Evaluating circumstance #{@name}")
    if defined?(FactoryGirl)
      context.send(:include, FactoryGirl::Syntax::Methods)
    end
    context.instance_eval(&@block)
  end

  # Define a circumstance on the global registry
  #
  #   Circumstance.define(:blue_ocean_fishing) {}
  def self.define(name, &block)
    logger.debug("Defining circumstance #{name}")
    registry.define(name, &block)
  end

  # Find a circumstance on the global registry
  #
  #   Circumstance.find(:blue_ocean_fishing) #=> Proc…
  def self.find(name)
    registry.find(name)
  end

  # Find and evaluate a circumstance in a certain context. The context is usually
  # either a test class or spec context.
  #
  #   Circumstance.evaluate(self, :blue_ocean_fishing)
  def self.evaluate(context, name)
    logger.debug("Loading circumstance #{name}")
    circumstance = find(name)
    circumstance.evaluate(context)
    circumstance
  end
end

require_relative 'helper'

describe Scenario do
  it "initializes with a name and block" do
    Scenario.new(
      :blue_ocean_fishing, Proc.new {}
    ).name.must_equal :blue_ocean_fishing
  end

  it "evaluates itself in a context" do
    klass = Class.new
    block = Proc.new do
      define_method :evaluated do
        true
      end
    end
    scenario = Scenario.new(:blue_ocean_fishing, block)
    scenario.evaluate(klass)
    klass.new.must_respond_to(:evaluated)
  end

  describe "class methods" do
    before do
      @registry = Scenario::Registry.new
      Scenario.registry = @registry
    end

    it "return a logger object" do
      Scenario.logger.must_be_kind_of(Logger)
    end

    it "defines a scenario on its registry" do
      Scenario.define(:blue_ocean_fishing) {}
      scenario = @registry.find(:blue_ocean_fishing)
      scenario.name.must_equal :blue_ocean_fishing
    end

    it "finds a scenario on its registry" do
      Scenario.define(:blue_ocean_fishing) {}
      Scenario.find(:blue_ocean_fishing).name.must_equal :blue_ocean_fishing
    end

    it "does not find unknown scenarios" do
      lambda do
        Scenario.find(:unknown)
      end.must_raise(Scenario::Registry::NotFound)
    end

    it "finds and evaluates a scenario" do
      klass = Class.new
      block = Proc.new do
        define_method :evaluated do
          true
        end
      end
      Scenario.define(:blue_ocean_fishing, &block)
      Scenario.evaluate(klass, :blue_ocean_fishing)
      klass.new.must_respond_to(:evaluated)
    end
  end
end

require_relative 'helper'

describe Circumstance do
  it "initializes with a name and block" do
    Circumstance.new(
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
    circumstance = Circumstance.new(:blue_ocean_fishing, block)
    circumstance.evaluate(klass)
    klass.new.must_respond_to(:evaluated)
  end

  describe "class methods" do
    before do
      @registry = Circumstance::Registry.new
      Circumstance.registry = @registry
    end

    it "return a logger object" do
      Circumstance.logger.must_be_kind_of(Logger)
    end

    it "defines a circumstance on its registry" do
      Circumstance.define(:blue_ocean_fishing) {}
      circumstance = @registry.find(:blue_ocean_fishing)
      circumstance.name.must_equal :blue_ocean_fishing
    end

    it "finds a circumstance on its registry" do
      Circumstance.define(:blue_ocean_fishing) {}
      Circumstance.find(:blue_ocean_fishing).name.must_equal :blue_ocean_fishing
    end

    it "does not find unknown circumstances" do
      lambda do
        Circumstance.find(:unknown)
      end.must_raise(Circumstance::Registry::NotFound)
    end

    it "finds and evaluates a circumstance" do
      klass = Class.new
      block = Proc.new do
        define_method :evaluated do
          true
        end
      end
      Circumstance.define(:blue_ocean_fishing, &block)
      Circumstance.evaluate(klass, :blue_ocean_fishing)
      klass.new.must_respond_to(:evaluated)
    end
  end
end

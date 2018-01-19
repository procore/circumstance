require_relative '../helper'

describe Scenario::Registry do
  it "initializes with empty scenarios" do
    Scenario::Registry.new.scenarios.must_be_empty
  end

  describe "with defined scenarios" do
    before do
      @registry = Scenario::Registry.new
      @registry.define(:red_ocean_fishing) do
        :red
      end
      @registry.define(:purple_ocean_fishing) do
        :purple
      end
    end

    it "finds a scenario by name" do
      @registry.find(:red_ocean_fishing).name.must_equal :red_ocean_fishing
    end

    it "raises an exception when it can't find a scenario" do
      lambda do
        @registry.find(:unknown)
      end.must_raise(Scenario::Registry::NotFound)
    end
  end
end

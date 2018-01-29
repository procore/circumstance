require_relative '../helper'

describe Circumstance::Registry do
  it "initializes with empty circumstances" do
    Circumstance::Registry.new.circumstances.must_be_empty
  end

  describe "with defined circumstances" do
    before do
      @registry = Circumstance::Registry.new
      @registry.define(:red_ocean_fishing) do
        :red
      end
      @registry.define(:purple_ocean_fishing) do
        :purple
      end
    end

    it "finds a circumstance by name" do
      @registry.find(:red_ocean_fishing).name.must_equal :red_ocean_fishing
    end

    it "raises an exception when it can't find a circumstance" do
      lambda do
        @registry.find(:unknown)
      end.must_raise(Circumstance::Registry::NotFound)
    end
  end
end

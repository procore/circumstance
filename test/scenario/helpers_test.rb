require_relative '../helper'

Scenario.define(:black_ocean_fishing) do
  define_method(:black) do
    true
  end
end

Scenario.define(:green_ocean_fishing) do
  load_scenario :black_ocean_fishing

  define_method(:green) do
    true
  end
end

describe Scenario::Helpers do
  extend Scenario::Helpers

  load_scenario :green_ocean_fishing

  it "loads a scenario" do
    must_respond_to(:black)
    must_respond_to(:green)
  end

  it "returns loaded scenarios" do
    self.class.loaded_scenarios.must_equal Set.new([
      :black_ocean_fishing,
      :green_ocean_fishing
    ])
  end
end

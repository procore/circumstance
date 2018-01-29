require_relative '../helper'

Circumstance.define(:black_ocean_fishing) do
  define_method(:black) do
    true
  end
end

Circumstance.define(:green_ocean_fishing) do
  load_circumstance :black_ocean_fishing

  define_method(:green) do
    true
  end
end

describe Circumstance::Helpers do
  extend Circumstance::Helpers

  load_circumstance :green_ocean_fishing

  it "loads a circumstance" do
    must_respond_to(:black)
    must_respond_to(:green)
  end

  it "returns loaded circumstances" do
    self.class.loaded_circumstances.must_equal Set.new([
      :black_ocean_fishing,
      :green_ocean_fishing
    ])
  end
end

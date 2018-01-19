require_relative '../helper'
# require 'rubygems'

describe Scenario::VERSION do
  before do
    @version = Gem::Version.new(Scenario::VERSION)
  end

  it "returns a usable version string" do
    @version.must_respond_to(:bump)
  end
end

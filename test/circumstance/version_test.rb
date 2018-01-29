require_relative '../helper'
# require 'rubygems'

describe Circumstance::VERSION do
  before do
    @version = Gem::Version.new(Circumstance::VERSION)
  end

  it "returns a usable version string" do
    @version.must_respond_to(:bump)
  end
end

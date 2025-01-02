require "rspec"

RSpec.configure do |config|
  config.before(:all) do
    Excon.defaults[:mock] = true
  end

  config.after(:each) do
    Excon.stubs.clear
  end
end

RSpec::Matchers.define :match_date do |expected|
  match do |actual|
    expect(expected.strftime("%d-%m-%Y")).to eq(actual.strftime("%d-%m-%Y"))
  end
end

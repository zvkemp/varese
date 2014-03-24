require 'minitest/autorun'
require 'minitest/pride'
require 'vcr'
require 'varese'
require 'rr'

VCR.configure do |c|
  c.cassette_library_dir = "fixtures/cassettes"
  c.hook_into :webmock
end

API_KEY = File.read('fixtures/api_key').strip




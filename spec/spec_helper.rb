require 'minitest/autorun'
require 'minitest/pride'
require 'vcr'
require 'varese'
require 'rr'
require 'digest'

VCR.configure do |c|
  c.cassette_library_dir = "fixtures/cassettes"
  c.hook_into :webmock
end

module Varese
  class MockAccessToken
    API_KEY = File.read('fixtures/api_key').strip

    def initialize(*)
    end

    def key
      API_KEY
    end

    def get(*args)
      VCR.use_cassette("get_#{digest_get_args(*args)}") do
        Varese::AccessToken.new(key).get(*args)
      end
    end

    private

      def digest_get_args(*args)
        Digest::SHA1.hexdigest(args.map(&:to_s).join(""))[0..9]
      end
  end
end


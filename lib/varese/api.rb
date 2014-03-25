require 'forwardable'
require 'net/http'

module Varese
  class AccessToken
    attr_reader :key

    def initialize(key)
      @key = key
    end

    def get(url)
      Net::HTTP.get_response(URI.parse url)
    end
  end

  class API
    extend Forwardable
    attr_reader :access_token, :url_defaults

    def initialize(access_token, url_defaults = {})
      # all requests are routed through the access token
      @access_token = access_token
      @url_defaults = url_defaults
    end

    def get(options = {})
      access_token.get(url(options)).response
    end

    private

      def url(options)
        Varese::URLBuilder.new(url_defaults.merge(options).merge({ key: access_token.key }))
      end
  end
end

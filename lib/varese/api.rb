require 'forwardable'
module Varese
  class AccessToken
    attr_reader :key

    def initialize(key)
      @key = key
    end

    def get(url)
    end
  end

  class API
    extend Forwardable
    def initialize(access_token)
      # all requests are routed through the access token
      @access_token = access_token
    end
  end
end

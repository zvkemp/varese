require 'forwardable'
require 'net/http'
require 'json'
require 'open-uri' 

module Varese
  class AccessToken
    attr_reader :key

    def initialize(key)
      @key = key
    end

    def get(url)
      #Net::HTTP.get_response(URI.parse url)
      open(URI.parse(url)).read
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
      json { access_token.get(url(options)) }
    end

    def datasets
      raw_datasets.map {|ds| Varese::CensusData::Dataset.new(ds, self) }
    end


    private
      def raw_datasets
        get(Varese::URLBuilder.new.dataset_meta_url)
      end

      def json(&block)
        JSON.parse yield
      end

      def url(options)
        return options if options.is_a? String
        Varese::URLBuilder.new(url_defaults.merge(options).merge({ key: access_token.key }))
      end
  end
end

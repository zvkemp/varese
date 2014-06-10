require 'forwardable'
require 'net/http'
require 'json'
require 'open-uri'

module Varese
  class AccessToken
    attr_reader :key

    def initialize(key = default_key)
      @key = key
    end

    def get(url)
      open(URI.parse(url)).read
    end

    private

    # Looks for a file at fixtures/api_key
    def default_key
      ENV.fetch("VARESE_KEY"){ File.read('fixtures/api_key').strip }
    end
  end

  class API
    extend Forwardable
    attr_reader :access_token, :url_defaults
    def_delegators :access_token, :key

    def initialize(access_token = default_access_token, url_defaults = {})
      # all requests are routed through the access token
      @access_token = access_token
      @url_defaults = url_defaults
    end

    def get(options = {})
      json { access_token.get(url(options)) }
    end

    # Return the first matching dataset
    # Ex: api.dataset(vintage: 2012, name: "acs5")
    def dataset(options = {})
      dataset_collection.find(options)
    end

    # Return an array of matching datasets
    # Ex: api.datasets(:profile? => false, vintage 2012) #=> [ # ... 3 matching acs datasets ]
    def datasets(options = {})
      dataset_collection.where(options)
    end

    private

    def dataset_collection
      @dataset_collection ||= DatasetCollection.new(_datasets)
    end

    def _datasets
      raw_datasets.map { |ds| Varese::CensusData::Dataset.new(ds, self) }
    end

    def raw_datasets
      get(Varese::URLBuilder.new.dataset_meta_url)
    end

    def json
      JSON.parse yield
    end

    def url(options)
      return options if options.is_a? String
      Varese::URLBuilder.new(url_defaults.merge(options).merge({ key: key }))
    end

    def default_access_token
      Varese::AccessToken.new
    end

    class DatasetCollection
      attr_reader :datasets
      include Enumerable

      def initialize(dataset_array)
        @datasets = Array(dataset_array)
      end

      def each(&block)
        to_a.each(&block)
      end

      alias_method :to_a, :datasets
      alias_method :to_ary, :datasets

      # returns an array of matching datasets
      def where(options = {})
        match_attributes_using :select, options
      end

      # returns a single dataset (the first result from `where`)
      def find(options = {})
        match_attributes_using :detect, options
      end

      private

      def match_attributes_using(method_sym, options)
        datasets.send(method_sym) do |dataset|
          options.inject(true) do |bool, (key, value)|
            bool ? dataset.send(key) == value : bool
          end
        end
      end
    end
  end
end

module Varese
  class URLBuilder
    attr_reader :year, :dataset, :query

    def initialize(options = {})
      @query = options.delete(:query)
      @key = options.delete(:key)
      options.each do |key, value|
        send("builder_option_#{key}", value)
      end
    end

    def to_url
      validate_and_build_url
    end

    def to_s
      to_url
    end

    def to_str
      to_url
    end

    def dataset_meta_url
      metadata_url
    end


  private

    def validate_and_build_url
      raise InvalidURLError unless dataset && year
      build_url
    end

    def metadata_url
      "#{base_url}/data.json"
    end

    def build_url
      "#{base_url}/data/#{year}/#{dataset}".tap do |str|
        str << "?#{query_string}" if query
      end
    end

    def builder_option_dataset(n)
      @dataset = "#{n}"
    end

    def builder_option_acs(n)
      @dataset = "acs#{n}"
    end

    def builder_option_year(n)
      @year = n
    end
    alias_method :builder_option_vintage, :builder_option_year

    def builder_option_sf(n)
      @dataset = "sf#{n}"
    end

    def base_url
      'http://api.census.gov'
    end

    def query_string
      (query || {}).merge(api_key_hash).map do |key, value|
        "#{key}=#{value}"
      end.join("&")
    end

    def api_key_hash
      {}.tap do |hash|
        hash[:key] = @key if @key
      end
    end
  end

  class InvalidURLError < StandardError
  end

  class GeographicQuery
    HIERARCHY = [
      'block group',
      'tract',
      'county',
      'state'
    ]

    attr_reader :options

    def initialize(options)
      @options = options
    end

    def apply_to(hash)
      hash.merge!(to_hash)
    end

    def to_hash
      { for: for_option, in: in_option }.select {|k,v| v }
    end

    def to_str
      raise GeographicQueryError
    end

    private

    def for_option
      f = HIERARCHY.find {|h| options[h] }
      "#{f}:#{options[f]}"
    end

    def in_option
    end
  end

  class GeographicQueryError < StandardError
  end
end

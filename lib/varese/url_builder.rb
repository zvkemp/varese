module Varese
  class URLBuilder
    attr_reader :year, :dataset, :query

    def initialize(options)
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

    private

      def validate_and_build_url
        raise InvalidURLError unless dataset && year
        return build_url
      end

      def build_url
        str = "#{base_url}/data/#{year}/#{dataset}?#{query_string}"
        str << "?#{query_string}" if query
        str
      end

      def builder_option_acs(n)
        @dataset = "acs#{n}"
      end

      def builder_option_year(n)
        @year = n
      end

      def builder_option_sf(n)
        @dataset = "sf#{n}"
      end

      def base_url
        'http://api.census.gov'
      end

      def query_string
        (query || {}).merge({ key: @key }).map do |key, value|
          "#{key}=#{value}"
        end.join("&")
      end
  end

  class InvalidURLError < StandardError
  end
end

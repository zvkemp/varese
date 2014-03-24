module Varese
  class URLBuilder
    attr_reader :year, :dataset, :query

    def initialize(options)
      @query = options.delete(:query)
      options.each do |key, value|
        send("builder_option_#{key}", value)
      end
    end

    def to_url
      "#{base_url}/data/#{year}/#{dataset}"
    end

    def to_s
      to_url
    end

    def to_str
      to_url
    end

    def validate

    end


    private

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
  end
end

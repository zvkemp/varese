module Varese
  module CensusData
    # TODO: more attributes!
    GEOGRAPHIC_ATTRIBUTES = %w[state county tract]

    class DatasetQueryResponse

      class << self
        def merge(*responses)
          MergeQueryResponses.new(*responses).to_response
        end
      end

      attr_reader :header, :body
      def initialize(header, *body)
        @header, @body = header, body
      end

      def to_a
        body.map {|row| Hash[header.zip(row)] }
      end

      def group_by_attributes(attribute_map = Hash.new {|_, k| k })
        GroupQueryResponse.new(self, attribute_map).to_hash
      end
      
      def rollup(*attributes, options)
        Rollup.new(self, *attributes, options)
      end

      private


    end


    class GroupQueryResponse
      attr_reader :response, :attr_map
      def initialize(response, attr_map)
        @response = response
        @attr_map = attr_map
      end

      def to_hash
        response.to_a.each_with_object({}) do |row, hash|
          hash[geography_hash_for(row)] = map_row_to_attributes(row)
        end
      end

      private

      def geography_hash_for(row)
        Hash[GEOGRAPHIC_ATTRIBUTES.zip(row.values_at(*GEOGRAPHIC_ATTRIBUTES))]
      end

      def map_row_to_attributes(row)
        row.each_with_object(defaulting_hash) do |(k, v), hash|
          inject_value_into_hash(hash, v, *Array(attr_map[k]))
        end
      end

      def inject_value_into_hash(hash, value, key = nil, *keys)
        return unless key
        if keys.any?
          inject_value_into_hash(hash[key], value, *keys)
        else
          # turn it into an integer value
          hash[key] = ((v = hash[key]) == {} ? 0 : v) + Integer(value)
        end
      end

      def defaulting_hash
        Hash.new {|h, k| h[k] = Hash.new(&h.default_proc) }
      end
    end

    # There is a limit to how many variables can be fetched in a single request.
    # MergeQueryResponses (also available as DatasetQueryResponse::merge) will
    # combine results into a single response object.
    class MergeQueryResponses
      attr_reader :responses
      def initialize(*responses)
        @responses = responses
      end

      def to_response
        DatasetQueryResponse.new(merged_headers, *rows)
      end

      private

      def merged_headers
        @merged_headers ||= response_headers.inject {|fields, header| 
          fields + header 
        }.reverse.uniq.reverse # keep them in the right order (probably not necessary)
      end

      def response_headers
        responses.map(&:header)
      end

      def common_header_fields
        @common_header_fields ||= response_headers.inject {|fields, header| fields & header }
      end

      def as_hash
        @as_hash ||= Hash.new {|h,k| h[k] = {} }.tap do |hash|
          responses.map(&:to_a).each do |response|
            response.each do |row|
              hash[row.values_at(*common_header_fields)].merge!(row)
            end
          end
        end
      end

      def rows
        @rows ||= [].tap do |rows_array|
          as_hash.each do |_, row_hash|
            rows_array << [].tap do |row|
              merged_headers.each do |header|
                row << row_hash[header]
              end
            end
          end
        end
      end
    end
  end
end

__END__



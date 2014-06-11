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

      # generates a nested hash based on the attribute map
      #   attr_map = {
      #     "B01001_003E"=>["male", "Under 5 years"], 
      #     "B01001_003M"=>["female", "Under 5 years"],
      #     ...
      #   }
      # data.group_by_attributes(attr_map)
      # # => {{ "state" => "06", "county" => "001" } => { "male" => { "under 5 years" => 2048 } ... }
      def group_by_attributes(attribute_map = Hash.new {|_, k| k })
        GroupQueryResponse.new(self, attribute_map).to_hash
      end

      # generates a flat mapped array of hashes
      # attr_map = {
      #   "B01001_003E" => { 268 => 1, 270 => 2 }
      #
      def flatten_by_attributes(attribute_map, count_key = :count)
        FlatQueryResponse.new(self, attribute_map).to_a(count_key)
      end
      
      def rollup(*attributes, options)
        Rollup.new(self, *attributes, options)
      end

      private


    end

    class QueryResponseRollup
      attr_reader :response, :attr_map
      def initialize(response, attr_map)
        @response = response
        @attr_map = attr_map
      end
    end

    class FlatQueryResponse < QueryResponseRollup
      def to_a(count_key = :count)
        response.to_a.each_with_object({}) do |row, hash|
          row.each do |var, count_str|
            if (key = attr_map[var])
              hash[key] ||= key.merge({ count_key => 0 })
              hash[key][:count] += Integer(count_str)
            end
          end
        end.values
      end
    end

    # Used by DatasetQueryResponse#group_by_attributes to roll raw response tables
    # into hashes. Variables are summed where appropriate.
    class GroupQueryResponse < QueryResponseRollup
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



module Varese
  module CensusData
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
      
      def rollup(*attributes, options)
        Rollup.new(self, *attributes, options)
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



module Varese
  module CensusData

    class GeographyMeta < Meta
      attr_reader :geographies
      def initialize(raw)
        @geographies = {}.tap do |hash|
          raw['fips'].each do |geo|
            hash[geo['name']] = Array(geo['requires'])
          end
        end
      end
    end
  end
end

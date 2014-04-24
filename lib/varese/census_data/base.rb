module Varese
  module CensusData
    class Base
      attr_reader :raw
      def initialize(raw)
        @raw = raw
      end

      class << self
        def data_attribute(sym, data_key, *transformation_methods)
          define_method sym do 
            transformation_methods.inject(raw[data_key]) do |data, transformation_sym|
              data.send transformation_sym
            end
          end
        end

        def meta_attribute(sym, data_key, *transformation_methods)
          define_method sym do
            transformation_methods.inject(meta.raw[data_key]) do |data, transformation_sym|
              data.send transformation_sym
            end
          end
        end
      end
    end
  end
end

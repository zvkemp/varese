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

        # makes the raw metadata available as methods, sans any odd prefixes or
        # other vagaries.
        #
        # Usage:
        # meta_attribute :vintage, "c_vintage", :to_i
        # meta_attribute :name, "c_dataset", ->(v){ v.join(" ") }
        #
        # Also see census_data/dataset.rb:
        #
        def meta_attribute(sym, data_key, *transformation_methods)
          define_method sym do
            transformation_methods.inject(meta.raw[data_key]) do |data, transformation|
              transformation.to_proc[data]
            end
          end
        end
      end
    end
  end
end

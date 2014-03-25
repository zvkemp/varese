module Varese
  module CensusData
    class Base
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

      def raw
        @raw
      end
    end

    class Meta < Base
    end

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

    class VariableMetaSet < Meta
      attr_reader :by_guid, :by_label, :by_concept
      def initialize(raw)
        @by_guid    = {}
        @by_label   = Hash.new {|h,k| h[k] = [] }
        @by_concept = Hash.new {|h,k| h[k] = [] }

        raw["variables"].each do |guid, data|
          v = VariableMeta.new(guid, data)
          by_guid[v.guid] = v
          by_label[v.label] << v if v.label
          by_concept[v.concept] << v if v.concept
        end
      end
    end

    class VariableMeta < Meta
      attr_reader :guid, :label, :concept

      def initialize(guid, data)
        @guid = guid
        @label = data["label"]
        @concept = data["concept"]
      end
    end

    class Dataset < Base
      attr_reader :meta, :api
      def initialize(raw, api)
        @meta = Meta.new(raw)
        @api = api
      end

      meta_attribute :vintage     , "c_vintage"
      meta_attribute :name        , "c_dataset"     , :first
      meta_attribute :aggregate?  , "c_isAggregate"
      meta_attribute :description , "description"
      meta_attribute :identifier  , "identifier"
      meta_attribute :spatial     , "spatial"
      meta_attribute :temporal    , "temporal"      , :to_i

      def link(sym)
        meta.raw["c_#{sym}Link"]
      end

      def geography
        @geography ||= auxilliary_metadata(:geography, GeographyMeta)
      end
      
      def variables
        @variables ||= auxilliary_metadata(:variables, VariableMetaSet)
      end

      def tags
      end

      private

        def auxilliary_metadata(key, klass = Meta)
          klass.new(api.get(link(key)))
        end
    end
  end
end


module Varese
  module CensusData
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

      def inspect
        DatasetInspector.new(self).present
      end

      private

        def auxilliary_metadata(key, klass = Meta)
          klass.new(api.get(link(key)))
        end

    end

    class DatasetInspector
      attr_reader :dataset
      def initialize(dataset)
        @dataset = dataset
      end

      def present
        "#{head} #{variables} #{tail}"
      end

      private

        def head
          "#<Varese::CensusData::Dataset"
        end

        def variables
          "".tap do |str|
            dataset.instance_variables.each do |ivar|
              str << "#{ivar}="
              str << variable(ivar)
              str << " "
            end
          end
        end

        def variable(variable_name)
          dataset.instance_variable_get(variable_name).tap do |var|
            if abbreviate?(variable_name)
              return "#<#{var.class.to_s} ...>"
            else
              return var.inspect
            end
          end
        end

        def tail
          ">"
        end

        def abbreviate?(variable_name)
          {
            :@api => false,
            :@meta => false
          }.fetch(variable_name, true)
        end
    end
  end
end


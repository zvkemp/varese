module Varese
  module CensusData
    class Dataset < Base
      attr_reader :meta, :api
      def initialize(raw, api)
        @meta = Meta.new(raw)
        @api = api
      end

      meta_attribute :vintage     , "c_vintage"
      meta_attribute :name        , "c_dataset"     , ->(v){ v.join(" ") }
      meta_attribute :aggregate?  , "c_isAggregate"
      meta_attribute :description , "description"
      meta_attribute :identifier  , "identifier"
      meta_attribute :spatial     , "spatial"
      meta_attribute :temporal    , "temporal"      , :to_i

      def link(sym)
        meta.raw["c_#{sym}Link"]
      end

      def links
        @links ||= %i[geography variables tags examples documentation].each_with_object({}) do |sym, hash|
          hash[sym] = link(sym)
        end
      end

      def geography
        @geography ||= auxilliary_metadata(:geography, GeographyMeta)
      end
      
      def variables
        @variables ||= auxilliary_metadata(:variables, VariableMetaSet)
      end

      def examples
        @examples ||= auxilliary_metadata(:examples)
      end

      def documentation
        @documentation ||= auxilliary_metadata(:documentation)
      end

      def tags
      end

      def inspect
        "#<Varese::CensusData::Dataset #{title}>"

        #DatasetInspector.new(self).present
      end

      def profile?
        name.include?("profile")
      end

      def query(options)
        transform_query_options(options)
      end

      private

      def transform_query_options(options)
        {}.tap do |query_options|
          query_options[:get] = options.fetch(:datapoint){ options.fetch(:get) }
          query_options[:geography] = ""
        end
      end

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


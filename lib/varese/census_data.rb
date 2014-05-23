module Varese
  module CensusData
    require 'varese/census_data/base'
    require 'varese/census_data/meta'
    require 'varese/census_data/geography_meta'
    require 'varese/census_data/variable_meta'
    require 'varese/census_data/variable_meta_set'
    require 'varese/census_data/concept_meta'
    require 'varese/census_data/dataset'
    require 'varese/census_data/dataset_query_response'

    MAX_VARS_PER_REQUEST = 50
  end
end


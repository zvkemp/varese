require 'csv'
module Varese
  module CensusData
    module CSV
      class SequenceTableIndex
        attr_reader :raw_data, :header
        def initialize(filepath)
          @raw_data = ::CSV.parse(force_encoded_file(filepath))
          @header   = @raw_data.shift
        end

        def parsed
          @parsed ||= parse_raw_data
        end

        private

        def force_encoded_file(filepath)
          File.read(filepath).force_encoding('BINARY').encode('UTF-8', :invalid => :replace, :undef => :replace, :replace => '?')
        end

          #|file_id, table_id, sequence_number, line_number, start_position, 
          #total_cells_in_table, total_cells_in_sequence, table_title, subject_area|
        def parse_raw_data
          data_slices.to_a
        end

        def data_slices
          @data_slices ||= raw_data.slice_before {|_, _, _, _, _, _, _, _, subject_area| !subject_area.nil? }
        end
      end
    end
  end
end

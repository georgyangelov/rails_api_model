module RailsApiModel
  module Filters
    # TODO: Check whether the ActiveRecord model has the specified field
    class Field < Base
      def initialize(field_name)
        @key = field_name
      end

      def apply_scope(relation, params)
        relevant_parameters = params.select { |param| params.split(':'.freeze).first == @key }

        relevant_parameters.reduce(relation) do |relation, (param, value)|
          apply_single_filter relation, param, value
        end
      end

      private

      def apply_single_filter(relation, param, value)
        modifier = param.split(':'.freeze).last
        column   = activerecord_model.arel_table[@key]

        relation.where arel_filter(modifier, transform_type(value))
      end

      def arel_filter(modifier, value)
        case modifier
        when 'eq'.freeze, nil then column.eq(value)
        when 'not'.freeze     then column.not_eq(value)
        when 'lt'.freeze      then column.lt(value)
        when 'lte'.freeze     then column.lteq(value)
        when 'gt'.freeze      then column.gt(value)
        when 'gte'.freeze     then column.gteq(value)
        # TODO: Handle this error via Rails and send 400
        else raise FilterError.new("Invalid modifier #{modifier}")
        end
      end

      def transform_type(value)
        column_type = activerecord_model.columns_hash[filter_key].type

        # TODO: Verify all of these types actually exist
        # TODO: Support range queries with some syntax.
        #       Maybe `start_time:gt=2015-11-03&start_time:lt=2015-12-19`
        # TODO: Support enum values as strings
        # TODO: Support `LIKE` queries?
        case column_type
        when :string, :text then value
        # TODO: Add validation and raise error instead of silently discarding non-numbers
        when :primary_key, :integer then value.to_i
        when :float, :decimal then value.to_f
        # TODO: Smarter date parsing. Passing the date `2015-11-03` should actually
        #       make a range query `column >= 2015-11-03 and column < 2015-11-04`.
        # TODO: Catch ArgumentError for invalid dates and reraise as Rails error
        when :datetime then Time.zone.parse(value)
        when :boolean then to_boolean(value)
        else raise "Unsupported filter on column type #{column_type}"
        end
      end

      def to_boolean(value)
        case value
        # `true` is supported for arguments passed during testing
        when true, 'true'.freeze, 't'.freeze, '1'.freeze, 'y'.freeze, 'yes'.freeze then true
        else false
        end
      end
    end
  end
end

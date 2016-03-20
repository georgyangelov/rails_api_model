module RailsApiModel
  module Filters
    class FieldFilter
      def initialize(fields)
        @fields = fields.map(&:to_s)
      end

      def call(scope, context)
        context.params.reduce(scope) do |scope, (raw_key, raw_value)|
          key, modifier = raw_key.split(':'.freeze, 2)

          next scope unless @fields.include? key

          scope.where(arel_filter(context.ar_model, key, modifier, raw_value))
        end
      end

      private

      def arel_filter(ar_model, key, modifier, raw_value)
        column      = ar_model.arel_table[key]
        column_type = ar_model.columns_hash[key].type
        value       = transform_type(column_type, raw_value)

        case modifier
        when 'eq'.freeze, nil then column.eq(value)
        when 'not'.freeze     then column.not_eq(value)
        when 'lt'.freeze      then column.lt(value)
        when 'lte'.freeze     then column.lteq(value)
        when 'gt'.freeze      then column.gt(value)
        when 'gte'.freeze     then column.gteq(value)
        # TODO: Handle this error via Rails and send 400
        else raise "Invalid modifier #{modifier}"
        end
      end

      def transform_type(column_type, value)
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
        when :boolean then TRUTHY_VALUES.include? value
        else raise "Unsupported filter on column type #{column_type}"
        end
      end
    end
  end
end

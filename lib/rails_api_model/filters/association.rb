module RailsApiModel
  module Filters
    class Field < Base
      def initialize(association_name)
        @association = association_name
      end

      def apply_scope(relation, request)
        apply_single_filter_for_params(request.params) do |param|
          params.split(/\.:/).first == @key
        end
      end

      private

      def apply_single_filter(relation, param, value)
        modifier = param.split(':'.freeze).last
        column   = activerecord_model.arel_table[@key]

        relation.where arel_filter(modifier, transform_type(value))
      end
    end
  end
end

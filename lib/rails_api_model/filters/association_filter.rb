module RailsApiModel
  module Filters
    class AssociationFilter
      def initialize(mappings)
        @mappings = mappings.stringify_keys
      end

      def call(scope, context)
        params_per_association(context.params).reduce(scope) do |scope, (association, params)|
          call_for_association(scope, context, association, params)
        end
      end

      private

      def call_for_association(scope, context, association, params)
        inner_model   = @mappings.fetch(association)
        inner_context = InnerFilterContext.new(inner_model, params)
        inner_scope   = inner_model.filter_with_context(inner_context)

        scope.joins(association.to_sym).merge(inner_scope)
      end

      def params_per_association(params)
        params.group_by { |key, _| association_name_from_key(key) }
              .select   { |association, _| @mappings.key? association }
              .map      { |association, params| [association, strip_association_name(params)] }
              .to_h
      end

      def association_name_from_key(key)
        return unless key.include? '.'.freeze

        key.split('.'.freeze, 2).first
      end

      def strip_association_name(params)
        params.map { |key, value| [key.split('.'.freeze, 2).last, value] }.to_h
      end
    end
  end
end

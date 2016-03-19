module RailsApiModel
  module Filters
    class Association < Base
      def initialize(api_model, key, associated_model)
        super api_model

        @key = key.to_s
        @associated_model = associated_model
      end

      def apply_scope(relation, request)
        params_for_association(request.params).each do |key, value|

        end
      end

      private

      def params_for_association(params)
        # TODO: What happens if the key does not contain `.`?
        params.select { |key, _| key.split('.', 2).first == @key }
      end
    end
  end
end

module RailsApiModel
  module ModelApi
    extend ActiveSupport::Concern

    module ClassMethods
      def load(request)
        filters.reduce(ar_model.all) do |relation, filter|
          filter.apply_scope(relation, request)
        end
      end
    end
  end
end

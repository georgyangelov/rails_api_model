module RailsApiModel
  module ModelApi
    extend ActiveSupport::Concern

    module ClassMethods
      def load(params, base_relation=ar_model.all)
        # active_params = params.select { |key, _| filters[key] }
        #
        # active_params.reduce(base_relation) do |relation, (key, value)|
        #   filters[key].apply_scope(relation, key, value)
        # end
      end
    end
  end
end

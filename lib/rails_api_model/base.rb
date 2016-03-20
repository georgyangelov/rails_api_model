module RailsApiModel
  class Base
    class_attribute :ar_model
    class_attribute :filters

    self.filters = []

    def self.active_record_model(ar_model)
      self.ar_model = ar_model
    end

    def self.filter(scope = ar_model.all, request)
      context = FilterContext.new(self, request)

      filter_with_context(scope, context)
    end

    def self.filter_with_context(scope = ar_model.all, context)
      filters.reduce(scope) do |scope, filter|
        filter.call(scope, context)
      end
    end

    def self.filter_with(filter)
      self.filters = filters + [filter]
    end

    ActiveSupport.run_load_hooks(:rails_api_model, self)
  end
end

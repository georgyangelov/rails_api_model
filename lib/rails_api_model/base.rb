module RailsApiModel
  class Base
    class_attribute :ar_model

    include Filters

    include Builders::Filters

    include ModelApi

    ActiveSupport.run_load_hooks(:rails_api_model, self)
  end
end

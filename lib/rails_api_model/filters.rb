require 'rails_api_model/filters/base_filter'
require 'rails_api_model/filters/field'

module RailsApiModel
  module Filters
    extend ActiveSupport::Concern

    included do
      class_attribute :filters
      self.filters = []
    end

    def self.add_filters(model, filters)
      model.filters += Array.wrap(filters)
    end
  end
end

require 'rails_api_model/filters/base'
require 'rails_api_model/filters/field'

module RailsApiModel
  module Filters
    extend ActiveSupport::Concern

    included do
      class_attribute :filters
      self.filters = []
    end
  end
end

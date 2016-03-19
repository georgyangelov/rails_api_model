require 'rails_api_model/filters/base'
require 'rails_api_model/filters/field'
require 'rails_api_model/filters/association'

module RailsApiModel
  module Filters
    extend ActiveSupport::Concern

    included do
      class_attribute :filters
      self.filters = []
    end
  end
end

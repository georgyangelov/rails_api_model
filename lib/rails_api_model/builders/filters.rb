module RailsApiModel
  module Builders
    module Filters
      extend ActiveSupport::Concern

      module ClassMethods
        private

        def active_record_model(model)
          unless model < ActiveRecord::Base
            raise ArgumentError, 'The specified class is not an ActiveRecord model'
          end

          self.ar_model = model
        end

        def filter_with(filter)
          self.filters << filter
        end

        def allow_fields(*field_names)
          raise ArgumentError, 'You need to specify at least one field name' if field_names.empty?

          field_names
          .map  { |field_name| ::Filters::Field.new(self, field_name) }
          .each { |filter| filter_with filter }
        end
      end
    end
  end
end

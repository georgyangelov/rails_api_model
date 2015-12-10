module RailsApiModel
  module Builders
    module Filters
      module AllowFields
        extend ActiveSupport::Concern

        module ClassMethods
          def allow_fields(*field_names)
            raise ArgumentError, 'You need to specify at least one field name' if field_names.empty?

            filters = field_names.map { |field_name| ::Filters::Field.new(self, field_name) }

            ::Filters.add_filters(self, filters)
          end
        end
      end
    end
  end
end

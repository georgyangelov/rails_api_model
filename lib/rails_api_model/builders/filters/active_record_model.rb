module RailsApiModel
  module Builders
    module Filters
      module ActiveRecordModel
        extend ActiveSupport::Concern

        module ClassMethods
          def active_record_model(model)
            unless model < ActiveRecord::Base
              raise ArgumentError, 'The specified class is not an ActiveRecord model'
            end

            self.ar_model = model
          end
        end
      end
    end
  end
end

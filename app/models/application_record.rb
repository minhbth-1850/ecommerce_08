class ApplicationRecord < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  require "carrierwave/orm/activerecord"
  self.abstract_class = true
end

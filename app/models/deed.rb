class Deed < ApplicationRecord
  validates :name, presence: true
end

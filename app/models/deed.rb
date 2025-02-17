class Deed < ApplicationRecord
  has_many :deeds
  belongs_to :user
end

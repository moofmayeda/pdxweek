class Vote < ApplicationRecord
  belongs_to :restaurant
  scope :up,    -> { where up: true }
  scope :down,  -> { where up: false }
end

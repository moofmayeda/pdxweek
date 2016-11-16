class Vote < ApplicationRecord
  belongs_to :dish
  has_one :restaurant, through: :dish

  scope :up,    -> { where up: true }
  scope :down,  -> { where up: false }
  scope :by,    -> (user_id=nil) { where user_id: user_id }
end

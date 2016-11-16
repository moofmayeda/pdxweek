class Dish < ApplicationRecord
  has_many :upvotes,    -> { where up: true }, class_name: "Vote"
  has_many :downvotes,  -> { where up: false }, class_name: "Vote"
  has_many :votes, dependent: :destroy
  belongs_to :restaurant
end

class Restaurant < ApplicationRecord
  has_many :upvotes,    -> { where up: true }, class_name: "Vote"
  has_many :downvotes,  -> { where up: false }, class_name: "Vote"
  has_many :votes, dependent: :destroy

  validates :name, uniqueness: true

  scope :top, -> (number=nil) {
    select('restaurants.*', '(SUM(CASE WHEN votes.up = true THEN 1 ELSE 0 END) / COUNT(votes.id)) AS percent_total')
    .joins(:votes)
    .order('percent_total DESC')
    .group('restaurants.id')
    .limit(number) }
end

class Dish < ApplicationRecord
  has_many :upvotes,    -> { where up: true }, class_name: "Vote"
  has_many :downvotes,  -> { where up: false }, class_name: "Vote"
  has_many :votes, dependent: :destroy
  belongs_to :restaurant

  scope :category, -> (category=nil) { where(category: category) }
  scope :year, -> (year=nil) { where(year: year) }

  scope :top, -> (number=nil) {
    select('dishes.*', 'COUNT(votes.id) AS votes', '(SUM(CASE WHEN votes.up = true THEN 1.0 ELSE 0 END) / NULLIF(COUNT(votes.id), 0)) AS percent_total')
    .left_outer_joins(:votes)
    .order('percent_total DESC NULLS LAST, votes DESC')
    .group('dishes.id')
    .limit(number) }
  scope :bottom, -> (number=nil) {
    select('dishes.*', 'COUNT(votes.id) AS votes', '(SUM(CASE WHEN votes.up = true THEN 1.0 ELSE 0 END) / NULLIF(COUNT(votes.id), 0)) AS percent_total')
    .left_outer_joins(:votes)
    .order('percent_total ASC NULLS LAST, votes DESC')
    .group('dishes.id')
    .limit(number) }
  scope :top_unrated, -> (user_id=nil, number=nil) {
    select('dishes.*', 'COUNT(votes.id) AS votes', '(SUM(CASE WHEN votes.up = true THEN 1.0 ELSE 0 END) / NULLIF(COUNT(votes.id), 0)) AS percent_total')
    .left_outer_joins(:votes)
    .order('percent_total DESC NULLS LAST, votes DESC')
    .group('dishes.id')
    .having('bool_and(votes.user_id != ? OR votes.user_id IS NULL)', user_id)
    .limit(number) }
end

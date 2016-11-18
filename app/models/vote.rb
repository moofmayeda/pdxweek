class Vote < ApplicationRecord
  belongs_to :dish
  belongs_to :team
  has_one :restaurant, through: :dish

  validates :user_id, uniqueness: { scope: [:dish, :team] }

  scope :up,    -> { where up: true }
  scope :down,  -> { where up: false }
  scope :by,    -> (user_id=nil) { where user_id: user_id }
  scope :team,  -> (team_id=nil) { where team_id: team_id }
  scope :category,  -> (category=nil) { joins(:dish).where('dishes.category = ?', category) }
  scope :year,  -> (year=nil) { joins(:dish).where('dishes.year = ?', year) }
end

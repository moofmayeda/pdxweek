class Restaurant < ApplicationRecord
  has_many :upvotes, through: :dishes, source: :upvotes
  has_many :downvotes,  through: :dishes, source: :downvotes
  has_many :votes, through: :dishes
  has_many :dishes, dependent: :destroy

  validates :name, uniqueness: true

  scope :participating, -> (category, year) { joins(:dishes).where('dishes.category = ? AND dishes.year = ?', category, year) }
end

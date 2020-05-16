class Work < ApplicationRecord
  has_many :votes
  has_many :users, through: :votes

  validates :title, presence: true

  def self.top_ten(category)
    return Work.where(category: category).max_by(10) {|work| work.votes.count}
  end

  def self.max_votes
    return Work.all.max_by {|work| work.votes.count}
  end
end

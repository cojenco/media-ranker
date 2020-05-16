class Work < ApplicationRecord
  has_many :votes
  has_many :users, through: :votes

  def self.top_ten(category)
    return Work.where(category: category).max_by(10) {|work| work.votes.count}
  end
end

class Work < ApplicationRecord
  # https://guides.rubyonrails.org/association_basics.html
  has_many :votes, dependent: :destroy
  has_many :users, through: :votes

  validates :title, presence: true
  validates :title, uniqueness: {scope: :category}

  def self.top_ten(category)
    return Work.where(category: category).max_by(10) {|work| work.votes.count}
  end

  def self.max_votes
    return Work.all.max_by {|work| work.votes.count}
  end

  def self.category_sort(category)
    return Work.where(category: category).sort_by{|work| -work.votes.count}
  end
end

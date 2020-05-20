class User < ApplicationRecord
  has_many :votes, dependent: :destroy
  has_many :works, through: :votes

  validates :username, presence: true, uniqueness: true
end

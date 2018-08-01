class Challenge < ApplicationRecord
  has_many :uploads, dependent: :destroy

  scope :starts_with, -> (challenge_title) { where("title ILIKE ?", "#{challenge_title}%")}

  validates :sponsor, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :points, presence: true
end

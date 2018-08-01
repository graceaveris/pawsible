class Upload < ApplicationRecord
  belongs_to :user
  belongs_to :challenge

  mount_uploader :media, MediaUploader

  validates :user_id, presence: true
  validates :challenge_id, presence: true, uniqueness: { scope: :user_id }
  validates :media, presence: true
end

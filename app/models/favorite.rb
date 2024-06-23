class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :notifications, dependent: :destroy

  validates_uniqueness_of :post_id, scope: :user_id
end

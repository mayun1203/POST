class Relationship < ApplicationRecord
  belongs_to :user
  belongs_to :follower, class_name: 'User'
  has_many :notifications, dependent: :destroy

  with_options presence: true do
    validates :user_id
    validates :follower_id
  end
end

class Relationship < ApplicationRecord
  belongs_to :user
  belongs_to :follower, class_name: 'User'

  with_options presence: true do
    validates :user_id
    validates :follower_id
  end
end

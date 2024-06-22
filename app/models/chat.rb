class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validate :message, presence: :true, length: {maxmum: 140}
end

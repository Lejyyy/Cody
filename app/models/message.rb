class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :user

  validates :content, presence: true
  validates :role, inclusion: { in: %w[user assistant] }
end

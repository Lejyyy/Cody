class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :project
  has_many :messages, dependent: :destroy

  validates :project_id, uniqueness: { scope: :user_id }
end

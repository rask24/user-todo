class Task < ApplicationRecord
  validates :title, presence: true
  belongs_to :user, -> { order("created_at desc") }
end
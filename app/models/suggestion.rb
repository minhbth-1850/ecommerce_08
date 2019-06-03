class Suggestion < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :describe, presence: true

  delegate :name, to: :user, prefix: :user

  scope :approve, ->(stt){where approved: stt unless stt.nil?}
  scope :sort_approve, ->{order(:approved)}
end

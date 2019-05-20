class User < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :orders, dependent: :destroy
  enum role: {customer: 0, admin: 1}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :address, presence: true
  validates :email, presence: true,
    length: {maximum: Settings.users.email_length},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :name, presence: true, length: {maximum: Settings.users.name_length}
  validates :password, presence: true,
    length: {minimum: Settings.users.pass_min_length}
  validates :phone, presence: true, numericality: true,
    length: {minimum: Settings.users.phone_min,
             maximum: Settings.users.phone_max}
  before_save{email.downcase!}
  has_secure_password
end

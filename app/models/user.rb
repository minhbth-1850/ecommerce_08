class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
    :rememberable, :validatable, :confirmable, :lockable,
    :timeoutable, :trackable, :omniauthable,
    omniauth_providers: [:facebook, :google_oauth2]

  has_many :reviews, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :suggestions, dependent: :destroy

  enum role: {customer: 0, admin: 1}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  attr_accessor :remember_token

  validates :address, presence: true
  validates :email, presence: true,
    length: {maximum: Settings.users.email_length},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :name, presence: true, length: {maximum: Settings.users.name_length}
  validates :password, presence: true, allow_nil: true,
    length: {minimum: Settings.users.pass_min_length}
  validates :phone, presence: true, numericality: true,
    length: {minimum: Settings.users.phone_min,
             maximum: Settings.users.phone_max}

  before_save{email.downcase!}

  scope :activates, ->{where activated: true}
  scope :order_option, ->(option){order(option => :DESC)}

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end

    def new_with_session params, session
      super.tap do |user|
        if data = session["devise.facebook_data"] &&
          session["devise.facebook_data"]["extra"]["raw_info"]
          user.email = data["email"] if user.email.blank?
        end
      end
    end

    def from_omniauth auth
      user = where(provider: auth.provider, uid: auth.uid).first
      return user if user

      user = User.new(email: auth.info.email,
                  name: auth.info.name,
                  phone: "012345678912",
                  address: "Not Provide!",
                  password: Devise.friendly_token[0,20],
                  provider: auth.provider,
                  uid: auth.uid)
      user.skip_confirmation!
      user.save
      user
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def get_avatar
    if provider == "facebook"
     return "http://graph.facebook.com/#{uid}/picture?type=large"
    end
    "http://www.aiszambia.com/image/avatar.png"
  end
end

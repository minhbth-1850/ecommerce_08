module UsersHelper
  def gravatar_for user, size = Settings.users.avatar_size
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
  end
end

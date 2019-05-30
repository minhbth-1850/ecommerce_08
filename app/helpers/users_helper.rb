module UsersHelper
  def load_user_roles
    User.roles.map{|k, _v| [k, k]}
  end
end

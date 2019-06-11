module UsersHelper
  SORT_OPTION = {created_at: 0, role: 1, name: 2}.freeze

  def load_options_user
    SORT_OPTION.map{|k, v| [I18n.t("sort_user")[k], v]}
  end

  def load_params_user sort_id
    option = SORT_OPTION.key(sort_id)
    option || SORT_OPTION.frist[0]
  end

  def load_user_roles
    User.roles.map{|k, _v| [k, k]}
  end

  def check_del_user user
    orders = user.orders.processing
    orders.each(&:cancelled!)
  end

  def current_user? user
    user == current_user
  end
end

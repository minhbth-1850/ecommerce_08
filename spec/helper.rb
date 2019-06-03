module Helpers
  def log_in_as user
    session[:user_id] = user.id
  end

  def log_out
    session.delete :user_id
  end
end

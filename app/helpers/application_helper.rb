module ApplicationHelper
  def display_name(user)
    user.profile&.nickname.presence || user.name
  end
end

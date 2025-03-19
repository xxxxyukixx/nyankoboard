class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  class ApplicationController < ActionController::Base
    def authenticate_user!
      unless current_user
        redirect_to new_user_session_path, alert: "この機能を使用するにはログインが必要です。"
      end
    end
  end
end

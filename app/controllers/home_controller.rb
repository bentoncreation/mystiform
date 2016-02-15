class HomeController < ApplicationController
  skip_before_filter :authenticate_user!

  def index
    if user_signed_in?
      @submissions = current_user.submissions
                                 .undeleted
                                 .order(created_at: :desc)
                                 .page(params[:page])
    else
      @user = User.new
    end
  end
end

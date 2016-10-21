class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    if current_user
      @recipes = current_user.recipes.order(:name)
    end
  end
end

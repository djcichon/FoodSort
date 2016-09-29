class HomeController < ApplicationController
  skip_before_action :authenticate_user!

	def index
		@recipes = Recipe.all.order(:name)
	end
end

class RecipesController < ApplicationController
  def new
		@recipe = Recipe.new
  end

  def create
		@recipe = current_user.recipes.create(recipe_params)

		if @recipe.save
			flash[:success] = "Recipe successfully added"
			redirect_to root_url
		else
			@recipe.errors.full_messages.each do |message|
				puts message
			end
			render 'new'
		end

  end

  def edit
  end

  def update
  end

	private
		def recipe_params
			params.require(:recipe).permit(:name, :category)
		end
end

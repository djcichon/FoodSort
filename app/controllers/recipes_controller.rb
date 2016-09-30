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
		@recipe = Recipe.find(params[:id])
  end

  def update
		@recipe = Recipe.find(params[:id])

		if @recipe.update_attributes(recipe_params)
			flash[:success] = "Recipe successfully updated"
			redirect_to root_url
		else
			render 'edit'
		end
  end

	private
		def recipe_params
			params.require(:recipe).permit(:name, :category)
		end
end

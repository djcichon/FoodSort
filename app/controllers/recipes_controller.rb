class RecipesController < ApplicationController
  def new
		@recipe = Recipe.new
  end

  def create
		puts "test"
		puts params.inspect
		puts recipe_params.inspect
		@recipe = current_user.recipes.create(recipe_params)

		if @recipe.save
			flash[:success] = "Recipe successfully added"
			redirect_to root_url
		else
			puts @recipe.errors.inspect
			render 'new'
		end

  end

  def edit
		@recipe = Recipe.find(params[:id])
  end

  def update
		puts "test"
		puts params.inspect
		puts recipe_params.inspect
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
			params.require(:recipe).permit(:name, :category, recipe_products_attributes: [:name, :id])
		end
end

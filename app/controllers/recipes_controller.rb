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
      render 'new'
    end

  end

  def edit
    @recipe = current_user.recipes.find_by(id: params[:id])

    unless @recipe
      flash[:danger] = "Recipe not found"
      redirect_to root_url
    end
  end

  def update
    @recipe = current_user.recipes.find_by(id: params[:id])

    unless @recipe
      flash[:danger] = "Recipe not found"
      redirect_to root_url
      return
    end

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

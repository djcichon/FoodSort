require 'test_helper'

class RecipesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:doug)
  end

  test "new should redirect to login when not signed in" do
    get new_recipe_url
    assert_redirected_to new_user_session_url
  end

  test "create should redirect to login when not signed in" do
    post recipes_url
    assert_redirected_to new_user_session_url
  end

  test "edit should redirect to login when not signed in" do
    get edit_recipe_url(1)
    assert_redirected_to new_user_session_url
  end

  test "update should redirect to login when not signed in" do
    patch recipe_url(1)
    assert_redirected_to new_user_session_url
  end

  test "should get new" do
    sign_in @user

    get new_recipe_url
    assert_response :success

    assert_select "h1", "Add Recipe"
    assert_select "h2", "Ingredients (0)"
  end

  test "create new recipe" do
    sign_in @user

    params = { 
      recipe: { 
        name: "Chocolate covered kale", 
        category: "Vegan",
        recipe_products_attributes: [ { name: "Chocolate" }, { name: "Kale" } ]
      } 
    }

    assert_difference "Recipe.count", 1 do
      post recipes_url, params: params
    end
    assert_redirected_to root_url

    recipe = Recipe.find_by(name: "Chocolate covered kale")

    assert_not_nil recipe
    assert_equal "Chocolate covered kale", recipe.name
    assert_equal "Vegan", recipe.category

    assert_equal 2, recipe.products.size
    assert_not_nil recipe.products.find_by(name: "Chocolate")
    assert_not_nil recipe.products.find_by(name: "Kale")
  end

  test "error while creating recipe" do
    sign_in @user

    # Create a recipe which with the same name
    recipe = @user.recipes.create(name: "Chocolate covered kale")

    params = { 
      recipe: { 
        name: "Chocolate covered kale", 
        category: "Vegan",
        recipe_products_attributes: [ { name: "Chocolate" }, { name: "Kale" } ]
      } 
    }

    assert_no_difference "Recipe.count" do
      post recipes_url, params: params
    end

    # Create page is rendered, and still has original arguments in it
    assert_select "h1", "Add Recipe"
    assert_select "h2", "Ingredients (2)"
    assert_select "li", "Chocolate"
    assert_select "li", "Kale"

    assert_select "div#error_messages", 1
  end

  test "should get edit" do
    sign_in @user

    recipe = recipes(:hotdogs)

    get edit_recipe_url(recipe)
    assert_response :success

    assert_select "h1", "Edit Recipe"
    assert_select "h2", "Ingredients (#{recipe.recipe_products.count})"

    recipe.recipe_products.each do |rp|
      assert_select "li", rp.name
    end
  end

  test "update a recipe" do
    sign_in @user

    # Create a recipe to update
    recipe = @user.recipes.create(name: "Chocolate covered kale")

    params = { 
      recipe: { 
        id: recipe.id,
        name: "Kale covered chocolate", 
        category: "Delicious",
        recipe_products_attributes: { "0": { name: "Chocolate" }, "1": { name: "Kale" } }
      } 
    }

    assert_no_difference "Recipe.count" do
      patch recipe_url(recipe.id), params: params
    end
    assert_redirected_to root_url

    recipe = Recipe.find(recipe.id)

    assert_not_nil recipe
    assert_equal params[:recipe][:name], recipe.name
    assert_equal params[:recipe][:category], recipe.category

    assert_equal 2, recipe.products.size
    assert_not_nil recipe.products.find_by(name: "Chocolate")
    assert_not_nil recipe.products.find_by(name: "Kale")
  end

  test "remove product from a recipe on update" do
    sign_in @user

    # Create a recipe to update
    recipe = recipes(:hotdogs)
    recipe_product = recipe_products(:hotdogs_hotdog_buns)

    params = { 
      recipe: { 
        id: recipe.id,
        name: recipe.name, 
        category: recipe.category,
        # Only list one ingredient
        recipe_products_attributes: {"0": { name: recipe_product.name, id: recipe_product.id } }
      } 
    }

    assert_no_difference "Recipe.count" do
      patch recipe_url(recipe.id), params: params
    end
    assert_redirected_to root_url

    recipe = recipe.reload

    assert_not_nil recipe
    assert_equal params[:recipe][:name], recipe.name
    assert_equal params[:recipe][:category], recipe.category

    assert_equal 1, recipe.products.size
    assert_not_nil recipe.products.find_by(name: "Hot dog buns")
  end

  test "error while updating recipe" do
    sign_in @user

    # Create a recipe to update
    recipe = @user.recipes.create(name: "Chocolate covered kale")

    # Create a recipe with a name we'll update to
    other_recipe = @user.recipes.create(name: "Kale covered chocolate")

    params = { 
      recipe: { 
        id: recipe.id,
        name: other_recipe.name, 
        category: "Delicious",
        recipe_products_attributes: { "0": { name: "Chocolate" }, "1": { name: "Kale" } }
      } 
    }

    assert_no_difference "Recipe.count" do
      patch recipe_url(recipe.id), params: params
    end

    # Edit page is rendered, and still has original arguments in it
    assert_select "h1", "Edit Recipe"
    assert_select "#recipe_name[value=?]", params[:recipe][:name]
    assert_select "#recipe_category[value=?]", params[:recipe][:category]
    assert_select "h2", "Ingredients (2)"
    assert_select "li", "Chocolate"
    assert_select "li", "Kale"
  end

  test "cannot edit another user's recipe" do
    recipe = @user.recipes.first
    other_user = users(:sara)

    sign_in other_user

    get edit_recipe_url(recipe)

    assert_redirected_to root_url
    assert_equal "Recipe not found", flash[:danger]
  end

  test "cannot update another user's recipe" do
    recipe = @user.recipes.first
    other_user = users(:sara)

    sign_in other_user

    params = { 
      recipe: { 
        id: recipe.id,
        name: "Kale covered chocolate", 
        category: "Delicious",
        recipe_products_attributes: [ { name: "Chocolate" }, { name: "Kale" } ]
      } 
    }

    patch recipe_url(recipe.id), params: params
    assert_redirected_to root_url
    assert_equal "Recipe not found", flash[:danger]
  end

  test "delete a recipe" do
    sign_in @user

    assert_difference "Recipe.count", -1 do
      delete recipe_path(@user.recipes.first)
    end

    assert_redirected_to root_url
    assert_equal "Recipe deleted", flash[:success]
  end

  test "cannot delete another user's recipe" do
    other_user = users(:sara)
    sign_in other_user

    assert_no_difference "Recipe.count" do
      delete recipe_path(@user.recipes.first)
    end

    assert_redirected_to root_url
    assert_equal "Recipe not found", flash[:danger]
  end
end

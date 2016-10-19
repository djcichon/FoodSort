require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  def setup
    @user = users(:doug)
  end

  test "user cannot create two recipes with the same name" do
    assert_difference 'Recipe.count', 1 do
      @user.recipes.create(name: "yummy")

      # Shouldn't be created since it already exists
      @user.recipes.create(name: "yummy")
    end
  end

  test "duplicate products by name should point to same product" do
    # Create a recipe with two of the same product
    recipe = @user.recipes.new(name: "yummy")
    recipe.recipe_products.new(name: "kale")
    recipe.recipe_products.new(name: "kale")

    assert recipe.valid?

    # Only one Product should be created when saving
    assert_difference 'Product.count', 1 do
      recipe.save
    end

    # After saving, both should point to the same product
    assert_equal 2, recipe.products.size
    assert_equal 2, recipe.recipe_products.size
    assert_equal recipe.products[0], recipe.products[1]
  end

  test "deleting a recipe should delete recipe products and products" do
    recipe = @user.recipes.create(name: "yummy")
    recipe_product = recipe.recipe_products.create(name: "kale")
    product = recipe.products[0]

    recipe.destroy

    assert recipe.destroyed?, "Recipe not destroyed"
    assert recipe_product.destroyed?, "RecipeProduct not destroyed"

    # Because product is destroyed through a callback, it seems destroyed? does not get set.
    is_product_destroyed = Product.find_by_id(product.id) == nil
    assert is_product_destroyed, "Product not destroyed"
  end

  test "deleting a recipe should not delete product if another recipe uses it" do
    # Create a recipe which uses kale as an ingredient
    yummy_recipe = @user.recipes.create(name: "yummy")
    yummy_recipe_product = yummy_recipe.recipe_products.create(name: "kale")
    yummy_product = yummy_recipe.products[0]

    # Create another recipe, which also uses kale
    tasty_recipe = @user.recipes.create(name: "tasty")
    tasty_recipe_product = tasty_recipe.recipe_products.create(name: "kale")
    tasty_product = tasty_recipe.products[0]

    # Delete the first recipe
    yummy_recipe.destroy

    # The recipe and recipe_product should be destroyed, but not the product
    assert yummy_recipe.destroyed?, "Recipe not destroyed"
    assert yummy_recipe_product.destroyed?, "RecipeProduct not destroyed"

    # Because product is destroyed through a callback, it seems destroyed? does not get set.
    is_product_destroyed = Product.find_by_id(yummy_product.id) == nil
    assert_not is_product_destroyed, "Product was destroyed"
  end
end

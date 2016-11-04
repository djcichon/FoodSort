class RecipeProduct < ApplicationRecord
  attr_accessor :name
  belongs_to :recipe, :inverse_of => :recipe_products
  belongs_to :product

  after_destroy :destroy_product_if_last_reference

  def name
    product.name unless product == nil
  end

  # Sets the product which corresponds to this name
  def name=(val)
    self.product = Product.find_or_initialize_by(name: val)
  end

  private
    def destroy_product_if_last_reference
      product.destroy if(product.recipe_products.size == 0)
    end
end

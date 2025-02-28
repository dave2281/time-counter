class PagesController < ApplicationController
  def main
    @pagy, @records = pagy(Product.some_scope)

  end
end

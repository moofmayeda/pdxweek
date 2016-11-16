class RestaurantsController < ApplicationController
  def index
    @pizza_restaurants = Restaurant.participating('pizza', 2016).includes(:dishes)
    @burger_restaurants = Restaurant.participating('hamburger', 2016).includes(:dishes)
    render 'index'
  end
end

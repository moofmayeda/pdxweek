class RestaurantsController < ApplicationController
  def index
    @pizza_restaurants = Restaurant.participating('pizza', 2016)
    @burger_restaurants = Restaurant.participating('burger', 2016)
    @dumpling_restaurants = Restaurant.participating('dumpling', 2016)
    render 'index'
  end
end

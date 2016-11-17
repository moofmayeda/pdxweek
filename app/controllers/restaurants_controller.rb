class RestaurantsController < ApplicationController
  http_basic_authenticate_with :name => "admin", :password => ENV['ADMIN_PASSWORD'], except: :home

  def home
    @pizza_restaurants = Restaurant.participating('pizza', 2016)
    @burger_restaurants = Restaurant.participating('burger', 2016)
    @dumpling_restaurants = Restaurant.participating('dumpling', 2016)
  end

  def index
    @restaurants = Restaurant.order(:name)
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    if @restaurant.save
      redirect_to restaurants_path
    else
      render 'new'
    end
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.update_attributes(restaurant_params)
      redirect_to restaurants_path
    else
      render 'edit'
    end
  end

private
  def restaurant_params
    params.require(:restaurant).permit(:name)
  end
end

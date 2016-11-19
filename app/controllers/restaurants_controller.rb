class RestaurantsController < ApplicationController
  http_basic_authenticate_with :name => "admin", :password => ENV['ADMIN_PASSWORD'], except: :home

  def home
  end

  def index
    @restaurants = Restaurant.order(:name)
  end

  def new
    @restaurant = Restaurant.new
    @restaurant.dishes.build
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
    @restaurant.dishes.build
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
    params.require(:restaurant).permit(:name, dishes_attributes: [:id, :name, :category, :year])
  end
end

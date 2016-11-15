class VotesController < ApplicationController
  def create
    @restaurant = Restaurant.find(params[:id])
    params[:vote] == "up" ? @restaurant.upvotes.create : @restaurant.downvotes.create
  end
end

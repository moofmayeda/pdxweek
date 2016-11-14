class VotesController < ApplicationController
  def create
    @restaurant = Restaurant.find(params[:id])
    params[:vote] == "up" ? @restaurant.upvotes.create : @restaurant.downvotes.create
    request.xhr? ? render('create') : render(json: @restaurant)
  end
end

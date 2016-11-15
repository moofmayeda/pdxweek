class WebhooksController < ApplicationController
  def slack
    not_found unless params[:token] == ENV['SLACK_TOKEN']
    text = "Sorry, I didn't get that. Try asking where to go or using the name of a restaurant with a plus to vote for it"
    case params[:text]
    when /new/
      text = "New spots for #{params[:user_name]}:\n" + ordered_list(Restaurant.top_unrated(params[:user_id]))
    when /best/
      text = "The current top 3 are:\n" + ordered_list(Restaurant.top(3))
    when /list/
      text = ordered_list(Restaurant.top)
    when /\+/
      restaurants = get_named_restaurants(params[:text])
      restaurants.each { |restaurant| restaurant.upvotes.create(user_id: params[:user_id]) }
      text = restaurants.map { |restaurant| "#{restaurant.name} now has #{restaurant.upvotes.count} upvotes and #{restaurant.downvotes.count} downvotes" }.join(', ') if restaurants.present?
    when /\-/
      restaurants = get_named_restaurants(params[:text])
      restaurants.each { |restaurant| restaurant.downvotes.create(user_id: params[:user_id]) }
      text = restaurants.map { |restaurant| "#{restaurant.name} now has #{restaurant.upvotes.count} upvotes and #{restaurant.downvotes.count} downvotes" }.join(', ') if restaurants.present?
    else
      restaurants = get_named_restaurants(params[:text])
      text = restaurants.map { |restaurant| "#{restaurant.name} now has #{restaurant.upvotes.count} upvotes and #{restaurant.downvotes.count} downvotes" }.join(', ') if restaurants.present?
    end
    render json: {'text' => text}
  end

private
  def get_named_restaurants(text)
    Restaurant.all.select { |restaurant| text.include? restaurant.name }
  end
end

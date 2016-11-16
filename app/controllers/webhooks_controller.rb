class WebhooksController < ApplicationController
  def slack
    not_found unless params[:token] == ENV['SLACK_TOKEN']
    text = "Sorry, I didn't get that. Say the name of a restaurant with a +/- to vote, or say 'new' to get the best places you haven't been to yet."
    case params[:text]
    when /\bnew\b/i
      text = "New spots for #{params[:user_name]}:\n" + ordered_list(Restaurant.top_unrated(params[:user_id]))
    when /\bhistory\b/i
      text = "#{params[:user_name]}'s voting history:\n" + Vote.by(params[:user_id]).order(created_at: :desc).map { |vote| "#{vote.restaurant.name} #{vote.up ? ':thumbsup:' : ':thumbsdown:'} #{vote.created_at.strftime('%a %-m-%-d')}" }.join("\n")
    when /\bbest\b/i
      text = "The current top 3 are:\n" + ordered_list(Restaurant.top(3))
    when /\bworst\b/i
      text = "The current bottom 3 are:\n" + ordered_list(Restaurant.bottom(3))
    when /\blist\b/i
      text = ordered_list(Restaurant.top)
    when /\+/
      restaurants = get_named_restaurants(params[:text])
      restaurants.each { |restaurant| restaurant.upvotes.create(user_id: params[:user_id]) }
      text = "#{params[:user_name]} just gave a :thumbsup: to "  + show_details(restaurants) if restaurants.present?
    when /\-/
      restaurants = get_named_restaurants(params[:text])
      restaurants.each { |restaurant| restaurant.downvotes.create(user_id: params[:user_id]) }
      text = "#{params[:user_name]} just gave a :thumbsdown: to "  + show_details(restaurants) if restaurants.present?
    else
      restaurants = get_named_restaurants(params[:text])
      text = show_details(restaurants) if restaurants.present?
    end
    render json: {'text' => text}
  end

private
  def get_named_restaurants(text)
    Restaurant.all.select { |restaurant| text.downcase.include? restaurant.name.downcase }
  end
end

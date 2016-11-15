class WebhooksController < ApplicationController
  def slack
    not_found unless params[:token] == ENV['SLACK_TOKEN']
    text = "Sorry, I didn't get that. Try asking where to go or using the name of a restaurant with a plus to vote for it"
    case params[:text]
    when /where/
      text = "The current top 3 are " + Restaurant.top(3).map(&:name).join(", ")
    when /\+/
      restaurants = get_named_restaurants(params[:text])
      restaurants.each { |restaurant| restaurant.upvotes.create }
      text = restaurants.map { |restaurant| "#{restaurant.name} now has #{restaurant.upvotes.count} upvotes and #{restaurant.downvotes.count} downvotes" }.join(', ') if restaurants.present?
    when /\-/
      restaurants = get_named_restaurants(params[:text])
      restaurants.each { |restaurant| restaurant.downvotes.create }
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

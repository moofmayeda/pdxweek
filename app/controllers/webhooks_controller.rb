class WebhooksController < ApplicationController
  def slack
    not_found unless params[:token] == ENV['SLACK_TOKEN']
    text = "Sorry, I didn't get that. Say the name of a restaurant with a +/- to vote, or say 'info' for a list of all keywords."
    case params[:text]
    when /\binfo\b/i
      text =  "Available keywords:\n"\
              "new : restaurants that you haven't been to yet, ranked from best to worst\n"\
              "history : your voting history\n"\
              "best : top 3 ranked restaurants\n"\
              "worst : bottom 3 ranked restaurants\n"\
              "list : all restaurants listed from best to worst to unrated\n"\
              "specific restaurant name : shows how many up and downvotes it has\n"\
              "specific restaurant name with a + or - : adds an up or downvote to that restaurant"
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

class WebhooksController < ApplicationController
  def slack
    category = params[:trigger_word][1..-2]
    not_found unless params[:token] == ENV['SLACK_TOKEN'] && ['hamburger', 'pizza'].include?(category)
    category = "burger" if category == "hamburger"
    text = "Sorry, I didn't get that. Say the name of a restaurant with a +/- to vote, or say 'info' for a list of all keywords."
    year = Time.now.year
    user_name = params[:user_name]
    case params[:text]
    when /\binfo\b/i
      text =  "_Available keywords_\n"\
              "*new*: restaurants that you haven't been to yet, ranked from best to worst\n"\
              "*history*: your voting history\n"\
              "*best*: top 3 ranked restaurants\n"\
              "*worst*: bottom 3 ranked restaurants\n"\
              "*list*: all restaurants listed from best to worst to unrated\n"\
              "*specific restaurant name*: show voting history for that restaurant\n"\
              "*specific restaurant name (with a + or -)*: adds an up or downvote to that restaurant\n"\
              "*info*: display this help menu"
    when /\bnew\b/i
      text = "New spots for #{user_name}:\n" + ordered_list(Dish.category(category).year(year).top_unrated(params[:user_id]).includes(:restaurant))
    when /\bhistory\b/i
      text = "#{user_name}'s voting history:\n" + Vote.category(category).year(year).by(params[:user_id]).order(created_at: :desc).map { |vote| "#{vote.restaurant.name} #{vote.up ? ':thumbsup:' : ':thumbsdown:'} #{vote.created_at.strftime('%a %-m-%-d')}" }.join("\n")
    when /\bbest\b/i
      text = "The current top 3 are:\n" + ordered_list(Dish.category(category).year(year).top(3).includes(:restaurant))
    when /\bworst\b/i
      text = "The current bottom 3 are:\n" + ordered_list(Dish.category(category).year(year).bottom(3).includes(:restaurant))
    when /\blist\b/i
      text = ordered_list(Dish.category(category).year(year).top.includes(:restaurant))
    when /\+/
      dishes = get_dishes_of_named_restaurants(params[:text], category, year)
      dishes.each { |dish| dish.upvotes.create(user_id: params[:user_id], user_name: user_name) }
      text = "#{user_name} just gave a :thumbsup: to "  + show_summary(dishes) if dishes.present?
    when /\-/
      dishes = get_dishes_of_named_restaurants(params[:text], category, year)
      dishes.each { |dish| dish.downvotes.create(user_id: params[:user_id], user_name: user_name) }
      text = "#{user_name} just gave a :thumbsdown: to "  + show_summary(dishes) if dishes.present?
    else
      dishes = get_dishes_of_named_restaurants(params[:text], category, year)
      text = show_full_details(dishes) if dishes.present?
    end
    render json: {'text' => text}
  end

private
  def get_dishes_of_named_restaurants(text, category, year)
    Dish.category(category).year(year).includes(:restaurant).select { |dish| text.downcase.include? dish.restaurant.name.downcase }
  end
end

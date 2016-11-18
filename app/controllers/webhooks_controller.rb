class WebhooksController < ApplicationController
  def slack
    category = params[:command][1..-1]
    not_found unless Rails.configuration.categories.include?(category) && ENV['SLACK_API_VERIFICATION_TOKEN'] == params[:token]
    team = Team.find_or_create_by(slack_id: params[:team_id]) do |t|
      t.name = params[:team_domain]
    end
    text = "Sorry, I didn't get that. Say the name of a restaurant with a +/- to vote, or say 'info' for a list of all keywords."
    year = Time.now.year
    user_name = params[:user_name]
    visibility = ""
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
      text = "New spots for #{user_name}:\n" + ordered_list(team, Dish.category(category).year(year).top_unrated(team.id, params[:user_id]).includes(:restaurant))
    when /\bhistory\b/i
      text = "#{user_name}'s voting history:\n" + Vote.category(category).year(year).team(team.id).by(params[:user_id]).order(created_at: :desc).map { |vote| "#{vote.restaurant.name} #{vote.up ? ':thumbsup:' : ':thumbsdown:'} #{vote.created_at.strftime('%a %-m-%-d')}" }.join("\n")
    when /\bbest\b/i
      text = "The current top 3 are:\n" + ordered_list(team, Dish.category(category).year(year).top(team.id, 3).includes(:restaurant))
    when /\bworst\b/i
      text = "The current bottom 3 are:\n" + ordered_list(team, Dish.category(category).year(year).bottom(team.id, 3).includes(:restaurant))
    when /\blist\b/i
      text = ordered_list(team, Dish.category(category).year(year).top(team.id).includes(:restaurant))
    when /\brandom\b/i
      text = show_summary(team, Dish.category(category).year(year).limit(1).order('RANDOM()').includes(:restaurant))
    when /\+/
      dishes = get_dishes_of_named_restaurants(params[:text], category, year)
      dishes.each { |dish| dish.create_or_update_vote(team, params[:user_id], params[:user_name], true) }
      if dishes.present?
        text = "#{user_name} just gave a :thumbsup: to "  + show_summary(team, dishes)
        visibility = 'in_channel'
      end
    when /\-/
      dishes = get_dishes_of_named_restaurants(params[:text], category, year)
      dishes.each { |dish| dish.create_or_update_vote(team, params[:user_id], params[:user_name], false) }
      if dishes.present?
        text = "#{user_name} just gave a :thumbsdown: to "  + show_summary(team, dishes)
        visibility = 'in_channel'
      end
    else
      dishes = get_dishes_of_named_restaurants(params[:text], category, year)
      text = show_full_details(team, dishes) if dishes.present?
    end
    render json: {'text': text, 'response_type': visibility }
  end

  def authorize
    redirect_to :root
  end

private
  def get_dishes_of_named_restaurants(text, category, year)
    Dish.category(category).year(year).includes(:restaurant).select do |dish|
      CGI::unescapeHTML(text).gsub(/[^0-9a-z]/i, '').downcase.include? dish.restaurant.name.gsub(/[^0-9a-z]/i, '').downcase
    end
  end
end

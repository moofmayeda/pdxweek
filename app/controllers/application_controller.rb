class ApplicationController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? }

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

protected
  def ordered_list(team, list)
    list.map.with_index { |dish, i| "#{i+1}. #{dish.restaurant.name} (#{dish.upvotes.team(team.id).count} - #{dish.downvotes.team(team.id).count}) #{':trophy:' if i == 0 }"}.join("\n")
  end

  def show_summary(team, list)
    list.map { |dish| "#{dish.restaurant.name} :thumbsup: #{dish.upvotes.team(team.id).count} :thumbsdown: #{dish.downvotes.team(team.id).count}" }.join("\n")
  end

  def show_full_details(team, list)
    result = list.map do |dish|
      text = "#{dish.restaurant.name}"
      text += "\n#{dish.upvotes.team(team.id).count} :thumbsup::"
      text += " _" + dish.upvotes.team(team.id).map(&:user_name).join(', ') + "_" if dish.upvotes.present?
      text += "\n#{dish.downvotes.team(team.id).count} :thumbsdown::"
      text += " _" + dish.downvotes.team(team.id).map(&:user_name).join(', ') + "_" if dish.downvotes.present?
      text
    end
    result.join("\n")
  end
end

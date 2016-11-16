class ApplicationController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? }

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

protected
  def ordered_list(list)
    list.map.with_index { |dish, i| "#{i+1}. #{dish.restaurant.name} (#{dish.upvotes.count} - #{dish.downvotes.count}) #{':trophy:' if i == 0 }"}.join("\n")
  end

  def show_details(list)
    list.map { |dish| "#{dish.restaurant.name} :thumbsup: #{dish.upvotes.count} :thumbsdown: #{dish.downvotes.count}" }.join("\n")
  end
end

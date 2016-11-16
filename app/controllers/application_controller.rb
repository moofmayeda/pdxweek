class ApplicationController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? }

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

protected
  def ordered_list(list)
    list.map.with_index { |dish, i| "#{i+1}. #{dish.restaurant.name} (#{dish.upvotes.count} - #{dish.downvotes.count}) #{':trophy:' if i == 0 }"}.join("\n")
  end

  def show_summary(list)
    list.map { |dish| "#{dish.restaurant.name} :thumbsup: #{dish.upvotes.count} :thumbsdown: #{dish.downvotes.count}" }.join("\n")
  end

  def show_full_details(list)
    result = list.map do |dish|
      text = "#{dish.restaurant.name}"
      text += "\n#{dish.upvotes.count} :thumbsup:: _" + dish.upvotes.map(&:user_name).join(', ') + "_"
      text += "\n#{dish.downvotes.count} :thumbsdown:: _" + dish.downvotes.map(&:user_name).join(', ') + "_"
    end
    result.join("\n")
  end
end

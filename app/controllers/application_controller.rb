class ApplicationController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? }

protected
  def ordered_list(number=nil)
    Restaurant.top(number).map.with_index { |restaurant, i| "#{i+1}. #{restaurant.name} (#{restaurant.upvotes.count} - #{restaurant.downvotes.count}) #{':trophy:' if i == 0 }"}.join("\n")
  end
end

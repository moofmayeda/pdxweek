class ApplicationController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? }

protected
  def ordered_list(list)
    list.map.with_index { |restaurant, i| "#{i+1}. #{restaurant.name} (#{restaurant.upvotes.count} - #{restaurant.downvotes.count}) #{':trophy:' if i == 0 }"}.join("\n")
  end

  def show_details(list)
    list.map { |restaurant| "#{restaurant.name} :thumbsup: #{restaurant.upvotes.count} :thumbsdown: #{restaurant.downvotes.count}" }.join("\n")
  end
end

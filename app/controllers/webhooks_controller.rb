class WebhooksController < ApplicationController
  def slack
    not_found unless params[:token] == ENV['SLACK_TOKEN']
    case params[:text]
    when /where/
      text = "The current top 3 are " + Restaurant.top(3).map(&:name).join(", ")
    else
      text = "Sorry, I didn't get that."
    end
    render json: {'text' => text}
  end
end

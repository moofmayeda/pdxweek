Rails.application.config.middleware.use OmniAuth::Builder do
  provider :slack, ENV['SLACK_API_KEY'], ENV['SLACK_API_SECRET'], scope: 'identity.basic', name: :sign_in_with_slack
  provider :slack, ENV['SLACK_API_KEY'], ENV['SLACK_API_SECRET'], scope: 'commands'
end

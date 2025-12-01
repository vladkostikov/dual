require 'sidekiq/web'
require 'sidekiq/throttled'
require "sidekiq/throttled/web"
require 'sidekiq_unique_jobs/web'

unless Rails.env.development?
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV['SIDEKIQ_USER'] && password == ENV['SIDEKIQ_PASSWORD']
  end
end

Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'] }
end

Sidekiq::Throttled::Registry.add(:mailer, threshold: { limit: 1, period: 5.seconds })

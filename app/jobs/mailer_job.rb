class MailerJob < ApplicationJob
  sidekiq_options queue: :mailers
  sidekiq_throttle_as :mailer
end

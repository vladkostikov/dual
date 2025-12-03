class ApplicationJob
  include Sidekiq::Job
  include Sidekiq::Throttled::Job
end

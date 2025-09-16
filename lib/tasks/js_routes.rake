# frozen_string_literal: true

require 'js-routes'

namespace :js_routes do
  desc 'Generate js routes for webpack'
  task generate: :environment do
    routes_dir = Rails.root.join('app', 'javascript', 'routes')
    FileUtils.mkdir_p(routes_dir)

    file_name = routes_dir.join('ApiRoutes.js')
    JsRoutes.generate!(file_name.to_s, camel_case: true)
  end
end

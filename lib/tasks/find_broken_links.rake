namespace :pick do
  desc "Pick broken links from the routes files"
  task :broken_links_from_routes => :environment do

    all_routes = Rails.application.routes.routes
    application_url = []
    all_routes.each do |ar|
      application_url << ar.path.spec.to_s.split("(")[0]
    end

    application_url.reject! { |r| r =~ %r{/rails/info/properties|^/assets} }
    application_url.uniq!

    application_url.each do |u|
      if Rails.env == 'production'
        root = 'production_url'
      else
        root = 'http://localhost:3000'
      end
      url = root.concat(u)
      uri = URI.parse(url)
      response = nil
      Net::HTTP.start(uri.host, uri.port) { |http|
        response = http.head(uri.path.size > 0 ? uri.path : "/")
        if response.code == "404"
          puts "Broken link ====> #{url}"
        end
      }
    end
  end
end
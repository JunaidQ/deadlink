namespace :pick do
  desc "Pick manual broken link"
  task :manual_link => :environment do
    if Rails.env == 'production'
      root = 'production_url'
    else
      root = 'http://localhost:3000'
    end

    puts "Enter specific link with compny address ====> /some-link: "
    u = STDIN.gets.chomp
    url = root.concat(u)
    uri = URI.parse(url)
    puts "===> uri #{uri}"
    response = nil
    Net::HTTP.start(uri.host, uri.port) { |http|
      response = http.head(uri.path.size > 0 ? uri.path : "/")
      if response.code == "404"
        puts "broken link"
      else
        puts "not broken link"  
      end
    }
  end
end
require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'restclient'

class Scraper
  
  puts "Choose SubReddit:"
  subreddit = gets
  puts "Folder to save too"
  folder = gets

  Dir.mkdir(folder) unless File.directory? folder

  doc = open("http://www.reddit.com/r/#{subreddit}") { |f| Hpricot(f) }
  links = doc.search("//a[@class='title ']")
  links.map! { |link| "#{link['href']}" }

  links.each do |link|
    if File.extname(link) != "" 
      File.open("#{folder}/" + File.basename(link), 'w') do
        |img| img.write(RestClient.get(link)) 
      end    
    end
  end
end
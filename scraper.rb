require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'restclient'

class Scraper

#Asks user to choose subreddit and directory to save to
  puts "Choose SubReddit:"
  subreddit = gets
  puts "Directory to save to"
  direc = gets

#Creates directory if the directory doesn't already exist
  Dir.mkdir direc unless File.directory? direc

#Gets subreddit and pulls out image links
  doc = open("http://www.reddit.com/r/#{subreddit}") { |f| Hpricot(f) }
  links = doc.search("//a[@class='title ']")
  links.map! { |link| "#{link['href']}" }

#If link does not have a blank file extension then save file
  links.each do |link|
    if File.extname(link) != "" 
      File.open("#{direc}/" + File.basename(link), 'w') do
        |i| i.write(RestClient.get(link))
      end    
    end
  end
end
require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'restclient'

class Scraper

  # Gets given subreddit and passes user information
  def initialize(subreddit, direc, pages)
    @doc = open("http://www.reddit.com/r/#{subreddit}") { |f| Hpricot(f) }
    make_dir(direc)
    set_counter(pages)
    get_links
  end

  #Creates named directory
  def make_dir(direc)
    @direc = direc
    Dir.mkdir direc unless File.directory? direc
  end

  #Sets Counter and given user pages
  def set_counter(pages)
    @counter = 0
    @pages = pages.to_i
  end

  #Increments the counter by one and compares counter to pages 
  def page_counter
    @counter+=1
    puts "Page #{@counter} done"
    get_next_page until @counter >= @pages
  end

  #Gets all of the image links
  def get_links
    links = @doc.search("//a[@class='title ']")
    links.map! { |link| "#{link['href']}" } 
    save_files(links)
  end

  #Gets next page link and opens the next page
  def get_next_page
    nextlink = @doc.search("//p[@class='nextprev']/a[@rel='nofollow next']")
    nextlink.map! { |link| "#{link['href']}" }
    stringlink = nextlink[0]
    @doc = open(stringlink) { |f| Hpricot(f) }
    get_links
  end

  #Writes image files to given directory
  def save_files(links)
    links.each do |link|
      if File.extname(link) != "" 
        File.open("#{@direc}/" + File.basename(link), 'w') { |i| i.write(RestClient.get(link)) }    
      end
    end
    page_counter
  end
end

  #Gather User input
  puts "/r/ "
  subreddit = gets
  puts "Directory to save to: "
  direc = gets
  puts "Number of pages to scrape: "
  pages = gets

  s = Scraper.new(subreddit, direc, pages)


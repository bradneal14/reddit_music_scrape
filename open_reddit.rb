
require "open-uri"
require 'json'
require "tempfile"
require 'watir-webdriver'
require "phantomjs"

b = Watir::Browser.new :firefox
b.goto 'www.anything2mp3.com'
f = b.form(:id, "videoconverter-convert-form")
b.text_field(:id, 'edit-url').set('https://www.youtube.com/watch?v=bQDcSkGWvfc&nohtml5=False')
f.submit
b.button(:class => 'success').wait_until_present
puts b.title
b.close

## https://watirwebdriver.com/waiting/

data_from_reddit = open("http://www.reddit.com/r/listentothis/top.json?sort=top&t=month&limit=10")


def find_title(thing)
  #this method iterates through the data for each post it is given
  #then it adds all of the titles from the data to an array and returns that array
  all_titles = []
  thing["data"]["children"].each do |post|
    all_titles << post["data"]["url"]
  end
  p all_titles
end

def make_string(data)
  ## this method takes what the reddit api returns, determines its type,
  ## does the appropriate ready-ing and then sends it to find_title
  if data.class == Tempfile
    p "temp"
    closer =  IO.read(data.path)
    ready_version = JSON.parse(closer)
    return ready_version
  elsif data.class == StringIO
    p "stringIO"
    ready_version = JSON.parse(data.string)
    return ready_version
  end
end


def execute_everything(data)
  # this method just calls the other two methods in order
  objectified_data = make_string(data)
  find_title(objectified_data)
end



#
#
# execute_everything(data_from_reddit)

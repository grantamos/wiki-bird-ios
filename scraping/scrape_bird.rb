require 'nokogiri'
require 'open-uri'
require "awesome_print"
require 'sqlite3'
require 'json'

birds = [
  'https://en.wikipedia.org/wiki/Fulvous_Whistling_Duck'
]

base_content_url = "http://en.wikipedia.org/w/api.php?action=parse&format=json&prop=text&section=0&redirects&page="

for birdURL in birds

  bird_page_name = birdURL.split('/')[-1]

  summary_json = JSON.parse(open(base_content_url + bird_page_name).read)
  summary_html = summary_json['parse']['text']['*']
  summary_text = Nokogiri::HTML(summary_html)
  summary_text.search('.//div').remove
  summary_text.search('.error').remove
  summary_text = summary_text.text.strip

  ap summary_text

end
require 'nokogiri'
require 'open-uri'
require "awesome_print"
require 'sqlite3'
require 'json'

db = SQLite3::Database.new( 'birds.db' )

birdURLs = db.execute("SELECT url FROM Bird LIMIT 10")
birdURLs = birdURLs.flatten

base_content_url = "http://en.wikipedia.org/w/api.php?action=parse&format=json&prop=text&section=0&page="

for birdURL in birdURLs
  bird_page_name = birdURL.split('/')[-1]

  summary_json = JSON.parse(open(base_content_url + bird_page_name).read)
  summary_html = summary_json['parse']['text']['*']
  summary_text = Nokogiri::HTML(summary_html).inner_text.trim

  bird_page = Nokogiri::HTML(open(birdURL))

end

<<-BLAH
bird_list_page = Nokogiri::HTML(open(bird_list_url))

bird_groups = []
group = false

bird_list_page.at_css("#mw-content-text").children.each do |node|
  if node.name == "h2"

    group = {
      'description' => "",
      'order' => "",
      'family' => "",
      'birds' => [],
      'name' => node.at_css("span.mw-headline").text
    }

    bird_groups.push(group)
  elsif group
    if node.name == "p"
      text = node.text

      if text == ""
        next
      end

      if group['order'] != ""
        group['description'] = text
      elsif !text.include?("Order:")
        bird_groups.delete(group)
        next
      else
        order_match = /Order:\W*(\w*)/.match(text)
        family_match = /Family:\W*(\w*)/.match(text)
        group['order'] = order_match[1]
        group['family'] = family_match[1]
      end
    elsif node.name == "ul"
      group['birds'].push(gatherBirds(node))
    end
  end
end

for group in bird_groups

  if group['order'] == ""
    next;
  end

  db.execute("INSERT INTO BirdGroup (name, description, scientific_order, scientific_family) VALUES (?, ?, ?, ?)", [group['name'], group['description'], group['order'], group['family']])
end

BLAH

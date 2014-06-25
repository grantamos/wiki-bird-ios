require 'nokogiri'
require 'open-uri'
require "awesome_print"
require 'sqlite3'

db = SQLite3::Database.new( 'birds.db' )

db.execute "DROP TABLE IF EXISTS Bird"
db.execute "DROP TABLE IF EXISTS BirdGroup"

db.execute <<-SQL
  CREATE TABLE Bird (
    common_name TEXT,
    scientific_name TEXT,
    url TEXT,
    description TEXT,
    bird_id INTEGER PRIMARY KEY,
    fk_bird_group_id INT,
    FOREIGN KEY(fk_bird_group_id) REFERENCES BirdGroup(bird_group_id)
  );
SQL

db.execute <<-SQL
  CREATE TABLE BirdGroup (
    name TEXT,
    description TEXT,
    scientific_order TEXT,
    scientific_family TEXT,
    bird_group_id INTEGER PRIMARY KEY
  );
SQL

def gatherBirds(node)
  birds = []

  node.children.each do |item|
    if item.name == 'li'
      bird = {}

      link = item.at_css('a')

      if link
        bird['common_name'] = link.text
        bird['url'] = "http://en.wikipedia.org" + link['href']
      end

      scientific_name = item.at_css('i')
      if scientific_name
        bird['scientific_name'] = scientific_name.text
      end

      birds.push(bird)
    end

    birds.push(gatherBirds(item))
  end

  return birds.flatten
end

bird_list_url = "http://en.wikipedia.org/wiki/List_of_birds_of_Canada_and_the_United_States"

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
      group['birds'] = gatherBirds(node)
    end
  end
end

for group in bird_groups

  if group['order'] == ""
    next;
  end

  db.execute("INSERT INTO BirdGroup (name, description, scientific_order, scientific_family) VALUES (?, ?, ?, ?)", [group['name'], group['description'], group['order'], group['family']])

  bird_group_id = db.last_insert_row_id

  for bird in group['birds']
    db.execute("INSERT INTO Bird (common_name, scientific_name, url, fk_bird_group_id) VALUES (?, ?, ?, ?)", [bird['common_name'], bird['scientific_name'], bird['url'], bird_group_id])
  end
end

#ap bird_groups
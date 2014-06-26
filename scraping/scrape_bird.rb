require 'nokogiri'
require 'open-uri'
require "awesome_print"
require 'sqlite3'
require 'json'

db = SQLite3::Database.new( 'birds.db' )

<<-TODO

db.execute "DROP TABLE IF EXISTS BirdDetail"

db.execute <<-SQL
  CREATE TABLE BirdDetail (
    header_name TEXT,
    content_text TEXT,
    bird_detail_id INTEGER PRIMARY KEY,
    fk_bird_id INT,
    FOREIGN KEY(fk_bird_id) REFERENCES Bird(bird_id)
  );
SQL

TODO

birds = db.execute("SELECT bird_id, url FROM Bird")

base_content_url = "http://en.wikipedia.org/w/api.php?action=parse&format=json&prop=text&section=0&redirects&page="

for bird in birds

  bird_id = bird[0]
  birdURL = bird[1]
  bird_page_name = birdURL.split('/')[-1]

  summary_json = JSON.parse(open(base_content_url + bird_page_name).read)
  summary_html = summary_json['parse']['text']['*']
  summary_text = Nokogiri::HTML(summary_html).search('.//div').remove
  summary_text = summary_text.text

  ap summary_text

  db.execute("UPDATE Bird SET description=? WHERE bird_id=?", [summary_text, bird_id])

end
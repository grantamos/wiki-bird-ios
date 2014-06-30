require 'nokogiri'
require 'open-uri'
require 'awesome_print'
require 'json'

def gatherBirds(node)
  birds = {}

  node.children.each do |item|
    if item.name == 'li'
      bird = {}

      link = item.at_css('a')

      if link
        bird['commonName'] = link.text
        bird['url'] = "http://en.wikipedia.org" + link['href']
      end

      scientific_name = item.at_css('i')
      if scientific_name
        bird['scientificName'] = scientific_name.text
      end

      birds[bird['commonName']] = bird
    end

    birds.merge(gatherBirds(item))
  end

  return birds
end

def getBirdIntro(birdURL)
  base_content_url = "http://en.wikipedia.org/w/api.php?action=parse&format=json&prop=text&section=0&redirects&page="

  bird_page_name = birdURL.split('/')[-1]

  summary_json = JSON.parse(open(base_content_url + bird_page_name).read)
  parseResult = summary_json['parse']
  if parseResult == nil
    return nil
  end

  textResult = parseResult['text']

  if textResult
    return nil
  end

  summary_html = textResult['*']

  if summary_html == nil
    return nil
  end

  summary_text = Nokogiri::HTML(summary_html)
  summary_text.search('.//div').remove
  summary_text.search('.error').remove
  summary_text = summary_text.text.strip

  summary_text
end

states = {
  "Alaska" => "http://en.wikipedia.org/wiki/List_of_birds_of_Alaska",
  "Arizona" => "http://en.wikipedia.org/wiki/List_of_birds_of_Arizona",
  "California" => "http://en.wikipedia.org/wiki/List_of_birds_of_California",
  "Colorado" => "http://en.wikipedia.org/wiki/List_of_birds_of_Colorado",
  "Connecticut" => "http://en.wikipedia.org/wiki/List_of_birds_of_Connecticut",
  "Georgia" => "http://en.wikipedia.org/wiki/List_of_birds_of_Georgia_(U.S._state)",
  "Hawaii" => "http://en.wikipedia.org/wiki/List_of_birds_of_Hawaii",
  "Idaho" => "http://en.wikipedia.org/wiki/List_of_birds_of_Idaho",
  "Illinois" => "http://en.wikipedia.org/wiki/List_of_birds_of_Illinois",
  "Indiana" => "http://en.wikipedia.org/wiki/List_of_birds_of_Indiana",
  "Iowa" => "http://en.wikipedia.org/wiki/List_of_birds_of_Iowa",
  "Kansas" => "http://en.wikipedia.org/wiki/List_of_birds_of_Kansas",
  "Maine" => "http://en.wikipedia.org/wiki/List_of_birds_of_Maine",
  "Maryland" => "http://en.wikipedia.org/wiki/List_of_birds_of_Maryland",
  "Massachusetts" => "http://en.wikipedia.org/wiki/List_of_birds_of_Massachusetts",
  "Michigan" => "http://en.wikipedia.org/wiki/List_of_birds_of_Michigan",
  "Minnesota" => "http://en.wikipedia.org/wiki/List_of_birds_of_Minnesota",
  "Missouri" => "http://en.wikipedia.org/wiki/List_of_birds_of_Missouri",
  "Montana" => "http://en.wikipedia.org/wiki/List_of_birds_of_Montana",
  "Nebraska" => "http://en.wikipedia.org/wiki/List_of_birds_of_Nebraska",
  "Nevada" => "http://en.wikipedia.org/wiki/List_of_birds_of_Nevada",
  "New Jersey" => "http://en.wikipedia.org/wiki/List_of_birds_of_New_Jersey",
  "New Mexico" => "http://en.wikipedia.org/wiki/List_of_birds_of_New_Mexico",
  "New York" => "http://en.wikipedia.org/wiki/List_of_birds_of_New_York",
  "North Carolina" => "http://en.wikipedia.org/wiki/List_of_birds_of_North_Carolina",
  "North Dakota" => "http://en.wikipedia.org/wiki/List_of_birds_of_North_Dakota",
  "Ohio" => "http://en.wikipedia.org/wiki/List_of_birds_of_Ohio",
  "Oklahoma" => "http://en.wikipedia.org/wiki/List_of_birds_of_Oklahoma",
  "Oregon" => "http://en.wikipedia.org/wiki/List_of_birds_of_Oregon",
  "Pennsylvania" => "http://en.wikipedia.org/wiki/List_of_birds_of_Pennsylvania",
  "South Carolina" => "http://en.wikipedia.org/wiki/List_of_birds_of_South_Carolina",
  "South Dakota" => "http://en.wikipedia.org/wiki/List_of_birds_of_South_Dakota",
  "Texas" => "http://en.wikipedia.org/wiki/List_of_birds_of_Texas",
  "Utah" => "http://en.wikipedia.org/wiki/List_of_birds_of_Utah",
  "Vermont" => "http://en.wikipedia.org/wiki/List_of_birds_of_Vermont",
  "Washington" => "http://en.wikipedia.org/wiki/List_of_birds_of_Washington",
  "West Virginia" => "http://en.wikipedia.org/wiki/List_of_birds_of_West_Virginia",
  "Wisconsin" => "http://en.wikipedia.org/wiki/List_of_birds_of_Wisconsin",
  "Wyoming" => "http://en.wikipedia.org/wiki/List_of_birds_of_Wyoming",
}

birds = {}
birdGroups = {}

states.each do |stateName, url|

  print "Parsing data for " + stateName + " at " + url + "\n"

  birdListPage = Nokogiri::HTML(open(url))
  group = false

  birdListPage.at_css("#mw-content-text").children.each do |node|

    if node.name == "h2"

      groupName = node.at_css("span.mw-headline").text
      group = {
        'birds' => []
      }

      if birdGroups[groupName]
        group = birdGroups[groupName]
      else
        birdGroups[groupName] = group
      end

      group['name'] = groupName

    elsif group

      if node.name == "p"
        text = node.text

        if text == ""
          next
        end

        if group['order'] && group['order'] != ""
          group['description'] = text

        elsif !text.include?("Order:")
          birdGroups.delete(group['name'])
          group = false
          next

        else
          orderMatch = /Order:\W*(\w*)/.match(text)
          familyMatch = /Family:\W*(\w*)/.match(text)
          group['order'] = orderMatch[1]
          group['family'] = familyMatch[1]

        end

      elsif node.name == "ul"

        if !group['order'] || group['order'] == ""
          birdGroups.delete(group['name'])
          group = false
          next

        end

        print "Catching " + group['name'] + "....\n"
        newBirds = gatherBirds(node)
        newBirds.each { |birdName, bird|
          bird['states'] = [stateName]
          bird['groups'] = [group['name']]
        }

        birds = birds.merge(newBirds){ |key, oldval, newval|
          newval['states'] = newval['states'].push(oldval['states']).flatten.uniq
          newval['groups'] = newval['groups'].push(oldval['groups']).flatten.uniq
          newval
        }

        group['birds'] = group['birds'].push(newBirds.keys).flatten

      end
    end
  end
end

elapsedTime = []

calculateETA = lambda {
  if elapsedTime.length == 40
    elapsedTime.shift
  end

  elapsedTime.push(Time.now)

  eta = 0

  elapsedTime.each_with_index do |time, index|
    if index == 0
      next
    end

    eta = eta + (time - elapsedTime[index - 1])
  end

  return eta / elapsedTime.length
}

birds.each_with_index do |(birdName, bird), index|
  eta = calculateETA.call * (birds.length - index)
  eta = (eta*100).to_i / 100.0
  print eta.to_s + " seconds remaining - " + index.to_s + "/" + birds.length.to_s + ": Getting bird info " + bird['url'] + "\n"
  bird['intro'] = getBirdIntro(bird['url'])
end

File.open('wikiBird.json', 'w') { |file|
  output = {
    'birds' => birds,
    'birdGroups' => birdGroups
  }

  file.write(JSON.pretty_generate(output))
}
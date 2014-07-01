require 'json'
require 'awesome_print'

input = JSON.parse(IO.read('wikiBird.json'))
birds = input['birds']
birdGroups = input['birdGroups']

mergeFilename = 'mergeConfig.json'
mergeKeys = {}

if File.file?(mergeFilename)
  mergeKeys = JSON.parse(IO.read(mergeFilename))
else

  groupCollection = {}

  birdGroups.each do |groupName, group|
    order = groupCollection[group['order']]
    if order == nil
      order = {}
    end

    family = order[group['family']]
    if family == nil
      family = []
    end

    family.push(groupName)

    order[group['family']] = family
    groupCollection[group['order']] = order
  end

  ap groupCollection

  groupCollection.each do |order, families|

    families.each do |family, names|

      winningGroupName = nil

      if names.length <= 1
        print "Short names\n"
        next
      end

      names.each_with_index do |groupName, index|

        if mergeKeys[groupName]
          print "Key exists\n"
          winningGroupName = mergeKeys[groupName]
          break
        end

        print (index + 1).to_s + ": " + groupName + "\n"
      end

      if winningGroupName == nil
        winningGroupName = names[gets.chomp().to_i - 1]
        print "\n\n"
      end

      names.each do |group|
        mergeKeys[group] = winningGroupName
      end
    end
  end

  File.open(mergeFilename, 'w') { |file|
    file.write(JSON.pretty_generate(mergeKeys))
  }

end

birds.delete_if do |birdName, bird|
  if bird['scientificName'] == nil
    print "Deleting " + birdName + "\n"
    true
  end
end

birdGroups.each do |birdGroupName, birdGroup|
  birdGroup['birds'] = birdGroup['birds'].uniq
  
  birdGroup['birds'].delete_if do |birdName|
    if birds[birdName] == nil
      true
    end
  end

  birdGroup['birds'].each do |birdName|
    bird = birds[birdName]

    if bird == nil
      next
    end

    if bird['scientificName'] == nil
      birds.delete(birdName)
      next
    end

    bird.delete('groups')
  end
end

mergeKeys.each do |oldKey, newKey|

  if oldKey == newKey
    next
  end

  oldGroup = birdGroups[oldKey]
  newGroup = birdGroups[newKey]

  oldGroup = oldGroup.merge(newGroup){ |key, oldval, newval|
    if key == "birds"
      newval = newval.push(oldval).flatten.uniq
    end

    newval
  }

  birdGroups[newKey] = oldGroup
  birdGroups.delete(oldKey)

  oldGroup['birds'].each do |birdName|
    bird = birds[birdName]

    if bird['group']
      if bird['group'] == newKey
        next
      end
      print birdName + " has already been assigned a group: " + bird['group'] + " -> " + newKey + "\n"
    end

    bird['group'] = newKey
    bird.delete('groups')
  end
end

File.open('wikiBird.json', 'w') { |file|
  output = {
    'birds' => birds,
    'birdGroups' => birdGroups
  }

  file.write(JSON.pretty_generate(output))
}

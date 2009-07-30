require 'common'

tests = File.read('test.txt', 100)
(users, repos) = get_users_repos
# user -> repos
usermap = read_outfile('usermap.txt')
# user -> languages
user_lang_map = read_outfile('user_lang_map.txt')
# project -> languages
project_lang_map = read_outfile('lang.txt')


guesses = {}

time = Time.now()

tests.split("\n").each do |uid|
  uid = uid.strip.to_i
  puts uid
  next if !usermap[uid]
  
  common = {}

  usermap[uid].each do |compid|
    next if compid == uid
    users[compid].each do |repoid|
      common[repoid] ||= 0
      # higher score if the users share a lot of projects
      common[repoid] += (users[compid].size / usermap[uid].size) * ((usermap[uid] & usermap[compid]).size + 1)
      next if project_lang_map[repoid].nil? or user_lang_map[uid].nil?
    end
  end
  project_lang_map.each do |repoid, languages|
    common[repoid] ||= 0
    common[repoid] += (user_lang_map[uid].keys & languages.keys).size
#    languages.each_pair do |language, lines|
#      begin
#        next if user_lang_map[uid].empty? or user_lang_map[uid][language].nil?
#      rescue Exception => ex
#        puts 'user: ', uid
#        puts 'user languages:', user_lang_map[uid].inspect
#        puts 'language:', language.inspect
#        exit(0)
#      end
#      # high score if the repo and user share lots of LOC and the user doesn't watch many repos
#      common[repoid] += usermap[uid].size / ((lines.to_i) / (user_lang_map[uid][language].to_i + 1) + 1)
#    end
  end
  friends = common.sort { |a, b| a[1] <=> b[1] }.reverse[0, 10]
  friends = friends.map { |a| a[0] }
  guesses[uid] = friends
  
end

puts Time.now() - time

write_outfile(guesses)
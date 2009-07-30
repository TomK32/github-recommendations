require 'common'

tests = File.read('test.txt', 100)
(users, repos) = get_users_repos
usermap = read_outfile('usermap.txt')
user_lang_map = read_outfile('user_lang_map.txt')
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
      # higher score if both users share a lot of projects
      common[repoid] += usermap[uid].size / ((usermap[uid] & usermap[compid]).size + 1)
      next if project_lang_map[repoid].nil? or user_lang_map[uid].nil?
      project_lang_map[repoid].each_pair do |language, lines|
        begin
          next if user_lang_map[uid].empty? or user_lang_map[uid][language].nil?
        rescue Exception => ex
          puts user_lang_map[uid].inspect
          puts language.inspect
          exit(0)
        end
        # high score if the repo and user share lots of LOC and the user doesn't watch many repos
        common[repoid] += usermap[uid].size / ((lines.to_i) / (user_lang_map[uid][language].to_i + 1) + 1)
      end
      
    end
  end
  friends = common.sort { |a, b| a[1] <=> b[1] }.reverse[0, 10]
  puts y friends
  friends = friends.map { |a| a[0] }
  guesses[uid] = friends
  
end

puts Time.now() - time

write_outfile(guesses)
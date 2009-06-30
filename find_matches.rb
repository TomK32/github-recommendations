require 'common'

tests = File.read('test.txt')
(users, repos) = get_users_repos
usermap = read_outfile('usermap.txt')

guesses = {}

time = Time.now()

tests.split("\n").each do |uid|
  uid = uid.strip.to_i
  next if !usermap[uid]
  
  common = {}

  usermap[uid].each do |compid|
    next if compid == uid
    users[compid].each do |repoid|
      common[repoid] ||= 0
      common[repoid] += 1
    end
  end

  friends = common.sort { |a, b| a[1] <=> b[1] }.reverse[0, 10]  
  friends = friends.map { |a| a[0] }
  guesses[uid] = friends
  
  puts uid
end

puts Time.now() - time

write_outfile(guesses)
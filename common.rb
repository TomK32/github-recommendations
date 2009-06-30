require 'pp'

def write_outfile(guesses, outfile = 'results.txt')
  File.open(outfile, 'w+') do |f|
    guesses.each do |uid, ids|
      f.puts "#{uid}:#{ids.join(',')}"
    end
  end
end

def read_outfile(outfile)
  guesses = {}
  lines = File.readlines(outfile)
  lines.each do |line|
    line = line.strip
    (uid, rids) = line.split(':')
    rid_arr = rids.split(',').map { |id| id.to_i } rescue []
    guesses[uid.to_i] = rid_arr
  end
  guesses
end

def get_users_repos
  results = File.read('data.txt')

  users = {}
  repos = {}

  counter = 0
  results.each do |res|
    counter += 1

    (uid, rid) = res.strip.split(":")
    uid = uid.to_i
    rid = rid.to_i
  
    users[uid] ||= []
    users[uid] << rid
    repos[rid] ||= []
    repos[rid] << uid
  end

  return [users, repos]
end
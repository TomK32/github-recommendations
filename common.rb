require 'pp'
require 'yaml'

def write_outfile(guesses, outfile = 'results.txt')
  File.open(outfile, 'w+') do |f|
    guesses.each do |uid, ids|
      if ids.is_a?(Hash)
        f.puts [uid, ids.to_a.flatten.compact.map{|k| k.to_a.compact.join(';')}.join(',') ].join(':')
      else
        f.puts "#{uid}:#{ids.join(',')}"
      end
    end
  end
end

def read_outfile(outfile)
  guesses = {}
  lines = File.readlines(outfile)
  lines.each do |line|
    line = line.strip
    (uid, rids) = line.split(':')
    rid_arr = rids.split(',').map do |id| 
      if id.match ';'
        {id.split(';')[0] => id.split(';')[1]}
      else
        id.to_i 
      end
    end rescue []
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
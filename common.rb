require 'pp'
require 'yaml'


def write_outfile(guesses, outfile = 'results.txt')
  File.open(outfile, 'w+') do |f|
    guesses.each do |uid, ids|
      if ids.is_a?(Hash)
        f.puts [uid, ids.to_a.compact.map{|k| k.to_a.compact.join(';')}.join(',') ].join(':')
      else
        f.puts "#{uid}:#{ids.join(',')}"
      end
    end
  end
end

def read_outfile(outfile, num_of_lines = false)
  guesses = {}
  lines = File.readlines(outfile)
  if num_of_lines
    lines = lines[(lines.size / 2 - num_of_lines)..(lines.size / 2 + num_of_lines)]
  end
  lines.each do |line|
    line = line.strip
    (uid, rids) = line.split(':')
    rid_result = if rids.match(/;/)
      result = {}
      rids.split(',').map do |entry| 
        result[entry.split(';')[0]] = entry.split(';')[1]
      end
      result
    else
      rids.split(',').map {|id| id.to_i }
    end rescue []
    guesses[uid.to_i] = rid_result
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

# creates the neighborhood space

require 'common'
require 'yaml'
(users, repos) = get_users_repos

project_lang_map = read_outfile('lang.txt')

user_lang_map = {}

total = users.size
done = 0
users.each do |user_id, repoids|
  languages = {}
  repoids.each do |repo_id|
    next if project_lang_map[repo_id].nil?
    project_lang_map[repo_id].each do |entry|
      entry.each_pair do |language, lines|
        languages[language] ||= 0
        languages[language] += lines.to_i
      end
    end
  end
  user_lang_map[user_id] = languages
  
  done += 1
  left = total - done
  if (left % 100) == 0
    puts left
  end
  
end

write_outfile(user_lang_map, 'user_lang_map.txt')

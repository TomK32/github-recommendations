# creates the neighborhood space

require 'common'

(users, repos) = get_users_repos

usermap = {}

total = users.size
done = 0
users.each do |user_id, repoids|
  friends = {}
  repoids.each do |repo_id|
    repos[repo_id].each do |uid|
      friends[uid] ||= 0
      friends[uid] += 1
    end
  end

  friends = friends.sort { |a, b| a[1] <=> b[1] }.reverse[0, 30]
  friends = friends.map { |a| a[0] }
  usermap[user_id] = friends
  
  done += 1
  left = total - done
  if (left % 100) == 0
    puts left
  end
  
end

write_outfile(usermap, 'usermap.txt')

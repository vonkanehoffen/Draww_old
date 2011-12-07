module PostsHelper
  def join_tags(post)
    post.tags.map { |t| t.name }.join(", ")
  end
    
  def belongs_to_current_user(post)
    if post.user == current_user 
      return true
    else
      return false
    end
  end
end

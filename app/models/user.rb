class User < ActiveRecord::Base
  acts_as_authentic
  has_many :posts
  has_many :comments
  has_many :votes
  has_many :liked_posts, :through => :votes
    
  def author_score
    posts.inject(1){|s,p| s += p.votes_score}
  end
  
  def casting_power # points of posts created
    author_score # should perhaps be a % of all author scores or post scores or some such...
  end
  
  def vote!(post)
    v = votes.build(:post => post)
    v.save! if v.valid?
    v
  end
  
end
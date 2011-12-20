class User < ActiveRecord::Base
  acts_as_authentic do |config|
    config.validate_email_field    = false
    config.validate_login_field    = false
    config.validate_password_field = false
  end

  has_many :posts
  has_many :comments
  has_many :votes
  has_many :liked_posts, :through => :votes
  
  def author_score
    posts.inject(1){|s,p| s += p.votes_score}
  end
  
  def casting_power # points of posts created
    author_score
  end
  
  def vote!(post)
    votes.create!(:post => post)
  end
  
end
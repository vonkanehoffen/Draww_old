class User < ActiveRecord::Base
  
  # TODO: Add Twitter / Faebook OAuth
  # TODO: Add Website / Gravatar Icon / About you fields
  
  acts_as_authentic do |c|
    # TODO: This raises "unknown attribute: password_confirmation" for edit user action
    c.ignore_blank_passwords = true #ignoring passwords
    c.validate_password_field = false #ignoring validations for password fields
  end
  
  has_many :posts
  has_many :comments
  has_many :votes
  has_many :liked_posts, :through => :votes
  has_many :authentications, :dependent => :destroy
    
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
  
  def self.create_from_hash(hash)
    # TODO: Twitter doesn't supply email in OAuth. Need to drop validation and maybe ask user for it
    puts "CREATING USER FROM HASH".log_red
    user = User.new(:username => hash['info']['name'].scan(/[a-zA-Z0-9_]/).to_s.downcase, :email => "testing@test.loc")
    user.save! #create the user without performing validations. This is because most of the fields are not set.
    user.reset_persistence_token! #set persistence_token else sessions will not be created
    user
  end
  
end
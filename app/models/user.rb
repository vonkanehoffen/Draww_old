class User < ActiveRecord::Base
  
  # TODO: Add Website / Gravatar Icon / About you fields

  attr_accessor :created_from_oauth

  acts_as_authentic do |c|
    c.merge_validates_confirmation_of_password_field_options({:unless => :created_from_oauth})
    c.merge_validates_length_of_password_field_options({:unless => :created_from_oauth})
    c.merge_validates_length_of_password_confirmation_field_options({:unless => :created_from_oauth})
    c.merge_validates_length_of_email_field_options({:unless => :created_from_oauth})
    c.merge_validates_format_of_email_field_options({:unless => :created_from_oauth})
    c.merge_validates_uniqueness_of_email_field_options({:unless => :created_from_oauth})
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
    v = votes.create!(:post => post)
  end
  
  def self.create_from_hash(hash)
    # puts "CREATING USER FROM HASH".log_red
    # user = User.new(:username => hash['info']['name'].scan(/[a-zA-Z0-9_]/).to_s.downcase, :email => "testing_tw@test.loc", :created_from_oauth => true )
    user = User.new(:username => hash['info']['name'].scan(/[a-zA-Z0-9_]/).to_s.downcase, :created_from_oauth => true )
    user.save! #create the user without performing validations. This is because most of the fields are not set.
    user.reset_persistence_token! #set persistence_token else sessions will not be created
    user
  end
  
end
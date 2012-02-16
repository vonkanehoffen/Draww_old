class Authentication < ActiveRecord::Base
  # attr_accessible :user_id, :provider, :uid
  belongs_to :user
  validates_presence_of :user_id, :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider
  
  def self.find_from_hash(hash)
    find_by_provider_and_uid(hash['provider'], hash['uid'])
  end
    
  def self.create_from_hash(hash, user = nil)
    # puts "CREATING AUTH FROM HASH".log_red
    user ||= User.create_from_hash(hash)
    Authentication.create(:user_id => user.id, :uid => hash['uid'], :provider => hash['provider'])
  end
end

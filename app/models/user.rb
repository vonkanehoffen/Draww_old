class User < ActiveRecord::Base
  acts_as_authentic
  has_many :posts
  has_many :comments
end
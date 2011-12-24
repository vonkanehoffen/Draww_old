class Relationship < ActiveRecord::Base
  belongs_to :post
  belongs_to :parent, :class_name => "Post", :foreign_key => "relation_id"
end

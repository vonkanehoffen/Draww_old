class RemovePostIdFromTags < ActiveRecord::Migration
  def change
    remove_index :tags, :post_id
  end
end

class RemovePostAssociationFromTags < ActiveRecord::Migration
  # Note: the last one with remove_index didn't work
  def change
    remove_column :tags, :post_id
  end
end

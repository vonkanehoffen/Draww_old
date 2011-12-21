class AddParentIdToPosts < ActiveRecord::Migration
  def up
    add_column :posts, :parent_id, :integer
  end
  def down
    remove_column :posts, :parent_id
  end
end

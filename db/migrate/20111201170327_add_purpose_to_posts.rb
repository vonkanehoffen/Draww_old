class AddPurposeToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :purpose, :string
  end
end

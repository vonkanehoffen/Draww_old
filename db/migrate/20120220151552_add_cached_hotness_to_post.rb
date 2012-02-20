class AddCachedHotnessToPost < ActiveRecord::Migration
  def change
    add_column :posts, :cached_hotness, :float
  end
end

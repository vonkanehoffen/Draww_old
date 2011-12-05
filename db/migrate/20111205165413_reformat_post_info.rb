class ReformatPostInfo < ActiveRecord::Migration
  def change
    change_table :posts do |t|
      t.rename :content, :description
      t.remove :name, :purpose
    end
  end
end

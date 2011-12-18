class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.float :points
      t.integer :user_id
      t.integer :post_id

      t.timestamps
    end
  end
end

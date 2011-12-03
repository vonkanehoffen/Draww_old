class AddUserToPosts < ActiveRecord::Migration
  def change
    change_table :posts do |t|
        t.references :user
      end
  end
end

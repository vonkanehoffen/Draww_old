class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :post_id
      t.integer :relation_id

      t.timestamps
    end
  end
end

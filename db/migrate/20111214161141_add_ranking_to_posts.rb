class AddRankingToPosts < ActiveRecord::Migration
  def up
    add_column :posts, :upvote, :integer
    add_column :posts, :downvote, :integer
    add_column :posts, :rank, :bigint
  end
  def down
    remove_column :posts, :upvote
    remove_column :posts, :downvote
    remove_column :posts, :rank
  end
end

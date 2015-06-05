class AddVotesToConvos < ActiveRecord::Migration
  def change
    add_column :convos, :upvotes, :decimal
    add_column :convos, :downvotes, :decimal
  end
end

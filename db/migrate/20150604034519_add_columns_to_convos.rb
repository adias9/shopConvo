class AddColumnsToConvos < ActiveRecord::Migration
  def change
    add_column :convos, :url, :text
    add_column :convos, :color, :string
    add_column :convos, :img_url, :text
  end
end

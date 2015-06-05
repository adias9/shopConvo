class AddColumnsToKimonoapis < ActiveRecord::Migration
  def change
    add_column :kimonoapis, :brand, :string
    add_column :kimonoapis, :api_id, :string
    add_column :kimonoapis, :api_key, :string
    add_column :kimonoapis, :api_token, :string
  end
end

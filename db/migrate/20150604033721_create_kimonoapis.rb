class CreateKimonoapis < ActiveRecord::Migration
  def change
    create_table :kimonoapis do |t|

      t.timestamps
    end
  end
end

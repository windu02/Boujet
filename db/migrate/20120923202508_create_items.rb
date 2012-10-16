class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
        t.string :name
        t.string :type
        t.string :color
        t.float :price
        t.text :other
        t.integer :user_id
      t.timestamps
    end
  end
end

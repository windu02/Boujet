class CreateSells < ActiveRecord::Migration
  def change
    create_table :sells do |t|
      t.integer :user_id, :null => false
      t.boolean :current, :null => false, :default => true
      t.float :total
      t.string :payment
      t.float :cashdone
      t.timestamps
    end
  end
end

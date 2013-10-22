class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street1
      t.string :street2
      t.string :street3
      t.string :zipcode
      t.string :city
      t.integer :user_id
      
      t.timestamps
    end
  end
end
